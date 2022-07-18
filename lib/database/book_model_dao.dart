import 'package:book_reader/common/model/book_model.dart';
import 'package:book_reader/database/db_manager.dart';
import 'package:json2dart_db/json2dart_db.dart';

class BookModelDao extends BaseDao<BookModel> {
  static const String _tableName = "book_model";

  BookModelDao() : super(_tableName, "md5_id");

  static String tableSql([String? tableName]) => ""
      "CREATE TABLE IF NOT EXISTS `${tableName ?? _tableName}` ("
      "`cover` TEXT,"
      "`path` TEXT,"
      "`chapter` TEXT,"
      "`wordCount` INTEGER,"
      "`md5_id` TEXT PRIMARY KEY,"
      "`author` TEXT,"
      "`description` TEXT,"
      "`title` TEXT,"
      "`chapter_count` INTEGER)";

  @override
  BookModel fromJson(Map json) => BookModel.fromJson(json);

  @override
  Future<int> delete(BookModel? t, [String? tableName]) async {
    //删除书籍也需要跟着删除书籍所带有的所有章节内容
    await DbManager.instance.chapterDao.clear("chapter_${t?.md5Id}");
    return super.delete(t, tableName);
  }
}
