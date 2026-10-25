
import 'package:flutter/cupertino.dart';

import '../app_theme.dart';
import '../models/stay.dart';

class StayCard extends StatelessWidget {
  final Stay stay;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoritePressed;

  const StayCard({
    super.key,
    required this.stay,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 27),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and tap area
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: AspectRatio(
                aspectRatio: 1.12,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      stay.image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;

                        return Container(
                          color: const Color(0xFFF1EFED),
                          alignment: Alignment.center,
                          child: const CupertinoActivityIndicator(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF1EFED),
                          alignment: Alignment.center,
                          child: const Icon(
                            CupertinoIcons.photo,
                            size: 42,
                            color: muted,
                          ),
                        );
                      },
                    ),

                    // Guest favorite label
                    Positioned(
                      top: 13,
                      left: 13,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white.withValues(
                            alpha: 0.96,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Guest favorite',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    // Independent favorite button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(44, 44),
                        onPressed: onFavoritePressed,
                        child: Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            color: CupertinoColors.black.withValues(
                              alpha: 0.28,
                            ),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            isFavorite
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            color: isFavorite
                                ? coral
                                : CupertinoColors.white,
                            size: 21,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Location and rating
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        stay.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: ink,
                        ),
                      ),
                    ),
                    const Icon(
                      CupertinoIcons.star_fill,
                      size: 14,
                      color: ink,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      stay.rating.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        color: ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Property name
                Text(
                  stay.name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: muted,
                  ),
                ),
                const SizedBox(height: 5),

                // Price
                Text(
                  '\$${stay.price.toStringAsFixed(0)} per night',
                  style: const TextStyle(
                    color: ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
