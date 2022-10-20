import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epanty_mobility/Components/Components.dart';
import 'package:epanty_mobility/model/trip.dart';
import 'package:epanty_mobility/views/Home/Trip/tripDetail.dart';
import 'package:epanty_mobility/views/Settings/payment.dart';
import 'package:epanty_mobility/views/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TripTab extends StatefulWidget {
  const TripTab({Key? key}) : super(key: key);

  @override
  _TripTabState createState() => _TripTabState();
}

class _TripTabState extends State<TripTab> {
  Stream<QuerySnapshot<Map<String, dynamic>>> tripStream = FirebaseFirestore
      .instance
      .collection("tripData")
      .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where("_isDeleted", isEqualTo: false)
      .snapshots();

  int remainingTrips = 0;

  void initStateFunction() async {
    var toGet = await FirebaseFirestore.instance
        .collection("Payment")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (toGet.data() != null) {
      remainingTrips = toGet.data()!["trips"] as int;
      print("TESTTTTT NOMBRE " + remainingTrips.toString());
    } else {
      print("RESTE DE NOMBRE " + remainingTrips.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initStateFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        centerTitle: true,
        backgroundColor: Color.fromRGBO(90, 144, 53, 1),
        title: Text('Trajets'),
        actions: <Widget>[],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ProfileTab(),
      ),
      body: StreamBuilder(
        stream: tripStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Container(
              alignment: Alignment.center,
              child: Text(
                  " Une Erreur s'est produit en essayant\nd'obtenir les données en ligne. \nVérifiez votre connexion"),
            );
          } else if(remainingTrips > 0){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                padding: EdgeInsets.all(26),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LinearProgressIndicator(
                      backgroundColor: Color.fromRGBO(90, 144, 53, 1),
                    ),
                    SizedBox(height: 20),
                    Text(
                        " Nous récuperons vos données en ligne \n Patientez svp..."),
                  ],
                ),
              );
            } else {
              return Container(
                height: double.infinity,
                width: double.infinity,
                child: snapshot.data?.docs.length == 0
                    ? Container(
                        alignment: Alignment.center,
                        child: Text("Aucun trajet effectué"))
                    : ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext, int) {
                          if (snapshot.data?.docs.length == 0) {
                            return Container(
                              alignment: Alignment.center,
                              child: Text("No Trip for the moment"),
                            );
                          }
                          List<PolylineWayPoint> route = routeFormFirebase(
                              snapshot.data?.docs.elementAt(int)["points"]);
                          Trip trip = Trip(
                            startPosition: LatLng(
                                snapshot.data?.docs
                                        .elementAt(int)["startPosition"]["lat"]
                                    as double,
                                snapshot.data?.docs
                                        .elementAt(int)["startPosition"]["lng"]
                                    as double),
                            stopPosition: LatLng(
                                snapshot.data?.docs
                                        .elementAt(int)["stopPosition"]["lat"]
                                    as double,
                                snapshot.data?.docs
                                        .elementAt(int)["stopPosition"]["lng"]
                                    as double),
                            startTime: (snapshot.data?.docs
                                    .elementAt(int)["startTime"] as Timestamp)
                                .toDate(),
                            stopTime: (snapshot.data?.docs
                                    .elementAt(int)["stopTime"] as Timestamp)
                                .toDate(),
                            route: route,
                          );
                          return TripCard(
                              data: trip,
                              documentID:
                                  snapshot.data?.docs.elementAt(int).id ??
                                      "test");
                        },
                      ),
              );
            }
          } else{
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(""),
                    SizedBox(height: 10,),
                    Container(
                      child: Text(
                          "Vos nombre de trajet instantané sont expirer, \n\n Veiller vous réabonnez"),
                    ),
                    SizedBox(height: 10),
                    DialogButton(
                      color: Color.fromRGBO(90, 144, 53, 1),
                      child: const Text(
                        "Se réabonner",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Payment(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  List<PolylineWayPoint> routeFormFirebase(String encodedPolylines) {
    List<PolylineWayPoint> list = [];

    List<String> stringPoints = encodedPolylines.split("_Point_");
    stringPoints.forEach((element) {
      list.add(PolylineWayPoint(location: '${element}', stopOver: false));
    });
    return list;
  }
}

class TripCard extends StatefulWidget {
  TripCard({Key? key, required this.data, required this.documentID})
      : super(key: key);

  final Trip data;
  final String documentID;

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  String? stopPositionName;
  String? startPositionName;
  final ValueNotifier<int> positionNameGotten = ValueNotifier<int>(0);

  void initStateFunction() async {
    try {
      List<Placemark> stopPosition = await placemarkFromCoordinates(
          widget.data.startPosition.latitude,
          widget.data.startPosition.longitude);
      stopPositionName = stopPosition.first.country;
      List<Placemark> startPosition = await placemarkFromCoordinates(
          widget.data.stopPosition.latitude,
          widget.data.stopPosition.longitude);
      startPositionName = startPosition.first.country;
      positionNameGotten.value = 1;
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  @override
  void initState() {
    //initStateFunction();
    positionNameGotten.value = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: positionNameGotten,
        child: null,
        builder: (BuildContext context, int status, Widget? child) {
          if (status == 0) {
            return Container(child: Text("Loading"));
          } else if (status == 1) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TripDetail(data: widget.data),
                  ));
                },
                child: Card(
                  elevation: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(left: 8.0),
                          height: 95,
                          width: 95,
                          child: Image.asset("assets/images/map.jpg"),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              " ${widget.data.startTime.day} - ${widget.data.startTime.month} - ${widget.data.startTime.year}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                  fontSize: 14),
                            ),
                            Text(
                              " ${widget.data.startTime.hour} Hr : ${widget.data.startTime.minute} Min",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                  fontSize: 14),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                "  Durée  :  ${widget.data.stopTime.difference(widget.data.startTime).inHours} hr :${widget.data.stopTime.difference(widget.data.startTime).inMinutes % 60} min",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: 50,
                          child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.blueGrey,
                            ),
                            color: Colors.blueGrey,
                            onPressed: () async {
                              await _showMyDialog(context, widget.documentID);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container(child: Text("error"));
          }
        });
  }
}

Future<void> _showMyDialog(BuildContext context, String docId) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Suppression de trajet"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("Voulez-vous vraiment supprimer le trajet ?"),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Oui"),
            onPressed: () async {
              await FirebaseFirestore.instance
                ..collection("tripData").doc(docId).update({
                  "_isDeleted": true,
                });

              showSnackBar(context, "Trajet supprimer");
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Non"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
