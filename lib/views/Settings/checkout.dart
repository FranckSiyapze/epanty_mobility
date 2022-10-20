import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epanty_mobility/services/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flash/flash.dart';
import 'package:progress_indicator_button/progress_button.dart';

import 'complete.dart';

class Checkout extends StatefulWidget {
  final String amount;
  final List data;
  final int qty;

  const Checkout({
    Key? key,
    required this.data,
    required this.amount,
    required this.qty,
  }) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool _isLoading = true;
  final numberController = TextEditingController();
  late Api apiservice = Api();
  late Timer _timer;
  int _start = 10;
  var uuid = Uuid();
  int remainingTrips = 0;
  String currency = "";
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
          .update({
            'trips': newTrips
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

  @override
  void initState() {
    getCurrency();
    super.initState();
    if (widget.data.isNotEmpty) {
      setState(() {
        _isLoading = false;
      });
    }
    print(widget.data);
  }

  getCurrency() async{
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("localCurrency") != null) {
      setState(() {
        currency = prefs.getString("localCurrency")!;
      });
    }
    print("ISO COUNTRY CODE : ${currency}");

  }

  requestToPay(AnimationController controller, amount, meanCode, paymentNumber,
      orderNumber, feesAmount) {
    var message = "";
    controller.forward();
    print("delay start");
    apiservice.getADPToken().then((value1) async {
      setState(() {
        //print(value["data"]["tokenCode"]);
        apiservice
            .requestToPay(value1["data"]["tokenCode"], meanCode, paymentNumber,
                orderNumber, amount, feesAmount)
            .then((value) async {
          if (value["data"] != null) {
            if (value["data"]["status"] == 'G') {
              controller.reset();
              print("delay end");
              context.showErrorBar(
                  content: const Text("Une erreur s'est produiteeee"));
              print("Une erreur s'est produiteeeee");
            } else if (value["data"]["status"] != 'E') {
              controller.reset();
              print("delay end");
              message = value["data"]["description"];
              if (value["data"]["status"] != 'O') {
                message = "La transaction n'a pas été effectué";
              }
              context.showErrorBar(content: Text(message));
              print("La transaction n'a pas été effectué");
            } else {
              //print("Reussi");
              context.showInfoBar(content: const Text('Paiement initié'));
              const oneSec = Duration(seconds: 15);
              _timer = Timer.periodic(oneSec, (timer) {
                if (_start == 0) {
                  setState(() {
                    _timer.cancel();
                  });
                } else {
                  checkStatus(
                    controller,
                    value["data"]["adpFootprint"],
                    meanCode,
                  );
                }
              });
            }
          } else {
            print(value);
            message = "Une erreur est survenueeee";
            if (value["pesake"]["code"] == 30118) {
              message = value["pesake"]["detail"];
              print(message);
              controller.reset();
              print("delay end");
            } else if (value["pesake"]["code"] == 20008) {
              message = "Le numéro payeur de correspond pas à l'opérateur";
              controller.reset();
              print("delay end");
            }
            controller.reset();
            print("delay end");
            context.showErrorBar(content: Text(message));
          }
        });
      });
    });
  }

  checkStatus(
    AnimationController controller,
    adpFootprint,
    meanCode,
  ) {
    var message = '';
    apiservice.getADPToken().then((value1) async {
      setState(() {
        //print(value["data"]["tokenCode"]);
        apiservice
            .checkStatus(value1["data"]["tokenCode"], meanCode, adpFootprint)
            .then((value) async {
          if (value["data"] != null) {
            print(value["data"]);
            if (value["data"]["status"] == 'T') {
              context.showSuccessBar(
                  content: Text('Paiement réussi avec succès'));
              setState(() {
                _start = 0;
              });
              controller.reset();
              print("delay end");
              AddTrip();
              /****
               * C'est ici qu'on impelemente
               * la rédirection sur la page de réussite du paiement
               * */
            } else if (value["data"]["status"] != 'E') {
              message = value["data"]["description"];
              if (value["data"]["status"] != 'O') {
                message = "La transaction n'a pas été effectué";
              }
              setState(() {
                _start = 0;
              });
              context.showErrorBar(content: Text(message));
              controller.reset();
              print("delay end");
              /****
               * C'est ici qu'on impelemente
               * Une action lorsqu'il y'a une erreur de paiement
               * */
            }
          }
        });
      });
    });
  }

  _onAlertFinalPay(context, meanCode, feesAmout, total, orderNumber) {
    var priceFinal = int.parse(total) + feesAmout;
    Alert(
        context: context,
        title: "Montant total : " + (priceFinal).toString() +" "+ currency,
        content: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            TextField(
              decoration: const InputDecoration(
                icon: Icon(Icons.phone),
                labelText: 'Numero de téléphone',
              ),
              controller: numberController,
            )
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.white,
            onPressed: () {},
            child: ProgressButton(
              progressIndicatorColor: Colors.white,
              color: Color.fromRGBO(90, 144, 53, 1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              strokeWidth: 2,
              child: const Text(
                "Valider le paiement",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              onPressed: (AnimationController controller) async {
                FocusScope.of(context).requestFocus(FocusNode());
                requestToPay(controller, total, meanCode, numberController.text,
                    orderNumber, feesAmout);
              },
            ),
          ),
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(90, 144, 53, 1),
        title: Text("Checkout"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          if (_isLoading)
            Shimmer.fromColors(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100),
          if (!_isLoading)
            Column(children: [
              const SizedBox(
                height: 10,
              ),
              Text('Montant à payer : \n\t\t\t' + (int.parse(widget.amount)).toString() +" "+ currency+ "  + 2% de frais transactionel"),
              const SizedBox(
                height: 10,
              ),
              Container(
                child: ListView.builder(
                    itemCount: widget.data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, int i) {
                      return InkWell(
                        onTap: () => {
                          _onAlertFinalPay(
                            context,
                            widget.data[i]["meanCode"],
                            widget.data[i]["feesAmount"],
                            widget.amount,
                            uuid.v4(),
                          )
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  "assets/images/payment/" +
                                      widget.data[i]["meanCode"] +
                                      ".png",
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                  widget.data[i]["meanCode"],
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ])
        ],
      ),
    );
  }
}
