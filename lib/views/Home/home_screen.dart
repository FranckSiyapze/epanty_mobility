import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_pickers/utils/utils.dart';
import 'package:epanty_mobility/localisation.dart';
import 'package:epanty_mobility/views/Home/map.dart';
import 'package:epanty_mobility/views/Home/trip.dart';
import 'package:epanty_mobility/views/Settings/payment.dart';
import 'package:epanty_mobility/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat/chat.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _tabPageController = PageController();
  int _selectedTab = 0;
  String title = "Epanty Mobolity";
  bool blockTabsHome = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _tabPageController.jumpToPage(1);
        _selectedTab = 1;
        //_reloaded = true;
      });
    });
    initStateFunction();
    getCountryName();
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      //currency();
    });
  }

  Future<String?> getCountryName() async {
    final prefs = await SharedPreferences.getInstance();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //debugPrint('location: ${position.latitude}');
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      var currency =
          CurrencyPickerUtils.getCountryByIsoCode(place.isoCountryCode)
              .currencyCode
              .toString();
      await prefs.setString('localCurrency', currency);
      print("ISO COUNTRY CODE : ${currency}");
      print("Location : ${place.locality}");
      print("PostalCode : ${place.postalCode}");
      print("Country : ${place.country} - ${place.locality}");
      return place.country;
    } catch (e) {
      print(e);
    }

    //return place.country; // this will return country name
  }

  _getAddressFromLatLng() async {}

  int remainingTrips = 0;

  void initStateFunction() async {
    var toGet = await FirebaseFirestore.instance
        .collection("Payment")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (toGet.data() != null) {
      remainingTrips = toGet.data()!["trips"] as int;
      print("TEST NOMBRE " + remainingTrips.toString());
    } else {
      print("RESTE DE NOMBRE " + remainingTrips.toString());
    }
  }

  @override
  void dispose() {
    _tabPageController.dispose();
    super.dispose();
  }

  Future<void> paymentNeeded(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).abonnement),
          content: SingleChildScrollView(
            child: Container(
              child: Text(AppLocalizations.of(context).abonnementtexte)
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

  @override
  Widget build(BuildContext context) {
    DateTime? _lastQuitTime;

    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          if (_lastQuitTime == null ||
              DateTime.now().difference(_lastQuitTime!).inSeconds > 1) {
            print('Press again Back Button exit');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Appuyez encore pour sortir de l'application")),
            );
            _lastQuitTime = DateTime.now();
            return false;
          } else {
            print('sign out');
            await SystemChannels.platform
                .invokeMethod<void>('SystemNavigator.pop');
            return true;
          }
        },
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabPageController,
                  onPageChanged: (num) {
                    setState(() {
                      _selectedTab = num;
                    });
                  },
                  children: [
                    TripTab(),
                    MapTab(blockTabs: () {
                      if (blockTabsHome == false) {
                        setState(() {
                          blockTabsHome = true;
                        });
                      } else {
                        setState(() {
                          blockTabsHome = false;
                        });
                      }
                    }),
                    Chat(),
                    //paymentNeeded(context);
                  ],
                )),
                BottomTabs(
                  selectedTab: _selectedTab,
                  tabPressed: (num) {
                    if (!blockTabsHome) {
                      setState(() {
                        _tabPageController.animateToPage(num,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
