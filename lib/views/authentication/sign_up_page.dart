import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epanty_mobility/Components/Components.dart';
import 'package:epanty_mobility/views/Home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app_styles.dart';
import '../../services/authentication.dart';
import '../../size_configs.dart';
import '../../validators.dart';
import '../pages.dart';
import '../../widgets/widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.goToSignIn}) : super(key: key);
  final Function goToSignIn;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthenticationService _auth = AuthenticationService();
  final _signUpKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  String error = '';
  bool checkboxValue = false;
  Map<String, dynamic>? _userData;
  String welcome = "Facebook";

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithFacebook() async {

    final LoginResult result = await FacebookAuth.instance.login(permissions:['email']);

    if (result.status == LoginStatus.success) {

      final userData = await FacebookAuth.instance.getUserData();

      _userData = userData;
      print("************");
      print(userData);
      print("************");
    } else {
      print(result.message);
      print("ERRORRRRRRRRR");
      print(result);

    }

    setState(() {
      welcome = _userData?['email'];
    });
    print("acess tokennnn");
    print(result.accessToken!.token);
    print("acess tokennnn");
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);
    print(facebookAuthCredential);
    UserCredential resultUser = await auth.signInWithCredential(facebookAuthCredential);
    print("**************************");
    print("Create Trip");
    if(resultUser.user!.uid.isNotEmpty){
      await FirebaseFirestore.instance.collection("Payment").doc(resultUser.user!.uid).set({
        "user": resultUser.user!.uid,
        "trips": 10,
      });
    }
    print("End Create trip facebook connexion");
    print("**************************");
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;

      if (result != null) {
        print("*******************");
        print("Create Trip");
        if(result.user!.uid.isNotEmpty){
          await FirebaseFirestore.instance.collection("Payment").doc(result.user!.uid).set({
            "user": result.user!.uid,
            "trips": 10,
          });
        }
        print("End Create trip google connexion");
        print("*******************");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
      // if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
    }
  }


  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onSubmit() {
    _signUpKey.currentState!.validate();
  }

  Color checkboxColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.white;
    }
    return Colors.black38;
  }

  List<FocusNode> _signUpFocusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    super.initState();
    _signUpFocusNodes.forEach((element) {
      element.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = SizeConfig.blockSizeV!;
    return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        child: Image.asset(
                            'assets/images/auth/signup_illustration.png'),
                      ),
                      SizedBox(
                        height: height * 2,
                      ),
                      Text(
                        'Create Your Account',
                        style: kTitle2,
                      ),
                      SizedBox(
                        height: height * 2,
                      ),
                      Form(
                        key: _signUpKey,
                        child: Column(
                          children: [
                            MyTextFormField(
                              controller: nameController,
                              fillColor: Colors.white,
                              hint: 'Name',
                              icon: Icons.person,
                              inputAction: TextInputAction.next,
                              inputType: TextInputType.name,
                              focusNode: _signUpFocusNodes[0],
                              validator: nameValidator,
                            ),
                            MyTextFormField(
                              hint: 'Email',
                              icon: Icons.email_outlined,
                              fillColor: Colors.white,
                              inputType: TextInputType.emailAddress,
                              inputAction: TextInputAction.next,
                              focusNode: _signUpFocusNodes[1],
                              validator: emailValidator,
                              controller: emailController,
                            ),
                            MyPasswordField(
                              controller: passwordController,
                              fillColor: Colors.white,
                              focusNode: _signUpFocusNodes[2],
                              validator: passwordValidator,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 9),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.resolveWith(
                                        checkboxColor),
                                    value: checkboxValue,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        checkboxValue = value!;
                                      });
                                    },
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "J'accepte les ",
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white),
                                          ),
                                          GestureDetector(
                                            child: Text(
                                              "Contrats d'utilisation",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onTap: () async {
                                              if (await canLaunch(
                                                  'https://www.google.com')) {
                                                await launch(
                                                  'https://www.google.com',
                                                  forceWebView: false,
                                                  enableJavaScript: true,
                                                );
                                              } else {
                                                throw 'Could not launch https://admin.boncopbadcop.com/user-conditions';
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Et les ",
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white),
                                          ),
                                          GestureDetector(
                                            child: Text(
                                              "termes d'utilisation",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onTap: () async {
                                              if (await canLaunch(
                                                  'https://www.google.com')) {
                                                await launch(
                                                  'https://www.google.com',
                                                  forceWebView: false,
                                                  enableJavaScript: true,
                                                );
                                              } else {
                                                throw 'Could not launch https://admin.boncopbadcop.com/user-conditions';
                                              }
                                            },
                                          ),
                                          Text(
                                            "De Epanty mobility",
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            MyCheckBox(
                              text: 'Email me about special pricing and more',
                            ),
                            MyTextButton(
                              buttonName: 'Create Account',
                              onPressed: () async {
                                if (_signUpKey.currentState!.validate() ==
                                    true) {
                                  setState(() => loading = true);
                                  if (checkboxValue) {
                                    _auth.registerWithEmailAndPassword(nameController.value.text,emailController.value.text,passwordController.value.text);
                                    /*FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.value.text, password: passwordController.value.text).then((value) async {
                                      await FirebaseFirestore.instance.collection("Payment").doc(FirebaseAuth.instance.currentUser!.uid).set({
                                        "user": FirebaseAuth.instance.currentUser!.uid,
                                        "trips": 10,
                                      });
                                    });

                                    if (FirebaseAuth.instance.currentUser == null ) {
                                      setState(() {
                                        loading = false;
                                        error = 'Please supply a valid email';
                                      });
                                    }*/
                                  }
                                  else{
                                    showSnackBar(context,"Vous devez accepté les termes d'utilisation et le contrat de confidentialité");
                                  }

                                }
                              },
                              bgColor: kPrimaryColor,
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 15.0),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                height: 3,
                                color: kSecondaryColor.withOpacity(0.4),
                              ),
                            ),
                            Text(
                              'Or sign in with',
                              style: kBodyText3,
                            ),
                            Expanded(
                              child: Divider(
                                height: 3,
                                color: kSecondaryColor.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                signup(context);
                              },
                              child: Container(
                                height: 30,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        // height: 25,
                                        child: Image.asset(
                                            'assets/images/auth/google_icon.png'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Google',
                                        style: kBodyText2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  signInWithFacebook();
                                },
                                child: Container(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          // height: 25,
                                          child: Image.asset(
                                              'assets/images/auth/facebook_icon.png'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Facebook',
                                          style: kBodyText2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),),
                        ],
                      ),
                      SizedBox(
                        height: height * 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: kBodyText3,
                          ),
                          InkWell(
                            onTap: () {
                              widget.goToSignIn();
                            },
                            splashColor: kSecondaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Login",
                                style: kBodyText3.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
