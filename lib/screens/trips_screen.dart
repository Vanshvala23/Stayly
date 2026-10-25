import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_theme.dart';
import '../models/booking.dart';

class TripsScreen extends StatefulWidget {
  final List<Booking> bookings;
  final VoidCallback onExplore;

  const TripsScreen({
    super.key,
    required this.bookings,
    required this.onExplore,
  });

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_updateTabSelection);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_updateTabSelection)
      ..dispose();
    super.dispose();
  }

  void _updateTabSelection() {
    if (!_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final upcoming =
        widget.bookings
            .where((booking) => !booking.checkOut.isBefore(today))
            .toList()
          ..sort((a, b) => a.checkIn.compareTo(b.checkIn));
    final past =
        widget.bookings
            .where((booking) => booking.checkOut.isBefore(today))
            .toList()
          ..sort((a, b) => b.checkIn.compareTo(a.checkIn));

    return CupertinoPageScaffold(
      backgroundColor: pageBackground,
      navigationBar: const CupertinoNavigationBar(middle: Text('Trips')),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your getaways',
                    style: TextStyle(
                      color: ink,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.bookings.isEmpty
                        ? 'Every great trip starts somewhere.'
                        : '${widget.bookings.length} ${widget.bookings.length == 1 ? 'stay' : 'stays'} booked',
                    style: const TextStyle(color: muted, fontSize: 14),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: CupertinoColors.tertiarySystemBackground,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: CupertinoSlidingSegmentedControl<int>(
                      groupValue: _tabController.index,
                      children: const {
                        0: Padding(
                          padding: EdgeInsets.symmetric(vertical: 9),
                          child: Text('Upcoming'),
                        ),
                        1: Padding(
                          padding: EdgeInsets.symmetric(vertical: 9),
                          child: Text('Past'),
                        ),
                      },
                      onValueChanged: (index) {
                        if (index != null) {
                          _tabController.animateTo(index);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _TripList(
                    bookings: upcoming,
                    isPast: false,
                    onExplore: widget.onExplore,
                  ),
                  _TripList(
                    bookings: past,
                    isPast: true,
                    onExplore: widget.onExplore,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripList extends StatelessWidget {
  final List<Booking> bookings;
  final bool isPast;
  final VoidCallback onExplore;

  const _TripList({
    required this.bookings,
    required this.isPast,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return _EmptyTrips(isPast: isPast, onExplore: onExplore);
    }

    final dateFormat = DateFormat('d MMM');

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        for (final booking in bookings)
          _TripCard(booking: booking, dateFormat: dateFormat, isPast: isPast),
      ],
    );
  }
}

class _EmptyTrips extends StatelessWidget {
  final bool isPast;
  final VoidCallback onExplore;

  const _EmptyTrips({required this.isPast, required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEEE),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                isPast ? CupertinoIcons.airplane : CupertinoIcons.bag_fill,
                color: coral,
                size: 34,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isPast ? 'No past trips yet' : 'No trips booked… yet',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ink,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isPast ? 'Your travel memories will show up here.' : 'Find a place you love and your next adventure will show up here.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: muted, fontSize: 14, height: 1.5),
            ),
            if (!isPast) ...[
              const SizedBox(height: 20),
              CupertinoButton.filled(
                onPressed: onExplore,
                borderRadius: BorderRadius.circular(13),
                child: const Text('Explore stays'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Booking booking;
  final DateFormat dateFormat;
  final bool isPast;

  const _TripCard({
    required this.booking,
    required this.dateFormat,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            booking.stay.image,
            height: 184,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: 184,
              color: const Color(0xFFF1EFED),
              alignment: Alignment.center,
              child: const Icon(CupertinoIcons.photo, color: muted, size: 36),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(CupertinoIcons.calendar, size: 15, color: coral),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${dateFormat.format(booking.checkIn)} – '
                        '${dateFormat.format(booking.checkOut)}',
                        style: const TextStyle(
                          color: coral,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _TripBadge(isPast: isPast),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        booking.stay.name,
                        style: const TextStyle(
                          color: ink,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  booking.stay.location,
                  style: const TextStyle(color: muted, fontSize: 13),
                ),
                const SizedBox(height: 15),
                Container(height: 1, color: CupertinoColors.separator),
                const SizedBox(height: 13),
                Row(
                  children: [
                    _TripDetail(
                      icon: CupertinoIcons.moon,
                      label:
                          '${booking.nights} ${booking.nights == 1 ? 'night' : 'nights'}',
                    ),
                    const SizedBox(width: 18),
                    _TripDetail(
                      icon: CupertinoIcons.person_2,
                      label:
                          '${booking.guests} ${booking.guests == 1 ? 'guest' : 'guests'}',
                    ),
                    const Spacer(),
                    Text(
                      '\$${booking.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripBadge extends StatelessWidget {
  final bool isPast;

  const _TripBadge({required this.isPast});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPast ? 'Completed · demo' : 'Booked · demo',
        style: const TextStyle(
          color: coral,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TripDetail extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TripDetail({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: muted),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: muted, fontSize: 12)),
      ],
    );
  }
}
