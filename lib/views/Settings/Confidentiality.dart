import 'package:flutter/material.dart';

class Confidentiality extends StatefulWidget {
  const Confidentiality({Key? key}) : super(key: key);

  @override
  _ConfidentialityState createState() => _ConfidentialityState();
}

class _ConfidentialityState extends State<Confidentiality> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(90, 144, 53, 1),
        title: Text("Confidentialité"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text("Confidentialité"),
      ),
    );
  }
}
