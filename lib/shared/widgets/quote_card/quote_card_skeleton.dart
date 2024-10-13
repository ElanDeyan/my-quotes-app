import 'package:flutter/material.dart';
import 'package:my_quotes/shared/widgets/quote_card/quote_icon_decoration.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuoteCardSkeleton extends StatelessWidget {
  const QuoteCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 250),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Skeletonizer(
              child: Card.outlined(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(10),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 26,
                    right: 26,
                    top: 22,
                    bottom: 11,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Bone.multiText(
                            lines: 5,
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge!.fontSize,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Bone.text(
                        words: 5,
                        fontSize:
                            Theme.of(context).textTheme.bodySmall!.fontSize,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Bone.text(
                        words: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              bottom: 10,
              right: 10,
              child: Skeleton.shade(
                child: Icon(
                  Icons.favorite,
                  size: 16,
                ),
              ),
            ),
            const Positioned(
              right: 7.5,
              top: 2.5,
              child: Skeleton.shade(child: Icon(Icons.more_horiz)),
            ),
            const Positioned(
              top: -15,
              left: -10,
              child: Skeleton.shade(
                child: QuoteIconDecoration(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
