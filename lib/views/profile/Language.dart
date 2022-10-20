import 'dart:async';

import 'package:epanty_mobility/Components/Components.dart';
import 'package:epanty_mobility/localisation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  late SharedPreferences prefs;
  String initialValue = "System Default";
  late int selectedLanguageOption = 1;
  @override
  void initState() {
    languageInitFunction(context);
  }

  void languageInitFunction(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    String? locale = prefs.getString('locale');
    switch (locale) {
      case 'en':
        selectedLanguageOption = 1;
        break;
      case 'fr':
        selectedLanguageOption = 2;
        break;
      case 'es':
      default:
        selectedLanguageOption = 3;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).langue,
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
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 6,
                    child: Opacity(
                      opacity: 0.8,
                      child: Image(
                        image:
                            AssetImage("assets/images/google_translate_icon.png"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    AppLocalizations.of(context).langue1,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).langue,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black38,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    child: Card(
                      //color: Colors.black12.withOpacity(0.00),
                      elevation: 1.9,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                //Icon(Icons.language),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'En',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text("Set language to English"),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Visibility(
                                visible:
                                    selectedLanguageOption == 1 ? true : false,
                                child: Icon(Icons.check),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Timer(Duration(seconds: 0), () async {
                        MyApp.of(context)
                            ?.setLocale(Locale.fromSubtags(languageCode: 'en'));
                        prefs.setString('locale', 'en');
                        selectedLanguageOption = 1;

                      });
                    },
                  ),
                  InkWell(
                    child: Card(
                      //color: Colors.black12.withOpacity(0.00),
                      elevation: 1.9,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                //Icon(Icons.language),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'Fr',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text("Régler la Langue sur Français"),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Visibility(
                                visible:
                                    selectedLanguageOption == 2 ? true : false,
                                child: Icon(Icons.check),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Timer(Duration(seconds: 1), () {
                        MyApp.of(context)
                            ?.setLocale(Locale.fromSubtags(languageCode: 'fr'));
                        prefs.setString('locale', 'fr');
                        setState(() {
                          selectedLanguageOption = 2;
                        });
                      });
                    },
                  ),
                  InkWell(
                    child: Card(
                      elevation: 1.9,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                //Icon(Icons.language),
                                Text(
                                  'Sys',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(AppLocalizations.of(context).syst,
                                    overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Visibility(
                                visible:
                                    selectedLanguageOption == 3 ? true : false,
                                child: Icon(Icons.check),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Timer(Duration(seconds: 1), () {
                        MyApp.of(context)
                            ?.setLocale(Locale.fromSubtags(languageCode: 'es'));
                        prefs.setString('locale', 'es');
                        setState(() {
                          selectedLanguageOption = 3;
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
