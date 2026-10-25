import 'package:flutter/cupertino.dart';

import '../app_theme.dart';
import '../models/booking.dart';
import '../models/stay.dart';
import 'booking_screen.dart';

class StayDetailScreen extends StatelessWidget {
  final Stay stay;
  final bool isFavorite;
  final ValueChanged<bool> onFavoriteChanged;
  final ValueChanged<Booking> onBookingConfirmed;

  const StayDetailScreen({
    super.key,
    required this.stay,
    required this.isFavorite,
    required this.onFavoriteChanged,
    required this.onBookingConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: pageBackground,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Stay details'),
            previousPageTitle: 'Explore',
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => onFavoriteChanged(!isFavorite),
              child: Icon(
                isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                color: isFavorite ? coral : ink,
                size: 24,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.1,
                  child: Image.network(
                    stay.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;

                      return Container(
                        color: const Color(0xFFF1EFED),
                        alignment: Alignment.center,
                        child: const CupertinoActivityIndicator(),
                      );
                    },
                    errorBuilder: (_, _, _) {
                      return Container(
                        color: const Color(0xFFF1EFED),
                        alignment: Alignment.center,
                        child: const Icon(
                          CupertinoIcons.photo,
                          size: 48,
                          color: muted,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stay.name,
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stay.location,
                        style: const TextStyle(fontSize: 16, color: muted),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.star_fill,
                            size: 17,
                            color: ink,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${stay.rating} · Guest favorite',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: ink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: CupertinoColors.separator,
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'About this stay',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Explore this ${stay.category.toLowerCase()} stay '
                        'in ${stay.location}. Save it to your wishlist '
                        'so you can find it again later.',
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: muted,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(color: ink),
                                children: [
                                  TextSpan(
                                    text: '\$${stay.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: ' / night',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CupertinoButton.filled(
                            onPressed: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute<void>(
                                  builder: (_) => BookingScreen(
                                    stay: stay,
                                    onBookingConfirmed: onBookingConfirmed,
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(13),
                            child: const Text('Reserve'),
                          ),
                        ],
                      ),
                    ],
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
