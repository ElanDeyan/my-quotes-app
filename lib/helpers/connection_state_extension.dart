import 'package:flutter/material.dart';

extension ConnectionStateExtension on ConnectionState {
  bool get isDone => this == ConnectionState.done;
}
