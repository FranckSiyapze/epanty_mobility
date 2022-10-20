import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epanty_mobility/services/api.dart';
import 'package:epanty_mobility/views/Settings/Flutterwave.dart';
import 'package:epanty_mobility/views/Settings/checkout.dart';
import 'package:flutter/material.dart';

class Intermediaire extends StatefulWidget {
  final String amount;
  final int qty;
  Intermediaire({Key? key, required this.amount, required this.qty,}) : super(key: key);

  @override
  _IntermediaireState createState() => _IntermediaireState();
}

class _IntermediaireState extends State<Intermediaire> {
  late Api apiservice = Api();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getTrip();
  }

  getFees(amount) {
    apiservice.getADPToken().then((value) async {
      setState(() {
        //print(value["data"]["tokenCode"]);
        apiservice
            .getFees(value["data"]["tokenCode"], amount)
            .then((value1) async {
          //print(value1["data"]);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Checkout(
                  data: value1["data"],
                  amount: amount,
                  qty: widget.qty,
                ),),
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
        title: Text("Paiement - Mode de paiement"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
              onTap: () {
                getFees(widget.amount);
              },
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('ADWAPAY'),
                    ],
                  ),
                ),
              )),
          InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FlutterwaveW(
                    amount: widget.amount,
                    qty: widget.qty,
                    currencyValue: "",
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
                      Text('FLUTTERWAVE'),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

}
