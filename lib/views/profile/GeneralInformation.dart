import 'package:epanty_mobility/Components/Components.dart';
import 'package:epanty_mobility/localisation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GeneralInformation extends StatefulWidget {
  const GeneralInformation({Key? key}) : super(key: key);

  @override
  _GeneralInformationState createState() => _GeneralInformationState();
}

class _GeneralInformationState extends State<GeneralInformation> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName);
  TextEditingController emailController = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.email);
  TextEditingController passwordVerifyController = TextEditingController();
  bool passwordNotVisible = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).informationGeneral,
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
        //reverse: true,
        child: Container(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: 200,
                        child: Container(
                            padding: EdgeInsets.all(4.0),
                            child:
                                Image.asset("assets/images/general_Info.png")),
                      ),
                    ),
                    SizedBox(height: 45),
                    Text(
                      AppLocalizations.of(context).change,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context).modify,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black38,
                      ),
                    ),
                    SizedBox(height: 25),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).userName,
                            style: TextStyle(
                                fontFamily: "Sofia",
                                color: Colors.black87,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w700),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              } else if (value.contains( "!") ||
                                  value.contains("@") ||
                                  value.contains("#") ||
                                  value.contains("%") ||
                                  value.contains("%") ||
                                  value.contains("^") ||
                                  value.contains("&") ||
                                  value.contains("*") ||
                                  value.contains("(") ||
                                  value.contains(")") ||
                                  value.contains("\$")) {
                                return AppLocalizations.of(context).retirer;
                              } else if (value.length > 30) {
                                return AppLocalizations.of(context).trop_long;
                              } else {
                                return null;
                              }
                            },
                            controller: userNameController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                //hintText: auth.currentUser!.displayName ?? "Not Yet Defined",
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Text(
                            AppLocalizations.of(context).email,
                            style: TextStyle(
                                fontFamily: "Sofia",
                                color: Colors.black87,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w700),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              } else if (!value.contains("@")) {
                                return AppLocalizations.of(context).email_invalid;
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(color: Colors.black),
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                //hintText: auth.currentUser!.email ?? "Not Yet Defined",
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    ButtonWidget(
                      text: AppLocalizations.of(context).save,
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          print("Validation Failed");
                        } else {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            if (userNameController.text !=
                                FirebaseAuth
                                    .instance.currentUser!.displayName) {
                              await auth.currentUser!
                                  .updateDisplayName(userNameController.text);
                              showSnackBar(context, AppLocalizations.of(context).succes);
                            }
                            if (emailController.text !=
                                FirebaseAuth.instance.currentUser!.email) {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      title: Text(AppLocalizations.of(context).confirmPassword),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Form(
                                            key: null,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return AppLocalizations.of(context).requis;
                                                } else if (value.length < 8) {
                                                  return AppLocalizations.of(context).short_pass;
                                                } else {
                                                  return null;
                                                }
                                              },
                                              controller:
                                                  passwordVerifyController,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              obscureText: passwordNotVisible,
                                              decoration:
                                                  signInPasswordInputDecoration(
                                                hintText: AppLocalizations.of(context).password,
                                                icon: (passwordNotVisible
                                                    ? IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            passwordNotVisible =
                                                                false;
                                                          });
                                                        },
                                                        icon: Icon(Icons
                                                            .visibility_outlined))
                                                    : IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            passwordNotVisible =
                                                                true;
                                                          });
                                                        },
                                                        icon: Icon(Icons
                                                            .visibility_off_outlined))),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              User user = FirebaseAuth
                                                  .instance.currentUser!;
                                              final cred =
                                                  EmailAuthProvider.credential(
                                                      email: user.email!,
                                                      password:
                                                          passwordVerifyController
                                                              .text);
                                              await user
                                                  .reauthenticateWithCredential(
                                                      cred);
                                              setState(() {
                                                print("done");
                                              });
                                              Navigator.of(context).pop();
                                            } catch (e) {
                                              showSnackBar(
                                                  context, e.toString());
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Text(
                                              AppLocalizations.of(context).confirm),
                                        ),
                                      ],
                                    );
                                  });
                              await auth.currentUser!.verifyBeforeUpdateEmail(
                                  emailController.text);
                              showSnackBar(context, AppLocalizations.of(context).succes);
                            }
                            setState(() {
                              isLoading = false;
                            });
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            showSnackBar(context, e.toString());
                          }
                        }
                      },
                      isLoading: isLoading,
                      outlined: true,
                    )
                  ])),
        ),
      ),
    );
  }
}
