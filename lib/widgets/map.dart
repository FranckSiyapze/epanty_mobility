//
// import 'package:epanty_mobility/model/place.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class Maps extends StatefulWidget {
//   Maps(Key? key, this.place) : super(key: key);
//
//   Place place;
//
//   @override
//   _MapsState createState() => _MapsState();
// }
//
// class _MapsState extends State<Maps> {
//
//   late Place _place;
//   late GoogleMapController _controller;
//   bool isMapCreated = false;
//   String _mapStyle = "";
//   List<Marker> allMarkers = [];
//   List<Marker> twoMarkers = [];
//   late Set<Polyline> direction;
//   late Marker origin;
//   late Marker destination;
//
//   void initStateFunction() async {
//
//   }
//   @override
//   void initState(){
//     initStateFunction();
//     super.initState();
//   }
//   @override
//   void dispose(){
//     _controller.dispose();
//     dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
//
//
// class maps extends StatefulWidget {
//   Place place;
//   maps({Key key, this.place}) : super(key: key);
//
//
//   @override
//   _mapsState createState() => _mapsState();
// }
//
// class _mapsState extends State<maps> {
//   Place _place;
//   GoogleMapController _controller;
//   bool isMapCreated = false;
//   String _mapStyle;
//   List<Marker> allMarkers = [];
//   List<Marker> twoMarkers = [];
//   PageController _pageController;
//   int prevPage;
//   Set<Polyline> direction;
//   Marker origin;
//   Marker destination;
//
//   Map navigationMap;
//
//   @override
//   void dispose(){
//     dispose();
//   }
//
//   @override
//   void initState() {
//     widget.place != null ? _place = widget.place : _place = null;
//     destination = _place != null ?
//     Marker(
//       markerId: MarkerId("destination"),
//       position: LatLng(_place.geopoint.latitude, _place.geopoint.longitude),
//       icon: BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueOrange,
//       ),
//     )
//         : null ;
//     twoMarkers.add(destination);
//
//     super.initState();
//
//     listPlaces2.forEach((place) {
//       allMarkers.add(Marker(
//           icon: BitmapDescriptor.defaultMarkerWithHue(
//             BitmapDescriptor.hueOrange,
//           ),
//           markerId: MarkerId(place.id),
//           draggable: false,
//           infoWindow:
//           InfoWindow(title: place.name, snippet: place.city.name),
//           position: LatLng(place.geopoint.latitude, place.geopoint.longitude) ));
//     });
//     _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
//       ..addListener(_onScroll);
//   }
//
//
//   void _onScroll() {
//     if (_pageController.page.toInt() != prevPage) {
//       prevPage = _pageController.page.toInt();
//       moveCamera();
//     }
//   }
//
//   _coffeeShopList(Place place, index) {
//     return GestureDetector(
//       onTap: (){
//         _place = place;
//         determineUserPosition();
//         setState(() {
//           destination =
//               Marker(
//                 markerId: MarkerId("destination"),
//                 position: LatLng(place.geopoint.latitude, place.geopoint.longitude),
//                 icon: BitmapDescriptor.defaultMarkerWithHue(
//                   BitmapDescriptor.hueOrange,
//                 ),
//               );
//           twoMarkers.add(destination);
//           print(twoMarkers);
//         });
//       },
//       child: AnimatedBuilder(
//         animation: _pageController,
//         builder: (BuildContext context, Widget widget) {
//           double value = 1;
//           if (_pageController.position.haveDimensions) {
//             value = _pageController.page - index;
//             value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
//           }
//           return Center(
//             child: SizedBox(
//               height: Curves.easeInOut.transform(value) * 125.0,
//               width: Curves.easeInOut.transform(value) * 350.0,
//               child: widget,
//             ),
//           );
//         },
//         child: Padding(
//           padding:
//           const EdgeInsets.only(left: 0.0, right: 8.0, top: 5.0, bottom: 5.0),
//           child: Container(
//             height: 140.0,
//             width: 340.0,
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                 boxShadow: [
//                   BoxShadow(
//                       blurRadius: 10.0,
//                       spreadRadius: 2.0,
//                       color: Colors.white.withOpacity(0.03))
//                 ]),
//             child: Row(
//               children: <Widget>[
//                 Material(
//                   color: Colors.transparent,
//                   child: Container(
//                     height: 140.0,
//                     width: 110.0,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(15.0),
//                             bottomLeft: Radius.circular(15.0)),
//                         image: DecorationImage(
//                             image: AssetImage(place.gallery[0]),
//                             fit: BoxFit.cover)),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10.0, top: 10.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Container(
//                           width: 150.0,
//                           child: Text(
//                             place.name,
//                             style: TextStyle(
//                                 fontFamily: "Sofia",
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 17.0),
//                             overflow: TextOverflow.ellipsis,
//                           )),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Icon(
//                               Icons.location_on,
//                               size: 14.0,
//                               color: Colors.deepPurpleAccent,
//                             ),
//                             Container(
//                               width: 140.0,
//                               child: Text(
//                                 place.city.name,
//                                 style: TextStyle(
//                                     color: Colors.black45,
//                                     fontSize: 14.5,
//                                     fontFamily: "Sofia",
//                                     fontWeight: FontWeight.w400),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       /*Padding(
//                         padding: const EdgeInsets.only(top: 15.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Row(
//                                   children: <Widget>[
//                                     Icon(
//                                       Icons.star,
//                                       color: Colors.deepPurpleAccent,
//                                       size: 21.0,
//                                     ),
//                                     Icon(
//                                       Icons.star,
//                                       color: Colors.deepPurpleAccent,
//                                       size: 21.0,
//                                     ),
//                                     Icon(
//                                       Icons.star,
//                                       color: Colors.deepPurpleAccent,
//                                       size: 21.0,
//                                     ),
//                                     Icon(
//                                       Icons.star,
//                                       color: Colors.deepPurpleAccent,
//                                       size: 21.0,
//                                     ),
//                                     Icon(
//                                       Icons.star_half,
//                                       color: Colors.deepPurpleAccent,
//                                       size: 21.0,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),*/
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   _coffeeSingleShopList(Place place) {
//     return Padding(
//       padding:
//       const EdgeInsets.all(16.0),
//       child: Container(
//         height: 160.0,
//         width: 340.0,
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.all(Radius.circular(15.0)),
//             boxShadow: [
//               BoxShadow(
//                   blurRadius: 10.0,
//                   spreadRadius: 2.0,
//                   color: Colors.white.withOpacity(0.03))
//             ]),
//         child: Row(
//           children: <Widget>[
//             Material(
//               color: Colors.transparent,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 4.0),
//                 child: Container(
//                   height: 130.0,
//                   width: 130.0,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                       image: DecorationImage(
//                           image: AssetImage(place.gallery[0]),
//                           fit: BoxFit.cover)),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10.0, top: 10.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                       width: 200.0,
//                       child: Text(
//                         place.name,
//                         style: TextStyle(
//                             fontFamily: "Sofia",
//                             color: Colors.black,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 17.0),
//                         overflow: TextOverflow.ellipsis,
//                       )),
//                   Container(
//                     width: 180.0,
//                     child: Text(
//                       place.description != ""? place.description : " This is the template description of a place",
//                       maxLines: 2,
//                       style: TextStyle(
//                           color: Colors.black45,
//                           fontSize: 14.5,
//                           fontFamily: "Sofia",
//                           fontWeight: FontWeight.w400),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.location_on,
//                               size: 14.0,
//                               color: Colors.amber,
//                             ),
//                             Container(
//                               width: 140.0,
//                               child: Text(
//                                 place.city.name,
//                                 style: TextStyle(
//                                     color: Colors.black45,
//                                     fontSize: 14.5,
//                                     fontFamily: "Sofia",
//                                     fontWeight: FontWeight.w400),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//
//
//
//                         GestureDetector(
//                           onTap: (){
//                             Navigator.of(context).push(PageRouteBuilder(
//                                 pageBuilder: (_, __, ___) => PlaceDetail(place: place),
//                                 transitionDuration: Duration(milliseconds: 600),
//                                 transitionsBuilder:
//                                     (_, Animation<double> animation, __, Widget child) {
//                                   return Opacity(
//                                     opacity: animation.value,
//                                     child: child,
//                                   );
//                                 }));
//                           },
//                           child: Text("Details"),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         navigationMap == null? Container():_ModalBottomSheetDemo( navigationMap),
//                       ],
//                     ),
//                   ),
//                   /*Padding(
//                     padding: const EdgeInsets.only(top: 15.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Row(
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.star,
//                                   color: Colors.deepPurpleAccent,
//                                   size: 21.0,
//                                 ),
//                                 Icon(
//                                   Icons.star,
//                                   color: Colors.deepPurpleAccent,
//                                   size: 21.0,
//                                 ),
//                                 Icon(
//                                   Icons.star,
//                                   color: Colors.deepPurpleAccent,
//                                   size: 21.0,
//                                 ),
//                                 Icon(
//                                   Icons.star,
//                                   color: Colors.deepPurpleAccent,
//                                   size: 21.0,
//                                 ),
//                                 Icon(
//                                   Icons.star_half,
//                                   color: Colors.deepPurpleAccent,
//                                   size: 21.0,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),*/
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     if (_place == null){
//       return new Scaffold(
//           body: Stack(
//             children: <Widget>[
//               Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 child: GoogleMap(
//                   mapType: MapType.normal,
//                   zoomControlsEnabled: false,
//                   initialCameraPosition: CameraPosition(
//                       target:LatLng(4.0641318, 9.706967),
//                       zoom: 13.0),
//
//                   markers: Set.from(allMarkers),
//                   onTap: (pos) {},
//                   onMapCreated: (GoogleMapController controller) {
//                     _controller = controller;
//                     _controller.setMapStyle(_mapStyle);
//                   },
//                   polylines: direction,
//                 ),
//               ),
//
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   height: 200.0,
//                   width: MediaQuery.of(context).size.width,
//                   child: PageView.builder(
//                     controller: _pageController,
//                     itemCount: listPlaces2.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return _coffeeShopList(listPlaces2[index], index);
//                     },
//                   ),
//                 ),
//               ),
//               Column(
//                 children: <Widget>[
//                   Container(
//                     height: 40.0,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                         colors: <Color>[
//                           Color(0x00FFFFFF),
//                           Color(0xFFFFFFFF),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ));
//     }
//     else {
//       return new Scaffold(
//           floatingActionButton: FloatingActionButton(
//             onPressed: () {
//               getDirection(origin: origin, destination: destination);
//             },
//             child: const Icon(Icons.navigation),
//             backgroundColor: Colors.amber,
//           ),
//           body: Stack(
//             children: <Widget>[
//               Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 child: GoogleMap(
//                   mapType: MapType.normal,
//                   zoomControlsEnabled: false,
//                   initialCameraPosition: CameraPosition(
//                       target: LatLng(_place.geopoint.latitude == null? 0.0:_place.geopoint.latitude, _place.geopoint.longitude==null?0.0:_place.geopoint.longitude),
//                       zoom: 16.0),
//
//                   markers: /*Set.from(twoMarkers)*/null,
//                   onTap: (pos) {},
//                   onLongPress: (pos){
//                   },
//                   onMapCreated: (GoogleMapController controller) {
//                     print(_place);
//                     print("*************************************************************");
//                     _controller = controller;
//                     _controller.setMapStyle(_mapStyle);
//                     determineUserPosition();
//                   },
//                   polylines: direction,
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   height: 200.0,
//                   width: MediaQuery.of(context).size.width,
//                   child: Container(
//                     child: _coffeeSingleShopList(_place),
//                   ),
//                 ),
//               ),
//               Column(
//                 children: <Widget>[
//                   Container(
//                     height: 40.0,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                         colors: <Color>[
//                           Color(0x00FFFFFF),
//                           Color(0xFFFFFFFF),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ));
//     }
//   }
//
//   moveCamera() {
//     _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         target: LatLng(listPlaces2[_pageController.page.toInt()].geopoint.latitude, listPlaces2[_pageController.page.toInt()].geopoint.longitude),
//         zoom: 16.0,
//         tilt: 0.0)));
//   }
//
//   void determineUserPosition() async {
//     var location =  new Location();
//
//     var serviceEnabled = await location.serviceEnabled().catchError((e){ print("Error on serviceEnabled() : " + e.toString());});
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService().catchError((e){ print("Error on requestService(): " + e.toString());});
//       if (!serviceEnabled){
//         print("Requested service denied");
//         return;
//       }
//     }
//
//     var permissionGranted = await location.hasPermission().catchError((e){ print("Error on hasPermission(): " + e.toString());});
//
//     if (permissionGranted == PermissionStatus.DENIED){
//       permissionGranted = await location.requestPermission().catchError((e){ print("Error on requestPermission(): " + e.toString());});
//       if (permissionGranted == PermissionStatus.DENIED || permissionGranted == PermissionStatus.DENIED_FOREVER){
//         print("Requested permission denied");
//         return;
//       }
//     }
//
//     var currentLocation = await location.getLocation().catchError((e){ print("Error on getLocation(): " + e.toString());});
//
//     //Position userLocation = await Geolocator.getCurrentPosition();
//     setState(() {
//       origin = Marker(
//         markerId: MarkerId("origin"),
//         position: LatLng(currentLocation.latitude, currentLocation.longitude),
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//           BitmapDescriptor.hueOrange,
//         ),
//       );
//       twoMarkers.add(origin);
//     });
//   }
//
//   void getDirection({Marker origin, Marker destination}) async {
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates("AIzaSyA5RGi0HqYcwBA3xelEIM87p6oZ43zZStU",
//         PointLatLng(origin.position.latitude, origin.position.longitude), PointLatLng(destination.position.latitude, destination.position.longitude));
//
//     List<LatLng> pointList = [];
//
//     result.points.forEach((PointLatLng point) {
//       pointList.add(LatLng(point.latitude, point.longitude));
//     });
//
//     Set<Polyline> polylines = {};
//     polylines.add(Polyline(polylineId: PolylineId("direction"), points: pointList));
//
//     setState(() {
//       direction = polylines;
//       getNavigationHttp(origin.position, destination.position);
//     });
//   }
//
//   /// TO LOOK 1
//   void getNavigationHttp(LatLng l1, LatLng l2) async {
//     Uri url =
//     Uri.parse("https://maps.googleapis.com/maps/api/directions/json?alternatives=true&origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&travelMode=DRIVING&key=AIzaSyA5RGi0HqYcwBA3xelEIM87p6oZ43zZStU");
//     http.Response response = await http.get(url);
//     Map values = jsonDecode(response.body);
//     setState(() {
//       navigationMap = values;
//     });
//     //return values;
//   }
// }
//
