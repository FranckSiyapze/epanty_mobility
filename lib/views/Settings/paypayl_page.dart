import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../services/paypal.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  final String amount;
  final int qty;
  final String currencyValue;
  PaypalPayment(
      {required this.onFinish,
      required this.amount,
      required this.currencyValue,
      required this.qty});
  @override
  PaypalPaymentState createState() => PaypalPaymentState();
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String checkoutUrl = "";
  late String executeUrl;
  late String accessToken;
  PaypalServices services = PaypalServices();

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  bool _isCurrencyOk = true;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';
  String name = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    String currency = widget.currencyValue;
    // you can change default currency according to your need
    Map<dynamic, dynamic> defaultCurrency = {
      "symbol": currency,
      "decimalDigits": 2,
      "symbolBeforeTheNumber": true,
      "currency": currency
    };
    name = FirebaseAuth.instance.currentUser!.displayName!;
    //phone = FirebaseAuth.instance.currentUser!.phoneNumber!;

    Future.delayed(
      Duration.zero,
      () async {
        try {
          accessToken = (await services.getAccessToken())!;

          final transactions = {
            "intent": "sale",
            "payer": {"payment_method": "paypal"},
            "transactions": [
              {
                "amount": {
                  "total": widget.amount,
                  "currency": defaultCurrency["currency"],
                  "details": {
                    "subtotal": widget.amount,
                    "shipping": '0',
                    "shipping_discount": ((-1.0) * 0).toString()
                  }
                },
                "description": "The payment transaction description.",
                "payment_options": {
                  "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
                },
                "item_list": {
                  "items": [
                    {
                      "name": "package flutter",
                      "quantity": 1,
                      "price": widget.amount,
                      "currency": defaultCurrency["currency"]
                    }
                  ],
                  if (isEnableShipping && isEnableAddress)
                    "shipping_address": {
                      "recipient_name": name,
                      "line1": "",
                      "line2": "",
                      "city": "",
                      "country_code": "",
                      "postal_code": "",
                      "phone": "",
                      "state": ""
                    },
                }
              }
            ],
            "note_to_payer": "Contact us for any questions on your order.",
            "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
          };
          final res =
              await services.createPaypalPayment(transactions, accessToken);
          if (res != null) {
            setState(() {
              checkoutUrl = res["approvalUrl"]!;
              executeUrl = res["executeUrl"]!;
            });
          }
        } catch (e) {
          print('exception: ' + e.toString());
          final snackBar = SnackBar(
            content: Text(e.toString()),
            duration: Duration(seconds: 10),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          setState(() {
            _isCurrencyOk = false;
          });
          //_scaffoldKey.currentState.showSnackBar(snackBar);
          /* final snackBar = SnackBar(
            content: const Text('Yay! A SnackBar!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          ); */
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
  }

  /* Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": itemName,
        "quantity": quantity,
        "price": itemPrice,
        "currency": defaultCurrency["currency"]
      }
    ];

    // checkout invoice details
    String totalAmount = '1.99';
    String subTotalAmount = '1.99';
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = 'Gulshan';
    String userLastName = 'Yadav';
    String addressCity = 'Delhi';
    String addressStreet = 'Mathura Road';
    String addressZipCode = '110014';
    String addressCountry = 'India';
    String addressState = 'Delhi';
    String addressPhoneNumber = '+919990119091';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName + " " + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  } */

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);
    // ignore: unnecessary_null_comparison
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: checkoutUrl.isNotEmpty
          ? WebView(
              initialUrl: checkoutUrl,
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) {
                if (request.url.contains(returnURL)) {
                  final uri = Uri.parse(request.url);
                  final payerID = uri.queryParameters['PayerID'];
                  if (payerID != null) {
                    services
                        .executePayment(executeUrl, payerID, accessToken)
                        .then((id) {
                      widget.onFinish(id);
                      Navigator.of(context).pop();
                    });
                  } else {
                    Navigator.of(context).pop();
                  }
                  Navigator.of(context).pop();
                }
                if (request.url.contains(cancelURL)) {
                  Navigator.of(context).pop();
                }
                return NavigationDecision.navigate;
              },
            )
          : Center(
              child: Container(
                child: _isCurrencyOk
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        child: const Text('Retour'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
              ),
            ),
    );
    /* if (checkoutUrl.isNotEmpty) {
      
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    } */
  }
}
