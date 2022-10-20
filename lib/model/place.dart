import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Place {
  String id;
  String title;
  String snippet;
  LocationData geopoint;

  Place({required  this.geopoint, required this.id, required this.title, required this.snippet});

  Marker getMarker(){

    return Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId(this.id),
        draggable: false,
        infoWindow: InfoWindow(title: this.title, snippet: this.snippet),
        position: LatLng(this.geopoint.latitude?? 0.0, this.geopoint.longitude?? 0.0)
    );
  }
}