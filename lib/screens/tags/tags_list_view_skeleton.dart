import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TagsListViewSkeleton extends StatelessWidget {
  const TagsListViewSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Skeleton.ignore(
      child: ListView(
        children: List.generate(
          10,
          (index) => const Skeletonizer(
            child: ListTile(
              title: Bone.text(
                words: 1,
              ),
              trailing: Skeleton.shade(child: Icon(Icons.more_horiz_outlined)),
            ),
          ),
          growable: false,
        ),
      ),
    );
  }
}
