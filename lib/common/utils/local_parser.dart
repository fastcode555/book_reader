import 'dart:convert';
import 'dart:io';

import 'package:book_reader/common/model/book_model.dart';
import 'package:book_reader/common/model/chapter.dart';
import 'package:book_reader/database/chapter_dao.dart';
import 'package:book_reader/database/db_manager.dart';
import 'package:book_reader/res/index.dart';
import 'package:path/path.dart';

/// @date 2/5/22
/// describe:
///一次性最多读取多少位
const int _maxPosition = 50000;

class LocalParser {
  static final RegExp _preChapterRegex =
      RegExp(r"^(\\s{0,10})((\u5e8f[\u7ae0\u8a00]?)|(\u524d\u8a00)|(\u6954\u5b50))(\\s{0,10})", multiLine: true);
  static final RegExp _authorRegex = RegExp(r'(?<=\u4f5c\u8005\uff1a).*?$', multiLine: true);
  static final List<RegExp> _chapterRegexs = [
    RegExp(
        "^(.{0,8})(\u7b2c)([0-9\u96f6\u4e00\u4e8c\u4e24\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341\u767e\u5343\u4e07\u58f9\u8d30\u53c1\u8086\u4f0d\u9646\u67d2\u634c\u7396\u62fe\u4f70\u4edf]{1,10})([\u7ae0\u8282\u56de\u96c6\u5377])(.{0,30})\$",
        multiLine: true),
    RegExp("^(\\s{0,4})(\u6b63\u6587)(.{0,20})\$", multiLine: true),
    RegExp("^(.{0,4})(Chapter|chapter)(\\s{0,4})([0-9]{1,4})(.{0,30})\$", multiLine: true)
  ];

  String? path;
  File? file;

  LocalParser(this.path) {
    file = File(path!);
  }

  ///上次访问文件所在的位置
  int startPosition = 0;
  int lastPosition = _maxPosition;

  ///一次性拿出多少字符进行解析
  Future<String> _read() async {
    if (file!.existsSync()) {
      try {
        Stream<List<int>> inputStream = file!.openRead(startPosition, lastPosition);
        Stream<String> _stream = await utf8.decoder.bind(inputStream);
        String result = await _stream.last;
        return result;
      } catch (e) {
        if (e is StateError) {
          return "";
        }
        if (e is FileSystemException) {
          print(e);
          return "";
        }
        lastPosition++;
        return _read();
      }
    }
    return Future.value("");
  }

  ///根据输入的内容，读取指定长度的文本
  Future<String> read([int? start, int? end]) async {
    if (file!.existsSync()) {
      try {
        Stream<List<int>> inputStream = file!.openRead(start, end);
        Stream<String> _stream = await utf8.decoder.bind(inputStream);
        String result = await _stream.last;
        return result;
      } catch (e) {
        if (e is StateError) {
          return "";
        }
        if (e is FileSystemException) {
          print(e);
          return "";
        }
        return read(start, end! + 1);
      }
    }
    return Future.value("");
  }

  ///解析章节内容
  Future<BookModel> parse() async {
    BookModel _bookModel = BookModel(path: path);
    _bookModel.md5Id = Md5Util.generateMd5(path!);

    BookModel? _book = await DbManager.instance.bookModelDao.queryOne(_bookModel.md5Id!);
    if (_book != null) return _book;

    _bookModel.title = basenameWithoutExtension(path!);

    //为每本书都创建一个table，以存储相关的文本
    String tableName = "chapter_${_bookModel.md5Id}";
    DbManager.instance.chapterDao.execute(ChapterDao.tableSql(tableName));

    String content = await _read();

    //获取到作者的名称
    try {
      RegExpMatch? _authorMatch = _authorRegex.firstMatch(content);
      _bookModel.author = _authorMatch?.group(0);
    } catch (e) {
      print(e);
    }

    //进行章节分割
    List<Chapter> _chapters = [];
    await _splitChapter(_chapters, content);

    //最后一章，章节总数未知，需要计算出来，后面才能根据计算阅读整数的百分比
    Chapter _chapter = _chapters[_chapters.length - 1];
    String _lastChapterContent = await read(_chapter.start, _chapter.end);
    List<int> bytes = utf8.encode(_lastChapterContent);
    _chapter.end = _chapter.start! + bytes.length;

    _bookModel.chapterCount = _chapters.length;
    _bookModel.chapter = _chapters;
    _bookModel.wordCount = _chapter.end;

    //由于macos不知怎么去获取读取文件的权限，所以分割后，获取章节的内容,并存储到数据库中
    for (Chapter chapter in _chapters) {
      String _chapterContent = await read(chapter.start, chapter.end);
      DbManager.instance.chapterDao.insertMap(chapter.toDataBaseMap(_chapterContent), tableName);
    }
    return _bookModel;
  }

  ///章节分割
  _splitChapter(List<Chapter> chapters, String content) async {
    //分割章节
    for (RegExp _chapterRegex in _chapterRegexs) {
      Iterable<RegExpMatch> iterable = _chapterRegex.allMatches(content);
      if (iterable.isEmpty) continue;
      for (RegExpMatch reg in iterable) {
        String? title = reg.group(0);
        if (TextUtil.isEmpty(title)) continue;
        int index = content.indexOf(title!);
        String _head = content.substring(0, index);
        List<int> _headBytes = utf8.encode(_head);
        Chapter _chapter = Chapter(chapterTitle: title);
        _chapter.start = startPosition + _headBytes.length;

        if (chapters.isEmpty) {
          Chapter _preChapter = Chapter();
          _preChapter.start = 0;
          _preChapter.end = _headBytes.length;
          chapters.add(_preChapter);
        }
        //赋予前一章文章结束的节点,且赋值前一章的内容
        chapters[chapters.length - 1].end = _chapter.start;
        chapters.add(_chapter);
      }
    }

    startPosition = lastPosition;
    lastPosition = lastPosition + _maxPosition;
    String _content = await _read();
    if (TextUtil.isEmpty(_content.trim())) return;
    await _splitChapter(chapters, _content);
  }
}
