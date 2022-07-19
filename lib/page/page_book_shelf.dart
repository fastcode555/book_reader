import 'package:book_reader/database/db_manager.dart';
import 'package:book_reader/page/controller/page_reader_controller.dart';
import 'package:book_reader/res/index.dart';
import 'package:book_reader/res/strings.dart';
import 'package:book_reader/widgets/book_shelf_widget.dart';
import 'package:flutter/material.dart';

import '../res/strings.dart';

class PageBookShelf extends StatefulWidget {
  static const String routeName = "/page/PageBookShelf";

  const PageBookShelf({Key? key}) : super(key: key);

  @override
  _PageBookShelfState createState() => _PageBookShelfState();
}

class _PageBookShelfState extends State<PageBookShelf> {
  ReaderController controller = Get.find<ReaderController>();
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    controller.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.white,
      titleId: Ids.bookshelf,
      centerTitle: false,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: controller.importBook,
          icon: const Icon(Icons.add, color: Colours.ff323232),
        ),
        _buildEditWidget(),
      ],
      body: Obx(
        () {
          return BookshelfWidget(
            books: controller.bookModels.value,
            isEdit: _isEdit,
            deleteCallback: (book) {
              DbManager.instance.bookModelDao.delete(book);
              controller.bookModels.remove(book);
            },
          );
        },
      ),
    );
  }

  void _deleteBook() {
    setState(() {
      _isEdit = !_isEdit;
    });
  }

  Widget _buildEditWidget() {
    if (_isEdit) {
      return TextButton(onPressed: _deleteBook, child: Text(Ids.finish.tr));
    } else {
      return IconButton(
        onPressed: _deleteBook,
        icon: const Icon(
          Icons.edit,
          color: Colours.ff323232,
          size: 20,
        ),
      );
    }
  }
}
