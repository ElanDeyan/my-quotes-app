import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap({super.key, required this.spacing, this.axis = Axis.vertical});

  final Axis axis;
  final double spacing;

  const factory Gap.vertical({
    required double spacing,
  }) = VerticalGap;

  const factory Gap.horizontal({
    required double spacing,
  }) = HorizontalGap;

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
  const VerticalGap({super.key, required super.spacing})
      : super(axis: Axis.vertical);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: spacing,
    );
  }
}

class HorizontalGap extends Gap {
  const HorizontalGap({super.key, required super.spacing})
      : super(axis: Axis.horizontal);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: spacing,
    );
  }
}
