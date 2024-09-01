import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuotesSearchResultSkeleton extends StatelessWidget {
  const QuotesSearchResultSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView(
        children: List.generate(
          5,
          (index) => const ListTile(
            leading: Skeleton.shade(
              child: Icon(Icons.format_quote_outlined),
            ),
            title: Bone.text(
              words: 10,
            ),
            subtitle: Bone.text(
              words: 2,
            ),
          ),
        ),
      ),
    );
  }
}
