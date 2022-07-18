import 'package:book_reader/common/model/book_model.dart';
import 'package:book_reader/common/model/chapter.dart';
import 'package:book_reader/common/model/font_eg.dart';
import 'package:book_reader/page/controller/page_reader_controller.dart';
import 'package:book_reader/res/index.dart';
import 'package:flutter/cupertino.dart';

class PageContents extends StatelessWidget {
  BookModel? bookModel;

  PageContents(this.bookModel, {Key? key}) : super(key: key);

  FixedExtentScrollController? scrollController = FixedExtentScrollController();

  @override
  Widget build(BuildContext context) {
    Color? color = Get.find<ReaderController>().readerTheme.value.fontColor;
    FontEg? font = Get.find<ReaderController>().readerTheme.value.font;
    return CupertinoPicker.builder(
      itemExtent: 41,
      //item的高度
      onSelectedItemChanged: (index) {},
      scrollController: scrollController,
      selectionOverlay: Row(
        children: [
          Container(color: color, width: 8, height: 41),
          const Spacer(),
          Container(color: color, width: 8, height: 41),
        ],
      ),
      itemBuilder: (_, index) {
        Chapter _chapter = bookModel!.chapter![index];
        return Container(
          alignment: Alignment.center,
          child: Text(
            _chapter.chapterTitle ?? "",
            style: TextStyle(
              fontSize: 15,
              color: color,
              fontFamily: font?.fontFamily,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
      childCount: bookModel?.chapter?.length ?? 0,
    );
  }
}
