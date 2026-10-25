import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stayly/app.dart';
import 'package:stayly/data/stays_data.dart';
import 'package:stayly/models/booking.dart';
import 'package:stayly/screens/booking_screen.dart';

void main() {
  testWidgets('explore screen shows stays', (tester) async {
    await tester.pumpWidget(const StaylyApp());

    expect(find.text('Places to stay'), findsOneWidget);
    expect(find.text('The Glasshouse'), findsOneWidget);
  });

  testWidgets('a confirmed reservation appears in Trips', (tester) async {
    await tester.pumpWidget(const StaylyApp());

    final stayName = find.text('The Glasshouse');
    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, -600),
    );
    await tester.pumpAndSettle();
    await tester.tap(stayName);
    await tester.pumpAndSettle();

    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, -1000),
    );
    await tester.pumpAndSettle();
    final reserveButton = find.text('Reserve');
    await tester.tap(reserveButton);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Confirm booking'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Trips'));
    await tester.pumpAndSettle();

    expect(find.text('Your getaways'), findsOneWidget);
    expect(find.text('The Glasshouse'), findsOneWidget);
    expect(find.text('Booked · demo'), findsOneWidget);
  });

  testWidgets('empty Trips page can take guests back to Explore', (
    tester,
  ) async {
    await tester.pumpWidget(const StaylyApp());

    await tester.tap(find.text('Trips'));
    await tester.pumpAndSettle();

    expect(find.text('No trips booked… yet'), findsOneWidget);
    await tester.tap(find.text('Explore stays'));
    await tester.pumpAndSettle();

    expect(find.text('Places to stay'), findsOneWidget);
  });

  testWidgets('booking confirmation calculates and returns the reservation', (
    tester,
  ) async {
    Booking? confirmedBooking;
    await tester.pumpWidget(
      CupertinoApp(
        home: BookingScreen(
          stay: stays.first,
          onBookingConfirmed: (booking) => confirmedBooking = booking,
        ),
      ),
    );

    await tester.tap(find.text('Confirm booking'));
    await tester.pump();

    expect(confirmedBooking, isNotNull);
    expect(confirmedBooking!.nights, 2);
    expect(confirmedBooking!.guests, 2);
    expect(confirmedBooking!.total, stays.first.price * 2);
    expect(find.text('You’re all set'), findsOneWidget);
  });
}
