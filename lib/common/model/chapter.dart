import 'dart:convert';

import 'package:json2dart_db/json2dart_db.dart';
import 'package:json2dart_safe/json2dart.dart';

class Chapter with BaseDbModel {
  int? start;
  String? chapterTitle;
  int? end;
  String? content;
  int? chapterId;

  Chapter({
    this.start,
    this.chapterTitle,
    this.end,
    this.content,
    this.chapterId,
  });

  @override
  int get hashCode => chapterId ?? chapterTitle.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is Chapter) {
      return other.chapterId == chapterId;
    }
    return super == other;
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{}
      ..put('start', start)
      ..put('chapter_title', chapterTitle)
      ..put('end', end)
      ..put('content', content)
      ..put('chapter_id', chapterId);
  }

  Map<String, dynamic> toDataBaseMap(String content) {
    return <String, dynamic>{}
      ..put('start', start)
      ..put('chapter_title', chapterTitle)
      ..put('end', end)
      ..put('content', content)
      ..put('chapter_id', chapterId);
  }

  Chapter.fromJson(Map json) {
    start = json.asInt('start');
    chapterTitle = json.asString('chapter_title');
    end = json.asInt('end');
    content = json.asString('content');
    chapterId = json.asInt('chapter_id');
  }

  static Chapter toBean(Map json) => Chapter.fromJson(json);

  @override
  Map<String, dynamic> primaryKeyAndValue() => {"chapter_id": chapterId};

  @override
  String toString() => jsonEncode(toJson());
}
