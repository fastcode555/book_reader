import 'dart:async';

import 'package:json2dart_db/database/base_db_manager.dart';
import 'package:sqflite/sqflite.dart';

import 'book_model_dao.dart';
import 'chapter_dao.dart';
import 'font_eg_dao.dart';

class DbManager extends BaseDbManager {
  static DbManager? _instance;

  factory DbManager() => _getInstance();

  static DbManager get instance => _getInstance();

  static DbManager _getInstance() {
    _instance ??= DbManager._internal();
    return _instance!;
  }

  DbManager._internal();

  @override
  FutureOr<void> onUpgrade(Database db, int oldVersion, int newVersion) {
    onCreate(db, newVersion);
    return super.onUpgrade(db, oldVersion, newVersion);
  }

  @override
  FutureOr<void> onCreate(Database db, int version) async {
    await db.execute(FontEgDao.tableSql());
    await db.execute(ChapterDao.tableSql());
    await db.execute(BookModelDao.tableSql());
  }

  @override
  int getDbVersion() => 2;

  BookModelDao? _bookModelDao;

  BookModelDao get bookModelDao => _bookModelDao ??= BookModelDao();

  ChapterDao? _chapterDao;

  ChapterDao get chapterDao => _chapterDao ??= ChapterDao();

  FontEgDao? _fontEgDao;

  FontEgDao get fontEgDao => _fontEgDao ??= FontEgDao();
}
