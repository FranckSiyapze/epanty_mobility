import 'package:epanty_mobility/views/Settings/complete.dart';
import 'package:epanty_mobility/views/Settings/paypayl_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epanty_mobility/services/api.dart';
import 'package:epanty_mobility/views/Settings/Flutterwave.dart';
import 'package:epanty_mobility/views/Settings/checkout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../localisation.dart';

class Payment1 extends StatefulWidget {
  final String amount;
  final int qty;
  Payment1({
    Key? key,
    required this.amount,
    required this.qty,
  }) : super(key: key);

  @override
  _Payment1State createState() => _Payment1State();
}

class _Payment1State extends State<Payment1> {
  late Api apiservice = Api();
  String currency = "";
  bool _checkFees = true;
  int remainingTrips = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getTrip();
    getCurrency();
  }

  AddTrip() async {
    var toGet = await FirebaseFirestore.instance
        .collection("Payment")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (toGet.data() != null) {
      remainingTrips = toGet.data()!["trips"] as int;
      print(remainingTrips);
      var newTrips = remainingTrips + widget.qty;
      await FirebaseFirestore.instance
          .collection("Payment")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'trips': newTrips})
          .then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Complete(),
              ),
            ),
          )
          .catchError((error) => print("Failed to update user: $error"));
    } else {
      await FirebaseFirestore.instance
          .collection("Payment")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
            'trips': widget.qty,
          })
          .then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Complete(),
              ),
            ),
          )
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("localCurrency") != null) {
      setState(() {
        currency = prefs.getString("localCurrency")!;
      });
    }
    print("ISO COUNTRY CODE : ${currency}");
  }

  getFees(amount) {
    apiservice.getADPToken().then((value) async {
      print(value);
      setState(() {
        apiservice
            .getFees(value["data"]["tokenCode"], amount)
            .then((value1) async {
          setState(() {
            _checkFees = true;
          });
          //print(value1["data"]);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Checkout(
                data: value1["data"],
                amount: amount,
                qty: widget.qty,
              ),
            ),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(90, 144, 53, 1),
        title: Text(AppLocalizations.of(context).paiment),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currency == 'XAF')
                InkWell(
                  onTap: () {
                    setState(() {
                      _checkFees = false;
                    });
                    getFees(widget.amount);
                  },
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/payment/adp.png'),
                              backgroundColor: Colors.black12,
                              radius: 220,
                            ),
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_checkFees)
                            Text(
                              'ADWAPAY',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          if (!_checkFees)
                            //SizedBox(height: 10,),
                            SizedBox(
                              child: CircularProgressIndicator(),
                              width: 16,
                              height: 16,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FlutterwaveW(
                      amount: widget.amount,
                      qty: widget.qty,
                      currencyValue: currency,
                    ),
                  ));
                },
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/images/payment/flutterwave.png'),
                            backgroundColor: Colors.black12,
                            radius: 220,
                          ),
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'FLUTTERWAVE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //if (currency != 'XAF')
                
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PaypalPayment(
                          amount: widget.amount,
                          qty: widget.qty,
                          currencyValue: currency,
                          onFinish: (number) async {
                            // payment done
                            AddTrip();
                            print('order id: ' + number);
                          },
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/images/payment/paypal.webp'),
                              backgroundColor: Colors.black12,
                              radius: 220,
                            ),
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'PAYPAL',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ]
          )
        ],
      ),
    );
  }
}
