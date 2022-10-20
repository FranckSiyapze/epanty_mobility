

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epanty_mobility/views/Settings/complete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FlutterwaveW extends StatefulWidget {
  final String amount ;
  final int qty;
  final String currencyValue;
  const FlutterwaveW({Key? key, required this.amount,required this.qty,required this.currencyValue}) : super(key: key);

  @override
  _FlutterwaveWState createState() => _FlutterwaveWState();
}

class _FlutterwaveWState extends State<FlutterwaveW>{
  final formKey = GlobalKey<FormState>();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController phone = TextEditingController();
  late TextEditingController currencyController = TextEditingController();
  final TextEditingController email = TextEditingController();
  TextEditingController  amount = TextEditingController();
  var uuid = Uuid();
  String selectedCurrency = "";
  int remainingTrips = 0;
  String currency = "";
  @override
  void initState() {
    super.initState();
    amount = new TextEditingController(text: widget.amount);
    currencyController = new TextEditingController(text: widget.currencyValue);
  }

  AddTrip() async {
    var toGet = await FirebaseFirestore.instance
        .collection("Payment")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    remainingTrips = toGet.data()!["trips"] as int;
    var newTrips = remainingTrips + widget.qty;
    await FirebaseFirestore.instance
        .collection("Payment")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'trips': newTrips,
      'status': true,
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
    //print(toGet.data());
    //print(toGet);
  }
  bool isDebug = true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //currencyController.text = selectedCurrency;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(90, 144, 53, 1),
        title: Text("Flutterwave"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: fullname,
                  decoration: const InputDecoration(labelText: "Full Name"),
                  validator: (value) =>
                  value!.isNotEmpty ? null : "Please fill in Your Name",
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: phone,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                  validator: (value) => value!.isNotEmpty
                      ? null
                      : "Please fill in Your Phone number",
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: currencyController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  readOnly: true,
                  //onTap: _openBottomSheet,
                  decoration: const InputDecoration(
                    hintText: "Currency",
                  ),
                  validator: (value) =>
                  value!.isNotEmpty ? null : "Currency is required",
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: email,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) =>
                  value!.isNotEmpty ? null : "Please fill in Your Email",
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  readOnly: true,
                  controller: amount,
                  decoration: const InputDecoration(labelText: "Amount"),
                  validator: (value) => value!.isNotEmpty
                      ? null
                      : "Please fill in the Amount you are Paying",
                ),
              ),
              ElevatedButton(
                child: const Text('Pay with Flutterwave'),
                onPressed: () {
                  final name = fullname.text;
                  final userPhone = phone.text;
                  final userEmail = email.text;
                  final amountPaid = amount.text;
                  final currency = currencyController.text;
                  if (formKey.currentState!.validate()) {
                    _makePayment(context, name, userPhone, userEmail,
                        amountPaid, currency);
                  }
                },
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // ignore: unused_element
  void _makePayment(BuildContext context, String fullname, String phone,
      String email, String amount, String currency) async {
    try {
      Flutterwave flutterwave = Flutterwave.forUIPayment(
        //the first 10 fields below are required/mandatory
        context: context,
        fullName: fullname,
        phoneNumber: phone,
        email: email,
        amount: amount,
        //Use your Public and Encription Keys from your Flutterwave account on the dashboard
        encryptionKey: "fac1d46d5bdb1e58da42a21f",
        //encryptionKey: "FLWSECK_TESTb9ebe6878fba",
        publicKey: "FLWPUBK-aca65e809d976c8026c225203fcc54d8-X",
        //publicKey: "FLWPUBK_TEST-580932fe8d1a6c5fbc9cfa158b44a192-X",
        currency: currency,
        txRef: uuid.v4(),
        //Setting DebugMode below to true since will be using test mode.
        //You can set it to false when using production environment.
        isDebugMode: false,
        //configure the the type of payments that your business will accept
        acceptCardPayment: true,
        acceptBankTransfer: true,
        acceptUSSDPayment: true,
        acceptAccountPayment: true,
        acceptFrancophoneMobileMoney: true,
        acceptGhanaPayment: true,
        acceptMpesaPayment: true,
        acceptRwandaMoneyPayment: true,
        acceptUgandaPayment: true,
        acceptZambiaPayment: true,
      );
      final response = await flutterwave.initializeForUiPayments();
      print(response);
      // ignore: unnecessary_null_comparison
      if (response == null) {
        print("Transaction Failed");
      } else {
        if (response.status == "Transaction successful") {
          print(response.status);
          print(response.data);
          print(response.message);
          AddTrip();
          /****
           * C'est ici qu'on impelemente
           * la rédirection sur la page de réussite du paiement
           * */

        } else {
          print(response.message);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _openBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _getCurrency();
        });
  }

  Widget _getCurrency() {
    final currencies = [
      FlutterwaveCurrency.UGX,
      FlutterwaveCurrency.GHS,
      FlutterwaveCurrency.NGN,
      FlutterwaveCurrency.RWF,
      FlutterwaveCurrency.KES,
      FlutterwaveCurrency.XAF,
      FlutterwaveCurrency.XOF,
      FlutterwaveCurrency.ZMW,
      FlutterwaveCurrency.USD
    ];
    return Container(
      height: 250,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: currencies
            .map((currency) => ListTile(
          onTap: () => {_handleCurrencyTap(currency)},
          title: Column(
            children: [
              Text(
                currency,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 4),
              Divider(height: 1)
            ],
          ),
        ))
            .toList(),
      ),
    );
  }

  _handleCurrencyTap(String currency) {
    setState(() {
      selectedCurrency = currency;
      currencyController.text = currency;
    });
    Navigator.pop(context);
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }

}