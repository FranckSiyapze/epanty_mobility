import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epanty_mobility/services/firebase_service.dart';
import 'package:epanty_mobility/views/Home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../app_styles.dart';
import '../../services/authentication.dart';
import '../../size_configs.dart';
import '../../validators.dart';
import '../pages.dart';
import '../../widgets/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// its best practice to do relative imports

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.goToSignUp}) : super(key: key);

  final Function goToSignUp;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthenticationService _auth = AuthenticationService();
  final _loginKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  String error = '';
  Map<String, dynamic>? _userData;
  String welcome = "Facebook";
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onSubmit() {
    _loginKey.currentState!.validate();
  }

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

  Future signInWithFacebook1() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
          return FirebaseAuth.instance.signInWithCredential(facebookCredential);
          //return Resource(status: Status.Success);
        case LoginStatus.cancelled:
          //return Resource(status: Status.Cancelled);
          return "Cancelled";
        case LoginStatus.failed:
          //return Resource(status: Status.Error);
          return "Failed";
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    }
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

  List<FocusNode> _loginFocusNodes = [
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    super.initState();
    _loginFocusNodes.forEach((element) {
      element.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = SizeConfig.blockSizeV!;
    return Stack(
      children: [
        Positioned(
          bottom: height * 2,
          child: Container(
            child: Image.asset('assets/images/auth/logo_bg.PNG'),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Welcome to\n EPANTY MOBILITY',
                              style: kTitle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
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
                                              'Continue with Google',
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
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
                                              'Continue with Facebook',
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
                                  /*LargeIconButton(
                                    buttonName: 'Continue with Facebook',
                                    iconImage:
                                        'assets/images/auth/facebook_icon.png',
                                  )*/
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 14,
                                    ),
                                    Text(
                                      'Login with email',
                                      style: kBodyText3,
                                    ),
                                    Divider(
                                      height: 30,
                                      color: kPrimaryColor.withOpacity(0.5),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Form(
                                        key: _loginKey,
                                        child: Column(
                                          children: [
                                            MyTextFormField(
                                              controller: emailController,
                                              hint: 'Email',
                                              icon: Icons.email_outlined,
                                              fillColor: kScaffoldBackground,
                                              inputType:
                                                  TextInputType.emailAddress,
                                              inputAction: TextInputAction.next,
                                              focusNode: _loginFocusNodes[0],
                                              validator: emailValidator,
                                            ),
                                            MyPasswordField(
                                              controller: passwordController,
                                              fillColor: kScaffoldBackground,
                                              focusNode: _loginFocusNodes[1],
                                              validator: passwordValidator,
                                            ),
                                            MyTextButton(
                                              buttonName: 'Login',
                                              onPressed: () async {
                                                if (_loginKey.currentState!
                                                        .validate() ==
                                                    true) {
                                                  //setState(() => loading = true);
                                                  var password =
                                                      passwordController
                                                          .value.text;
                                                  var email = emailController
                                                      .value.text;

                                                  var result = await _auth
                                                      .signInWithEmailAndPassword(
                                                          email, password);
                                                  /*Navigator.of(context).pushReplacement(
                                                   MaterialPageRoute(builder: (_) => HomeScreen()),
                                                 );*/

                                                  setState(() {});
                                                }
                                              },
                                              bgColor: kPrimaryColor,
                                            ),
                                            SizedBox(height: 10.0),
                                            Text(
                                              error,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15.0),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPasswordPage()));
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: kBodyText3.copyWith(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Don't have an account? "),
                                        InkWell(
                                          onTap: () {
                                            widget.goToSignUp();
                                          },
                                          splashColor:
                                              kSecondaryColor.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Sign up",
                                              style: kBodyText3.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
