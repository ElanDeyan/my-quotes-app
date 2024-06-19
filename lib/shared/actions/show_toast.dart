import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(BuildContext context, {required Widget child}) {
  FToast().init(context).showToast(child: child);
}
