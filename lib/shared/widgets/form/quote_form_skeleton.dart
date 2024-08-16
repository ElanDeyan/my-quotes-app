import 'package:flutter/material.dart';
import 'package:my_quotes/shared/widgets/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuoteFormSkeleton extends StatelessWidget {
  const QuoteFormSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      ignoreContainers: true,
      child: Column(
        children: [
          const Skeletonizer(child: TextField()),
          const Gap.vertical(spacing: 10),
          const Skeletonizer(child: TextField()),
          const Gap.vertical(spacing: 10),
          const Skeletonizer(child: TextField()),
          const Gap.vertical(spacing: 10),
          const Skeletonizer(child: TextField()),
          const Gap.vertical(spacing: 10),
          const Skeletonizer(
            child: Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: null,
                ),
                Gap.horizontal(spacing: 5),
                Bone.text(
                  words: 2,
                ),
              ],
            ),
          ),
          const Gap.vertical(spacing: 10),
          const Skeletonizer(child: TextField()),
          const Gap.vertical(spacing: 10),
          Skeletonizer(
            child: OutlinedButton.icon(
              label: const Bone.text(
                words: 2,
              ),
              icon: const Skeleton.shade(child: Icon(Icons.add_outlined)),
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }
}
