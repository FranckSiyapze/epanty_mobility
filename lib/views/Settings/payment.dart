import 'package:epanty_mobility/localisation.dart';
import 'package:epanty_mobility/services/api.dart';
import 'package:epanty_mobility/views/Settings/Intermediaire.dart';
import 'package:epanty_mobility/views/Settings/payment-1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String currency = "";
  double bold = 0;
  double platinium = 0;
  double live = 0;
  late Api apiservice = Api();
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBold();
  }

  getBold() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("localCurrency") != null) {
      currency = prefs.getString("localCurrency")!;
    }
    apiservice.convertCurrency(currency, 1).then((value) {
      print(value["rates"]["" + currency + ""]["rate"]);
      setState(() {
        _isLoading = false;
        bold = 3 * double.parse(value["rates"]["" + currency + ""]["rate"]);
        platinium =
            12.0 * double.parse(value["rates"]["" + currency + ""]["rate"]);
        live = 16.0 * double.parse(value["rates"]["" + currency + ""]["rate"]);
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
      body: StateBuilder(
        models: [],
        builder: (context, _) => _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Payment1(
                                  amount: bold.toStringAsFixed(0),
                                  qty: 1000000,
                                )));
                      },
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Bold - 1 ' +
                                  AppLocalizations.of(context).mois),
                              Text(
                                bold.toStringAsFixed(0) + " " + currency,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Payment1(
                          amount: platinium.toStringAsFixed(0),
                          qty: 1000000,
                        ),
                      ));
                    },
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Platinium - 6 ' +
                                AppLocalizations.of(context).mois),
                            Text(
                              platinium.toStringAsFixed(0) + " " + currency,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Payment1(
                          amount: live.toStringAsFixed(0),
                          qty: 1000000,
                        ),
                      ));
                    },
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('LIVE - 12 ' +
                                AppLocalizations.of(context).mois),
                            Text(
                              live.toStringAsFixed(0) + " " + currency,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
