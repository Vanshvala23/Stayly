import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_theme.dart';
import '../models/booking.dart';
import '../models/stay.dart';

class BookingScreen extends StatefulWidget {
  final Stay stay;
  final ValueChanged<Booking> onBookingConfirmed;

  const BookingScreen({
    super.key,
    required this.stay,
    required this.onBookingConfirmed,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late DateTime _checkIn;
  late DateTime _checkOut;
  int _guests = 2;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    _checkIn = todayDate.add(const Duration(days: 7));
    _checkOut = _checkIn.add(const Duration(days: 2));
  }

  int get _nights => _checkOut.difference(_checkIn).inDays;

  Future<void> _selectDate({required bool isCheckIn}) async {
    final minimumDate = isCheckIn
        ? DateUtils.dateOnly(DateTime.now())
        : _checkIn.add(const Duration(days: 1));
    final initialDate = isCheckIn ? _checkIn : _checkOut;
    var selectedDate = initialDate.isBefore(minimumDate)
        ? minimumDate
        : initialDate;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: 320,
        color: CupertinoColors.systemBackground,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Done'),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  minimumDate: minimumDate,
                  onDateTimeChanged: (date) {
                    selectedDate = DateUtils.dateOnly(date);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (!mounted) return;
    setState(() {
      if (isCheckIn) {
        _checkIn = selectedDate;
        if (!_checkOut.isAfter(_checkIn)) {
          _checkOut = _checkIn.add(const Duration(days: 1));
        }
      } else {
        _checkOut = selectedDate;
      }
    });
  }

  Future<void> _confirmBooking() async {
    final booking = Booking(
      stay: widget.stay,
      checkIn: _checkIn,
      checkOut: _checkOut,
      guests: _guests,
    );
    widget.onBookingConfirmed(booking);

    await showCupertinoDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('You’re all set'),
        content: const Text(
          'Your demo booking is ready. It will stay in Trips for this '
          'app session. No payment has been taken.',
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, d MMM');

    return CupertinoPageScaffold(
      backgroundColor: pageBackground,
      navigationBar: const CupertinoNavigationBar(middle: Text('Your booking')),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                children: [
                  _buildStaySummary(),
                  const SizedBox(height: 24),
                  const Text(
                    'Your trip',
                    style: TextStyle(
                      color: ink,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDateRow(
                    title: 'Check in',
                    date: dateFormat.format(_checkIn),
                    onTap: () => _selectDate(isCheckIn: true),
                  ),
                  const SizedBox(height: 10),
                  _buildDateRow(
                    title: 'Check out',
                    date: dateFormat.format(_checkOut),
                    onTap: () => _selectDate(isCheckIn: false),
                  ),
                  const SizedBox(height: 10),
                  _buildGuestSelector(),
                  const SizedBox(height: 24),
                  const Text(
                    'Price details',
                    style: TextStyle(
                      color: ink,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPriceRow(
                    '\$${widget.stay.price.toStringAsFixed(0)} × $_nights nights',
                    '\$${(widget.stay.price * _nights).toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 12),
                  Container(height: 1, color: CupertinoColors.separator),
                  const SizedBox(height: 12),
                  _buildPriceRow(
                    'Total',
                    '\$${(widget.stay.price * _nights).toStringAsFixed(0)}',
                    isTotal: true,
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4F2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Demo booking · No payment required · Saved for this '
                      'session only',
                      style: TextStyle(color: ink, fontSize: 13, height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: _confirmBooking,
                  borderRadius: BorderRadius.circular(14),
                  child: const Text('Confirm booking'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaySummary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.stay.image,
              width: 92,
              height: 92,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 92,
                height: 92,
                color: const Color(0xFFF1EFED),
                alignment: Alignment.center,
                child: const Icon(CupertinoIcons.photo, color: muted),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.stay.category,
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.stay.name,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.stay.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: muted, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow({
    required String title,
    required String date,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      color: CupertinoColors.secondarySystemBackground,
      borderRadius: BorderRadius.circular(14),
      onPressed: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: muted, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(CupertinoIcons.calendar, color: ink, size: 20),
        ],
      ),
    );
  }

  Widget _buildGuestSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Guests', style: TextStyle(color: muted, fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  'Who’s coming?',
                  style: TextStyle(
                    color: ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          CupertinoButton(
            onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
            padding: EdgeInsets.zero,
            minimumSize: const Size(36, 36),
            child: const Icon(CupertinoIcons.minus_circle, color: coral),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$_guests',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ink,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CupertinoButton(
            onPressed: _guests < 16 ? () => setState(() => _guests++) : null,
            padding: EdgeInsets.zero,
            minimumSize: const Size(36, 36),
            child: const Icon(CupertinoIcons.add_circled, color: coral),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    final style = TextStyle(
      color: ink,
      fontSize: isTotal ? 16 : 14,
      fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
    );

    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(amount, style: style),
      ],
    );
  }
}
