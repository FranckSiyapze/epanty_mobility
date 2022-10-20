import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as Geocoding;

class PositionMetadata {

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //Location.instance.requestService();
      bool goEnable = await Geolocator.openLocationSettings();
      if (!goEnable)
        return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }


  Future<LocationData> getPosition() async {
    Location location = Location.instance;

    bool locationEnabled = await location.serviceEnabled();
    if (!locationEnabled) {
      location.requestService();
    }

    PermissionStatus locationPermission = await location.hasPermission();
    if (PermissionStatus.denied == locationPermission ||
        PermissionStatus.deniedForever == locationPermission) {
      location.requestPermission();
    }
    LocationData position;
    try {
      //await location.changeSettings(accuracy: LocationAccuracy.high);
      position = await location.getLocation();
      return position;
    }
    catch (e){
      print("Error : \n ${e.toString()}");
      return Future.error("Error : \n ${e.toString()}");
    }

    /*
    List<Geocoding.Placemark> placemarks;

    try {
      await Geocoding.placemarkFromCoordinates(
          position.latitude!, position.longitude!);
    } catch (e) {
      await Future.delayed(Duration(milliseconds: 300));
    }

    try {
      placemarks = await Geocoding.placemarkFromCoordinates(
          position.latitude!, position.longitude!);
      return {
        'longitude': position.longitude,
        'latitude': position.latitude,
        'name': placemarks[0].name,
        'street': placemarks[0].street,
        'locality': placemarks[0].locality,
        'subLocality': placemarks[0].subLocality,
        'thoroughfare': placemarks[0].thoroughfare,
        'subThoroughfare': placemarks[0].subThoroughfare,
        'administrativeArea': placemarks[0].administrativeArea,
        'subAdministrativeArea': placemarks[0].subAdministrativeArea,
        'postalCode': placemarks[0].postalCode,
        'country': placemarks[0].country,
        'isoCountryCode': placemarks[0].isoCountryCode,
      };
    } catch (e) {
      print('error');
    }
    return {};
    */
  }
}