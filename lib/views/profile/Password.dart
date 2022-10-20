import 'package:epanty_mobility/Components/Components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../localisation.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  bool isLoading = false;
  bool oldPasswordVisible = true;
  bool newPasswordVisible = true;
  bool confirmNewPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).change_pass,
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
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height / 7,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Opacity(
                  opacity: 0.9,
                  child: Image(
                    image: AssetImage("assets/images/password_lock_icon.png"),
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Text(
                AppLocalizations.of(context).remplir,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
              Text(
                AppLocalizations.of(context).remplir_form,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.black38,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context).requis;
                          } else if (value.length < 8) {
                            return AppLocalizations.of(context).short_pass;
                          } else {
                            return null;
                          }
                        },
                        controller: oldPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        obscureText: oldPasswordVisible,
                        decoration: InputDecoration(
                            suffixIcon: (oldPasswordVisible
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        oldPasswordVisible = false;
                                      });
                                    },
                                    icon: Icon(Icons.visibility_outlined))
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        oldPasswordVisible = true;
                                      });
                                    },
                                    icon: Icon(Icons.visibility_off_outlined))),
                            contentPadding: EdgeInsets.only(bottom: 3),
                            labelText:AppLocalizations.of(context).oldPassword,
                            //hintText:DemoLocalizations.of(context).oldPassword,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context).requis;
                          } else if (value.length < 8) {
                            return AppLocalizations.of(context).short_pass;
                          } else {
                            return null;
                          }
                        },
                        controller: newPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        obscureText: newPasswordVisible,
                        decoration: InputDecoration(
                            suffixIcon: (newPasswordVisible
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        newPasswordVisible = false;
                                      });
                                    },
                                    icon: Icon(Icons.visibility_outlined))
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        newPasswordVisible = true;
                                      });
                                    },
                                    icon: Icon(Icons.visibility_off_outlined))),
                            contentPadding: EdgeInsets.only(bottom: 3),
                            labelText:AppLocalizations.of(context).newPassword,
                            //hintText:DemoLocalizations.of(context).oldPassword,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context).requis;
                          } else if (value.length < 8) {
                            return AppLocalizations.of(context).short_pass;
                          } else if (confirmNewPasswordController.text !=
                              newPasswordController.text) {
                            confirmNewPasswordController.clear();
                            newPasswordController.clear();
                            return AppLocalizations.of(context).pass_not_match;
                          } else {
                            return null;
                          }
                        },
                        controller: confirmNewPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        obscureText: confirmNewPasswordVisible,
                        decoration: InputDecoration(
                            suffixIcon: (confirmNewPasswordVisible
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        confirmNewPasswordVisible = false;
                                      });
                                    },
                                    icon: Icon(Icons.visibility_outlined))
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        confirmNewPasswordVisible = true;
                                      });
                                    },
                                    icon: Icon(Icons.visibility_off_outlined))),
                            contentPadding: EdgeInsets.only(bottom: 3),
                            labelText: AppLocalizations.of(context).confirmNewPassword,
                            //hintText:DemoLocalizations.of(context).oldPassword,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: ButtonWidget(
                  text: AppLocalizations.of(context).change_pass,
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (!_formKey.currentState!.validate()) {
                      print("Validation Failed");
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      try {
                        User user = FirebaseAuth.instance.currentUser!;
                        final cred = EmailAuthProvider.credential(
                            email: user.email!,
                            password: oldPasswordController.text);
                        await user.reauthenticateWithCredential(cred);

                        user.updatePassword(newPasswordController.text);
                        showSnackBar(
                            context,
                            AppLocalizations.of(context).succes);
                        setState(() {
                          isLoading = false;
                        });
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        if (e.code == 'wrong-password') {
                          showSnackBar(context,
                              AppLocalizations.of(context).echec);
                          oldPasswordController.clear();
                          newPasswordController.clear();
                          confirmNewPasswordController.clear();
                        } else {
                          print(e.code);
                        }
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        print(e);
                      }
                    }
                  },
                  outlined: true,
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
