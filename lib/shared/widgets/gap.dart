import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap({required this.spacing, super.key, this.axis = Axis.vertical});

  const factory Gap.vertical({
    required double spacing,
  }) = VerticalGap;

  const factory Gap.horizontal({
    required double spacing,
  }) = HorizontalGap;

  final Axis axis;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return switch (axis) {
      Axis.horizontal => SizedBox(
          width: spacing,
        ),
      Axis.vertical => SizedBox(
          height: spacing,
        ),
    };
  }
}

class VerticalGap extends Gap {
  const VerticalGap({required super.spacing, super.key})
      : super(axis: Axis.vertical);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: spacing,
    );
  }
}

class HorizontalGap extends Gap {
  const HorizontalGap({required super.spacing, super.key})
      : super(axis: Axis.horizontal);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: spacing,
    );
  }
}
