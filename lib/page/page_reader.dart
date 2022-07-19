import 'package:book_reader/common/model/book_model.dart';
import 'package:book_reader/common/model/chapter.dart';
import 'package:book_reader/common/model/reader_theme.dart';
import 'package:book_reader/page/controller/page_reader_controller.dart';
import 'package:book_reader/page/widgets/page_controller_widget.dart';
import 'package:book_reader/page/widgets/reader_app_bar.dart';
import 'package:book_reader/res/index.dart';
import 'package:flutter/material.dart';

/// @date 26/4/22
/// describe:

class PageReader extends BaseView<ReaderController> {
  static const String routeName = "/page/PageReader";

  ReaderTheme get _readTheme => controller.readerTheme.value;

  Color? get _backgroundColor => _readTheme.background;

  Color? get _fontColor => _readTheme.fontColor;

  String? get _fontFamily => _readTheme.font?.fontFamily;
  final ValueNotifier<int> _chapterNotifier = ValueNotifier(0);

  BookModel? _bookModel;
  final ValueNotifier<bool> _notifier = ValueNotifier(true);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is BookModel) {
      _bookModel = Get.arguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Stack(
          children: [
            _readWidget(),
            ValueListenableBuilder<bool>(
              valueListenable: _notifier,
              builder: (_, value, child) {
                return AnimatedPositioned(
                  left: 0,
                  right: 0,
                  top: _notifier.value ? -50 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: ReaderAppBar(_readTheme, _bookModel),
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _notifier,
              builder: (_, value, child) {
                return AnimatedPositioned(
                  left: 0,
                  right: 0,
                  bottom: _notifier.value ? -380 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const PageControllerWidget(),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _readWidget() {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: GestureDetector(
        onTap: () {
          _notifier.value = !_notifier.value;
        },
        child: Column(
          children: [
            Expanded(
              child: _ReaderListView(
                _bookModel!,
                chapterNotifier: _chapterNotifier,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 30,
              child: Row(
                children: [
                  Text(
                    _bookModel?.title ?? "",
                    style: TextStyle(
                      fontSize: 10,
                      color: _fontColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: _fontFamily,
                    ),
                  ),
                  const Spacer(),
                  ValueListenableBuilder<int>(
                    valueListenable: _chapterNotifier,
                    builder: (_, pageIndex, child) {
                      Chapter? chapter = controller.getChapter(pageIndex);
                      String? title = chapter?.chapterTitle;
                      title = TextUtil.isEmpty(title?.trim()) ? '' : '($title)';
                      return Text(
                        '$title${(chapter?.chapterId ?? 0)}/${_bookModel!.chapterCount}',
                        style: TextStyle(
                          fontSize: 10,
                          color: _fontColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily,
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ReaderListView extends StatefulWidget {
  final BookModel bookModel;
  final ValueNotifier<int>? chapterNotifier;

  const _ReaderListView(this.bookModel, {this.chapterNotifier, Key? key}) : super(key: key);

  @override
  __ReaderListViewState createState() => __ReaderListViewState();
}

class __ReaderListViewState extends State<_ReaderListView> {
  ReaderController controller = Get.find<ReaderController>();

  ReaderTheme get _readTheme => controller.readerTheme.value;

  Color? get _fontColor => _readTheme.fontColor;

  double? get _fontSize => _readTheme.fontSize;

  double get _padding => _readTheme.paddingType;

  double get _letterHeight => _readTheme.letterHeight;

  String? get _fontFamily => _readTheme.font?.fontFamily;

  @override
  void initState() {
    super.initState();
    controller.queryChapters(widget.bookModel, 1).then((value) {
      controller.chapters.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ScrollIndexWidget(
          callback: (int firstIndex, int lastIndex) {
            debugPrint("打印当前的Widget:$firstIndex,$lastIndex");
            widget.chapterNotifier?.value = firstIndex;
            if (lastIndex == controller.chapters.length - 1) {
              controller.queryChapters(widget.bookModel);
            }
          },
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: _padding),
            itemBuilder: (_, index) {
              Chapter chapter = controller.chapters[index];
              return Text(
                chapter.content ?? "",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _fontColor,
                  fontFamily: _fontFamily,
                  fontWeight: FontWeight.w500,
                  height: _letterHeight,
                ),
              );
            },
            itemCount: controller.chapters.length,
          ),
        );
      },
    );
  }
}
