import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Trip {
  final LatLng startPosition;
  final LatLng stopPosition;
  final DateTime startTime;
  final DateTime stopTime;
  final List<PolylineWayPoint> route;

  Trip({
    required this.startPosition,
    required this.stopPosition,
    required this.route,
    required this.startTime,
    required this.stopTime,
  });

  Future<double> distance() async {
    /// Find total distance traveled
    return 1.0;
  }

  DateTime duration() {
    /// Calculate the total duration of the trip
    return DateTime.now();
  }

  Future<bool> safeToFirebase() async {
    /// Save trip to firebase
    return true;
  }
}
