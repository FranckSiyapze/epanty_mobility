/// This is the Profile Page
/// It is here that the user modifies the settings relative to his app usage
/// and also the general settings
import 'package:epanty_mobility/localisation.dart';
import 'package:epanty_mobility/views/Settings/payment.dart';
import 'package:epanty_mobility/views/authentication/authPage.dart';
import 'package:epanty_mobility/views/profile/GeneralInformation.dart';
import 'package:epanty_mobility/views/profile/Language.dart';
import 'package:epanty_mobility/views/profile/Password.dart';
import 'package:epanty_mobility/views/profile/Privacy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  static var _txtCustomHead = TextStyle(
    color: Colors.white,
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    fontFamily: "Gotik",
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///App Bar, same like all the other tabs
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).params,
          style: TextStyle(
            fontFamily: "Sofia",
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(90, 144, 53, 1),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              ///Settings set 1
              setting(
                head: AppLocalizations.of(context).compte,
                sub1: AppLocalizations.of(context).informationGeneral,
                sub1fxn: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => GeneralInformation()),
                  );
                },
                sub2: AppLocalizations.of(context).newPassword,
                sub2fxn: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ChangePassword()),
                  );
                },
                sub3: AppLocalizations.of(context).pay,
                sub3fxn: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Payment()),
                  );
                },
              ),

              ///Settings set 2
              setting(
                head: AppLocalizations.of(context).params,
                sub1: AppLocalizations.of(context).langue,
                sub1fxn: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Language()),
                  );
                },
                sub2: AppLocalizations.of(context).confidentialite,
                sub2fxn: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Privacy()),
                  );
                },
                /*sub3: DemoLocalizations.of(context).security,
                sub3fxn: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Security()),
                  );
                },*/
              ),

              ///Settings set 3
              /*setting(
                head: DemoLocalizations.of(context).preferences,
                /*sub1: DemoLocalizations.of(context).accountActivity,
                sub1fxn: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => AccountActivity()),
                  );
                },*/
                sub1: DemoLocalizations.of(context).launchRecordingMode,
                sub1fxn: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => LaunchRecordingMode()),
                  );
                },
                /*sub2: DemoLocalizations.of(context).opportunity,
                sub2fxn: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Opportunity()),
                  );
                },*/
              ),*/
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: InkWell(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    /*Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => AuthPage()),
                    );*/
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      color: Colors.redAccent.withOpacity(0.75),
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 13.0, left: 20.0, bottom: 15.0),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).deconnexion,
                            style: _txtCustomHead,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class setting extends StatelessWidget {
  static var _txtCustomHead = TextStyle(
    color: Color.fromRGBO(90, 144, 53, 1),
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    fontFamily: "Gotik",
  );

  static var _txtCustomSub = TextStyle(
    color: Colors.black38,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: "Gotik",
  );

  String head;
  String? sub1, sub2, sub3;
  VoidCallback? sub1fxn, sub2fxn, sub3fxn;

  setting({
    required this.head,
    this.sub1,
    this.sub1fxn,
    this.sub2,
    this.sub2fxn,
    this.sub3,
    this.sub3fxn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        //height: sub3 != null ? 230.0 : sub2 != null ? 170 : 105 ,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
                child: Text(
                  head,
                  style: _txtCustomHead,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
                  color: Colors.black12,
                  height: 0.5,
                ),
              ),
              sub1 != null ?
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                child: InkWell(
                  onTap: sub1fxn,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          sub1??"text",
                          style: _txtCustomSub,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black38,
                        )
                      ]),
                ),
              ) : Container(),

              sub1 != null ?
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
                  color: Colors.black12,
                  height: 0.5,
                ),
              ) : Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Container(),
              ),

              sub2 != null ?
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                child: InkWell(
                  onTap: sub2fxn,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          sub2??"",
                          style: _txtCustomSub,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black38,
                        )
                      ]),
                ),
              ):Container(),

              sub2 != null ?
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
                  color: Colors.black12,
                  height: 0.5,
                ),
              ):Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Container(),
              ),

              sub3 != null ?
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                child: InkWell(
                  onTap: sub3fxn,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          sub3??"",
                          style: _txtCustomSub,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black38,
                        )
                      ]),
                ),
              ):Container(),

              sub3 != null ?
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
                  color: Colors.black12,
                  height: 0.5,
                ),
              ):Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
