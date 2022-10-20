import 'package:epanty_mobility/model/trip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetail extends StatefulWidget {
  TripDetail({Key? key, required this.data}) : super(key: key);

  final Trip data;

  @override
  _TripDetailState createState() => _TripDetailState();
}

class _TripDetailState extends State<TripDetail> {
  late GoogleMapController mapController;
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyA5RGi0HqYcwBA3xelEIM87p6oZ43zZStU";
  List<LatLng> polylineCoordinates = [];
  List<PolylineWayPoint> route = [];


  void initStateFunction() {
    // get Track
  }

  @override
  void initState() {
    initStateFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Détail du Trajet",
          style: TextStyle(
            fontFamily: "Sofia",
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(90, 144, 53, 1),
        centerTitle: true,
        elevation: 10,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: (){
          showModalBottomSheet<void>(
            context: context,
            builder: (context) {
              return Details(data: widget.data);
            },
          );
        },
        child: Container(
          alignment: Alignment.center,
          height: 50,
          width: 140,
          child: Card(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Row(
                children: [
                  Icon(Icons.description, color: Color.fromRGBO(90, 144, 53, 1),),
                  SizedBox(width: 10),
                  Text("Détails"),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        child: GoogleMap(
          myLocationButtonEnabled: false,
          compassEnabled: false,
          myLocationEnabled: false,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              (widget.data.startPosition.latitude +
                      widget.data.stopPosition.latitude) /
                  2,
              (widget.data.startPosition.longitude +
                      widget.data.stopPosition.longitude) /
                  2,
            ),
            zoom: 13,
            tilt: 0.0,
          ),
          onMapCreated: _onMapCreated,
          markers: {
            Marker(
                markerId: MarkerId("origin"),
                position: LatLng(widget.data.startPosition.latitude,
                    widget.data.startPosition.longitude),
            ),
            Marker(
                markerId: MarkerId("destination"),
                position: LatLng(widget.data.stopPosition.latitude,
                    widget.data.stopPosition.longitude),
            ),
          },
          polylines: Set<Polyline>.of(polylines.values),
          zoomGesturesEnabled: true,
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: false,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    _getPolyline();
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

  _getPolyline() async {

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(widget.data.startPosition.latitude, widget.data.startPosition.longitude),
      PointLatLng(widget.data.stopPosition.latitude, widget.data.stopPosition.longitude),
      travelMode: TravelMode.driving,
      wayPoints: widget.data.route,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}

class Details extends StatelessWidget {
  Details({required this.data});

  final Trip data;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Center(
              child: Text(
                "Détails",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Divider(thickness: 1),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Distance totale : 25 Km", style: TextStyle(fontSize: 24)),
                  Row(
                    children: [
                      Text("Durée : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                      Text("${data.stopTime.difference(data.startTime).toString().split(".").first}", style: TextStyle(fontSize: 24))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
