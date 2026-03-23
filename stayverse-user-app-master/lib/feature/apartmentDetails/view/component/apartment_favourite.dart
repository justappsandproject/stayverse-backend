import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/data/enum/enums.dart';

class FavouriteBtn extends ConsumerWidget {
  final bool isFavourite;
  final ValueChanged<ActionFavourite>? onTap;

  const FavouriteBtn({
    super.key,
    required this.isFavourite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!(isFavourite ? ActionFavourite.remove : ActionFavourite.add);
          }
        },
        customBorder: const CircleBorder(),
        splashColor: Colors.red.withOpacity(0.3),
        child: Ink(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: Icon(
              isFavourite ? Icons.favorite : Icons.favorite_border,
              key: ValueKey<bool>(isFavourite),
              color: isFavourite ? Colors.red : Colors.grey,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
