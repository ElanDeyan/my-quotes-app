import 'package:flutter/material.dart';
import 'package:my_quotes/shared/widgets/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuotesListViewSkeleton extends StatelessWidget {
  const QuotesListViewSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      ignoreContainers: true,
      child: CustomScrollView(
        clipBehavior: Clip.none,
        slivers: [
          const SliverToBoxAdapter(
            child: Gap.vertical(spacing: 5),
          ),
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.topCenter,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: List.generate(
                  2,
                  (index) => const Bone.button(),
                  growable: false,
                ),
              ),
            ),
          ),
          SliverList.list(
            children: List.generate(
              10,
              (index) => const ListTile(
                leading: Bone.icon(),
                trailing: Skeleton.shade(child: Icon(Icons.more_vert_outlined)),
                title: Bone.multiText(),
                subtitle: Bone.text(
                  words: 5,
                ),
              ),
              growable: false,
            ),
          ),
        ],
      ),
    );
  }
}
