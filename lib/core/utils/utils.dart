import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getCenterCircularProgress({
  double? padding,
  double? size,
  Color? color,
  double radius = 12,
}) {
  return Container(
    padding: EdgeInsets.all(padding ?? 0.0),
    height: size,
    width: size,
    child: Center(
      child: CupertinoActivityIndicator(
        radius: radius,
      ),
    ),
  );
}

Future<dynamic> openNewPage(BuildContext context, Widget widget,
    {bool popPreviousPages = false}) {
  return Future<dynamic>.delayed(Duration.zero, () {
    if (!popPreviousPages) {
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => widget,
          settings: RouteSettings(arguments: widget),
        ),
      );
    } else {
      return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => widget,
              settings: RouteSettings(
                arguments: widget,
              )),
          (Route<dynamic> route) => false);
    }
  });
}

bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

List divideList(List list, int chunkSize) {
  List chunks = [];
  int length = list.length;
  for (var i = 0; i < length; i += chunkSize) {
    int size = i+chunkSize;
    chunks.add(list.sublist(i, size > length ? length : size));
  }
  return chunks;
}




