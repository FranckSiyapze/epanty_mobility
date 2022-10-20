import 'package:flutter/material.dart';

class Security extends StatefulWidget {
  const Security({Key? key}) : super(key: key);

  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(90, 144, 53, 1),
        title: Text("Sécurité"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text("Sécurité"),
      ),
    );
  }
}
