import 'package:flutter/material.dart';

class SliverTitle extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final TextAlign? textAlign;

  const SliverTitle(this.title, {Key? key, this.style, this.textAlign = TextAlign.center}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Text(
        title,
        style: style,
        textAlign: this.textAlign,
      ),
    );
  }
}
