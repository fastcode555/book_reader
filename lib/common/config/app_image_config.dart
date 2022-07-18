import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinity_core/core.dart';

class AppImageConfig extends ImageLoaderConfigInterface {
  @override
  LoadingErrorWidgetBuilder getErrorBuilder(double? width, double? height, double? border, Color? borderColor) {
    double? _width = (width ?? 0) > (height ?? 0) ? height : width;
    _width = ((_width ?? 0) / 3.0);
    _width = _width == 0 ? null : _width;
    return (BuildContext context, String url, _) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: border == null || border == 0.0
              ? null
              : Border.all(color: borderColor ?? Colors.transparent, width: border),
          color: Colors.black12,
        ),
        alignment: Alignment.center,
        child: SizedBox(
          width: _width ?? 60.w,
          height: _width ?? 60.w,
          child: const Icon(Icons.broken_image_rounded, color: Colors.blueAccent),
        ),
      );
    };
  }

  @override
  PlaceholderWidgetBuilder getPlaceBuilder(double? width, double? height, double? border, Color? borderColor) {
    double? _width = (width ?? 0) > (height ?? 0) ? height : width;
    _width = ((_width ?? 0) / 3.0);
    _width = _width == 0 ? null : _width;
    return (BuildContext context, String url) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: border == null || border == 0.0
              ? null
              : Border.all(color: borderColor ?? Colors.transparent, width: border),
          color: Colors.black12,
        ),
        alignment: Alignment.center,
        child: const SizedBox(
          //width: _width ?? 60.w,
          //height: _width ?? 60.w,
          child: CupertinoActivityIndicator(color: Colors.white),
        ),
      );
    };
  }

  @override
  getCircleErrorBuilder(double? radius, double? border, Color? borderColor) {
    double? _width = radius == null ? null : radius * 2 / 2.0;
    return (BuildContext context, String url, _) {
      return ClipOval(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: border == null || border == 0.0
                ? null
                : Border.all(color: borderColor ?? Colors.transparent, width: border),
            color: Colors.black12,
          ),
          width: radius! * 2,
          height: radius * 2,
          alignment: Alignment.center,
          child: SizedBox(
            width: _width ?? 60.w,
            height: _width ?? 60.w,
            child: const Icon(Icons.broken_image_rounded, color: Colors.blueAccent),
          ),
        ),
      );
    };
  }

  @override
  PlaceholderWidgetBuilder getCirclePlaceBuilder(double? radius, double? border, Color? borderColor) {
    double? _width = radius == null ? null : radius * 2 / 2.0;
    return (BuildContext context, String url) {
      return ClipOval(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: border == null || border == 0.0
                ? null
                : Border.all(color: borderColor ?? Colors.transparent, width: border),
            color: Colors.black12,
          ),
          width: radius! * 2,
          height: radius * 2,
          alignment: Alignment.center,
          child: const SizedBox(
            //width: _width ?? 60.w,
            //height: _width ?? 60.w,
            child: CupertinoActivityIndicator(color: Colors.white),
          ),
        ),
      );
    };
  }
}
