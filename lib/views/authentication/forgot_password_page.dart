import 'package:epanty_mobility/Components/Components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../app_styles.dart';
import '../../size_configs.dart';
import '../../validators.dart';
import '../../common/loading.dart';
import '../pages.dart';
import '../../widgets/widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _forgotPassKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void onSumbit() {
    _forgotPassKey.currentState!.validate();
  }

  FocusNode focusNode1 = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode1.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.blockSizeV!;
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 80,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CircleAvatar(
                  backgroundColor: kSecondaryColor.withOpacity(0.1),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: kSecondaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
            body: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 3,
                        ),
                        Center(
                          child: Text(
                            "Forgot your password?",
                            style: kTitle2,
                          ),
                        ),
                        SizedBox(
                          height: height * 2,
                        ),
                        Container(
                          child: Image.asset(
                            'assets/images/auth/forgot_password_illustration.PNG',
                          ),
                        ),
                        SizedBox(
                          height: height * 2,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Form(
                              key: _forgotPassKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Enter your registered email to receive password reset instruction",
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  MyTextFormField(
                                    hint: 'Email',
                                    icon: Icons.email_outlined,
                                    fillColor: kScaffoldBackground,
                                    inputType: TextInputType.emailAddress,
                                    inputAction: TextInputAction.done,
                                    focusNode: focusNode1,
                                    validator: emailValidator,
                                    controller: emailController,
                                  ),
                                  MyTextButton(
                                    buttonName: 'Send reset link',
                                    onPressed: () {
                                      if (_forgotPassKey.currentState!
                                              .validate() ==
                                          true) {
                                        setState(() => loading = true);
                                        FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
                                        showSnackBar(context,"Vous avez été envoyé un mail de réinitialisation de mot de passe.");

                                      }
                                    },
                                    bgColor: kPrimaryColor,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Remember password?',
                                    style: kBodyText3,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    splashColor:
                                        kSecondaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Back to login",
                                        style: kBodyText3.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
