

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WaitingForQuotesSkeleton extends StatelessWidget {
  const WaitingForQuotesSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      ignoreContainers: true,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: List.generate(
          10,
          (index) => const ListTile(
            leading: Bone.icon(),
            trailing: Bone.icon(),
            title: Bone.multiText(),
            subtitle: Bone.text(
              words: 5,
            ),
          ),
          growable: false,
        ),
      ),
    );
  }
}
