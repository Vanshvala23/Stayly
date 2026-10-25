import 'stay.dart';

class Booking {
  final Stay stay;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;

  const Booking({
    required this.stay,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
  });

  int get nights => checkOut.difference(checkIn).inDays;

  double get total => stay.price * nights;
}
