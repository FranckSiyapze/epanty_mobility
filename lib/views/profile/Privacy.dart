import 'package:epanty_mobility/localisation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).confidentialite,
          style: TextStyle(
            fontFamily: "Sofia",
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(90, 144, 53, 1),
        elevation: 10,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: (!_isloading)
                  ? WebView(
                      initialUrl:
                          "https://scorp-corporate.com/politique.html",
                      javascriptMode: JavascriptMode.unrestricted,
                      zoomEnabled: true,
                      initialCookies: [],
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(90, 144, 53, 1),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
