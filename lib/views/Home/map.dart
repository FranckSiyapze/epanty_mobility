import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epanty_mobility/Components/Components.dart';
import 'package:epanty_mobility/localisation.dart';
import 'package:epanty_mobility/model/mail.dart';
import 'package:epanty_mobility/model/position.dart';
import 'package:epanty_mobility/views/Settings/payment.dart';
import 'package:epanty_mobility/views/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapTab extends StatefulWidget {
  const MapTab({Key? key, required this.blockTabs}) : super(key: key);

  final VoidCallback blockTabs;

  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  late Position userPosition;
  final ValueNotifier<int> positionGotten = ValueNotifier<int>(0);

  ///******************************************
  late GoogleMapController mapController;
  bool trip = false;
  LatLng origin = LatLng(4.22536, 7.15489);
  LatLng destination = LatLng(4.42536, 7.35489);
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  MapType mapType = MapType.normal;

  List<PolylineWayPoint> track = [];

  LatLng startPosition = LatLng(0.0, 0.0);
  LatLng stopPosition = LatLng(0.0, 0.0);

  late DateTime startTime;
  late DateTime stopTime;

  int remainingTrips = 0;

  late StreamSubscription positionStream;
  late StreamSubscription bearingDirectionStream;
  late StreamSubscription mapCreateSubscription;

  late Timer pointMarker;

  String googleAPiKey = "AIzaSyA5RGi0HqYcwBA3xelEIM87p6oZ43zZStU";
  TextEditingController searchController = TextEditingController();

  LatLng _lastMapPosition = LatLng(0, 0);
  double _lastMapZoom = 16;

  void initStateFunction() async {
    PositionMetadata position = new PositionMetadata();
    userPosition = await position.determinePosition();

    origin = LatLng(userPosition.latitude, userPosition.longitude);
    positionGotten.value = 1;

    var toGet = await FirebaseFirestore.instance
        .collection("Payment")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (toGet.data() != null) {
      remainingTrips = toGet.data()!["trips"] as int;
      print("TRIPPPPPPSSSS ::: " + remainingTrips.toString());
    } else {
      print("RESTE DE NOMBRE " + remainingTrips.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    initStateFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Color.fromRGBO(90, 144, 53, 1),
        title: Text(AppLocalizations.of(context).map),
        actions: <Widget>[],
      ),
      drawer: Drawer(
        child: ProfileTab(),
      ),
      body: Container(
        child: ValueListenableBuilder<int>(
            valueListenable: positionGotten,
            child: null,
            builder: (BuildContext context, int status, Widget? child) {
              if (status == 0) {
                /// Getting position
                return Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinearProgressIndicator(),
                        SizedBox(
                          height: 30,
                        ),
                        Text("Nous récuperons votre Position"),
                      ],
                    ),
                  ),
                );
              } else if (status == 1) {
                /// Position gotten
                return Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        child: GoogleMap(
                          myLocationButtonEnabled: false,
                          compassEnabled: true,
                          myLocationEnabled: true,
                          mapType: mapType,
                          zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                userPosition.latitude, userPosition.longitude),
                            zoom: 16,
                            tilt: 0.0,
                          ),
                          onMapCreated: _onMapCreated,
                          onCameraMove: (position) async {
                            _lastMapPosition = position.target;
                            _lastMapZoom = await mapController.getZoomLevel();
                          },
                          markers: Set<Marker>.of(markers.values),
                          polylines: Set<Polyline>.of(polylines.values),
                          onLongPress: (position) {
                            if (!trip) {
                              setState(() {
                                destination = LatLng(
                                    position.latitude, position.longitude);
                                _addMarker(
                                  LatLng(position.latitude, position.longitude),
                                  "2",
                                  BitmapDescriptor.defaultMarker,
                                );
                              });
                            }
                          },
                        ),
                      ),

                      /// Text Field for searches
                      Positioned(
                        top: 60,
                        right: 10,
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.white.withOpacity(0.5),
                          onPressed: () async {
                            setState(() {
                              mapType = (mapType == MapType.normal)
                                  ? MapType.hybrid
                                  : MapType.normal;
                            });
                          },
                          child: Icon(Icons.map_outlined, color: Colors.black),
                        ),
                      ),
                      /*Positioned(
                        top: 110,
                        right: 10,
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.white.withOpacity(0.5),
                          onPressed: () async {
                            polylines = {};

                            _getPolyline(LatLng(userPosition.latitude,userPosition.longitude),destination);
                            setState(() {});
                          },
                          child: Icon(Icons.directions, color: Colors.black),
                        ),
                      ),*/
                      Positioned(
                        top: 110,
                        right: 10,
                        child: FloatingActionButton(
                          onPressed: () {},
                          mini: true,
                          backgroundColor: Colors.white.withOpacity(0.5),
                          child: CupertinoButton(
                            color: Colors.transparent,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              if (_lastMapPosition != null)
                                mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            bearing: 0.0,
                                            tilt: 0.0,
                                            target: _lastMapPosition,
                                            zoom: _lastMapZoom)));
                            },
                            child: _lastMapPosition == LatLng(0, 0)
                                ? const Icon(
                                    CupertinoIcons.compass,
                                    size: 30,
                                    color: Colors.black,
                                  )
                                : Container(),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: FloatingActionButton(
                          child: Icon(!trip ? Icons.directions : Icons.cancel,
                              color: Colors.green, size: 30.0),
                          backgroundColor: Colors.white60,
                          onPressed: () async {
                            if (remainingTrips > 0) {
                              if (!trip) {
                                ///Remove existing polylines
                                setState(() {
                                  polylines = {};
                                });
                                markers = {};

                                /// Start trip logic
                                await newTrip(context);
                              } else {
                                ///Stop trip login

                                widget.blockTabs();

                                //FlutterBackgroundService().invoke("setAsBackground");

                                //collect track
                                try {
                                  /// Decrement Trips number
                                  ///
                                  var value = await FirebaseFirestore.instance
                                      .collection("Payment")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .get();
                                  int tripValue = value.data()!["trips"];
                                  FirebaseFirestore.instance
                                      .collection("Payment")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .set({"trips": tripValue - 1});

                                  pointMarker.cancel();

                                  //set map to default view

                                  //Stop map update Streams
                                  await positionStream.cancel();
                                  await bearingDirectionStream.cancel();

                                  //collect end position
                                  stopPosition = LatLng(userPosition.latitude,
                                      userPosition.longitude);

                                  //collect end time
                                  stopTime = DateTime.now();

                                  //get route
                                  String pointsList = routeToFirebase(markers);

                                  markers = {};

                                  //Re-position camera
                                  Timer(Duration(seconds: 2), () {
                                    mapController.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          target: LatLng(userPosition.latitude,
                                              userPosition.longitude),
                                          tilt: 0.0,
                                          zoom: 15,
                                        ),
                                      ),
                                    );
                                  });

                                  //save all of them to firebase
                                  await FirebaseFirestore.instance
                                      .collection("tripData")
                                      .add({
                                    "startPosition": {
                                      "lat": startPosition.latitude,
                                      "lng": startPosition.longitude
                                    },
                                    "stopPosition": {
                                      "lat": stopPosition.latitude,
                                      "lng": stopPosition.longitude
                                    },
                                    "startTime": startTime,
                                    "stopTime": stopTime,
                                    "points": pointsList,
                                    "userId":
                                        FirebaseAuth.instance.currentUser!.uid,
                                    "_isDeleted": false,
                                  }).onError((error, stackTrace) {
                                    showSnackBar(context, error.toString());
                                    return Future.error("error");
                                  });

                                  //set trip variable to false
                                  setState(() {
                                    trip = false;
                                  });

                                  //Show popup notiifcation about successful upload to firebase
                                } catch (e) {
                                  showSnackBar(context, e.toString());
                                }
                              }
                            } else {
                              await paymentNeeded(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else if (status == 2) {
                /// Location services or permission denied
                return Container();
              }
              return Container();
            }),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    mapCreateSubscription = Geolocator.getPositionStream().listen((event) {
      userPosition = event;
      mapController.moveCamera(CameraUpdate.newLatLng(
          LatLng(userPosition.latitude, userPosition.longitude)));
    });
    Timer(Duration(seconds: 3), () {
      mapCreateSubscription.cancel();
    });
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Color.fromRGBO(90, 144, 53, 1),
        points: polylineCoordinates);
    polylines = {};
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(LatLng origin, LatLng destination) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
      wayPoints: [],
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  _getPolylineWithWayPoints(List<PolylineWayPoint> route) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
      wayPoints: route,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  String routeToFirebase(Map<MarkerId, Marker> markers) {
    List<LatLng> pts = [];
    markers.forEach((key, value) {
      pts.add(value.position);
    });

    List<PolylineWayPoint> list = [];

    pts.forEach((element) {
      list.add(PolylineWayPoint(
          location: '${element.latitude}%2C${element.longitude}',
          stopOver: false));
    });

    String encodedPolylines = "";

    list.forEach((element) {
      encodedPolylines += "_Point_${element.location}";
    });
    return encodedPolylines;
  }

  Future<List<PolylineWayPoint>> routeFormFirebase(
      String encodedPolylines) async {
    List<PolylineWayPoint> list = [];

    List<String> stringPoints = encodedPolylines.split("_Point_");
    stringPoints.forEach((element) {
      list.add(PolylineWayPoint(location: '${element}', stopOver: false));
    });
    return list;
  }

  Future<void> newTrip(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String previousEmail = prefs.getString("previousEmail") ?? "";
    String previousPhone = prefs.getString("previousPhone") ?? "";
    String previousRegion = prefs.getString("previousRegion") ?? "";

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        GlobalKey<FormState> formKey = GlobalKey<FormState>();
        final emailController = TextEditingController(text: previousEmail);
        final phoneController = TextEditingController(text: previousPhone);
        final regionController = TextEditingController(text: previousRegion);
        final carController = TextEditingController();
        String region = "Cameroun";

        TaskSnapshot? upload;
        bool file = false;

        String dateTime = DateTime.now().toString();

        return AlertDialog(
          title: Text(AppLocalizations.of(context).infostrajet),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                      controller: emailController,
                      decoration: InputDecoration.collapsed(
                          hintText: AppLocalizations.of(context).email),
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: AppLocalizations.of(context).requis),
                        EmailValidator(
                            errorText:
                                AppLocalizations.of(context).email_invalid),
                      ])),
                  Divider(),
                  SizedBox(height: 20),
                  TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration.collapsed(
                          hintText: AppLocalizations.of(context).phone),
                      validator: (value) {
                        if (value == "")
                          return AppLocalizations.of(context).requis;
                        else if (!RegExp(r'^[+0-9]+$').hasMatch(value!)) {
                          return AppLocalizations.of(context).invalide;
                        } else
                          return null;
                      }),
                  Divider(),
                  SizedBox(height: 20),
                  /*DropDownWidget(
                    initialValue: 'Cameroun',
                    values: [
                      "Cameroun",
                      "Senegal",
                      "Gabon",
                      "Congo",
                      "Nigéria"
                    ],
                    callbackFunction: (value) {
                      region = value;
                    },
                  ),*/
                  TextFormField(
                    controller: regionController,
                    decoration: InputDecoration.collapsed(
                        hintText: AppLocalizations.of(context).state),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).requis;
                      } else {
                        return null;
                      }
                    },
                  ),
                  Divider(),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: carController,
                    decoration: InputDecoration.collapsed(
                        hintText: AppLocalizations.of(context).immatriculation),
                    validator: (value) {
                      if (file) {
                        return null;
                      } else {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).requis;
                        } else {
                          return null;
                        }
                      }
                    },
                  ),
                  Divider(),
                  SizedBox(height: 20),
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      if (!file) {
                        final ImagePicker _picker = ImagePicker();
                        // Capture a photo
                        final XFile? rawPhoto =
                            await _picker.pickImage(source: ImageSource.camera);

                        Directory path =
                            await getApplicationDocumentsDirectory();
                        Directory path2 =
                            await getApplicationSupportDirectory();
                        String finalPath =
                            "${path.path}/photo${DateTime.now().toString()}.jpg";
                        String finalPath2 =
                            "${path2.path}/photo${DateTime.now().toString()}.jpg";

                        rawPhoto!.saveTo(finalPath);
                        rawPhoto.saveTo(finalPath2);

                        File photo = File(finalPath);
                        File photo2 = File(finalPath2);

                        bool exists = await photo.exists();
                        bool exists2 = await photo2.exists();
                        if (exists) {
                          try {
                            setState(() {
                              file = true;
                            });
                            upload = await FirebaseStorage.instance
                                .ref(
                                    "${FirebaseAuth.instance.currentUser!.uid}/trip/$dateTime.jgp")
                                .putFile(File(photo.path));
                          } catch (e) {
                            print(e.toString());
                          }
                        } else if (exists2) {
                          try {
                            setState(() {
                              file = true;
                            });
                            upload = await FirebaseStorage.instance
                                .ref(
                                    "${FirebaseAuth.instance.currentUser!.uid}/trip/$dateTime.jgp")
                                .putFile(File(photo2.path));
                          } catch (e) {
                            print(e.toString());
                          }
                        } else {
                          setState(() {
                            file = true;
                          });
                          upload = await FirebaseStorage.instance
                              .ref(
                                  "${FirebaseAuth.instance.currentUser!.uid}/trip/$dateTime.jgp")
                              .putFile(File(rawPhoto.path));
                        }
                      } else {
                        ///Do nothing
                      }
                    },
                    child: Icon(
                      !file ? Icons.camera_alt_outlined : Icons.task_alt,
                      color: Color.fromRGBO(90, 144, 53, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).start),
              onPressed: () async {
                await prefs.setString("previousEmail", emailController.text);
                await prefs.setString("previousPhone", phoneController.text);

                widget.blockTabs();

                if (!formKey.currentState!.validate()) {
                  print("Validation Failed");
                } else {
                  ///Save trip info to firebase
                  FirebaseFirestore.instance
                      .collection("trips")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .set({
                    "date": dateTime,
                    "email": emailController.text,
                    "phone": phoneController.text,
                    "matriculation": carController.text,
                    "region": region,
                    "picture":
                        '' //(file != null ? (file ? upload!.ref : "") : ""),
                  });

                  /// Send mail notification
                  send(emailController.text,
                      FirebaseAuth.instance.currentUser!.displayName!, context);

                  /// Start trip logic here
                  ///

                  Navigator.of(context).pop();

                  //We need firebase document here
                  setState(() {
                    trip = true;
                  });

                  var _startPosition = await Geolocator.getCurrentPosition();
                  startPosition =
                      LatLng(_startPosition.latitude, _startPosition.longitude);
                  startTime = DateTime.now();

                  positionStream = GeolocatorPlatform.instance
                      .getPositionStream()
                      .listen((event) async {
                    Stream? directionStream = FlutterCompass.events;
                    if (directionStream != null) {
                      bearingDirectionStream =
                          directionStream.listen((bearingEvent) async {
                        if (bearingEvent.heading != null) {
                          if (trip) {
                            await mapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target:
                                      LatLng(event.latitude, event.longitude),
                                  tilt: 60,
                                  zoom: 16,
                                  bearing: bearingEvent!.heading as double,
                                ),
                              ),
                            );
                            setState(() {
                              userPosition = event;
                            });
                          }
                        } else {
                          if (trip) {
                            await mapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target:
                                      LatLng(event.latitude, event.longitude),
                                  tilt: 0,
                                  zoom: 16,
                                  //bearing:
                                ),
                              ),
                            );
                            setState(() {
                              userPosition = event;
                            });
                          }
                        }
                      });
                    } else {
                      if (trip) {
                        await mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(event.latitude, event.longitude),
                              tilt: 0,
                              zoom: 16,
                              //bearing:
                            ),
                          ),
                        );
                        setState(() {
                          userPosition = event;
                        });
                      }
                    }
                  });

                  pointMarker =
                      Timer.periodic(Duration(seconds: 5), (time) async {
                    /// We cannot draw line so lets add marker
                    BitmapDescriptor customMarker;
                    try {
                      BitmapDescriptor customMarker =
                          await BitmapDescriptor.fromAssetImage(
                              ImageConfiguration(), "assets/images/marker.png");
                      _addMarker(
                        LatLng(userPosition.latitude, userPosition.longitude),
                        DateTime.now().millisecondsSinceEpoch.toString(),
                        customMarker,
                      );
                    } catch (e) {
                      customMarker = BitmapDescriptor.defaultMarker;
                      _addMarker(
                        LatLng(userPosition.latitude, userPosition.longitude),
                        DateTime.now().millisecondsSinceEpoch.toString(),
                        customMarker,
                      );
                    }
                    // _getPolylineWithWayPoints(track);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}

Future<void> paymentNeeded(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Abonnement Expirer"),
        content: SingleChildScrollView(
          child: Container(
            child: Text(
                "Vos nombre de trajet instantané sont expirer, \n\n Veiller vous réabonnez"),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Se réabonner'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Payment(),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
