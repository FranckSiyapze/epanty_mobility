import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({Key? key, required this.initialValue, required this.values, required this.callbackFunction}) : super(key: key);

  final String initialValue;
  final List<String> values;
  final void Function(String) callbackFunction;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState(initialValue:initialValue, values:values, callbackFunction: callbackFunction);
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String initialValue;
  final List<String> values;
  final void Function(String) callbackFunction;
  _DropDownWidgetState({required this.initialValue, required this.values, required this.callbackFunction});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(

      value: initialValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          initialValue = newValue!;
          callbackFunction(newValue);
        });
      },
      items: values
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}


class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool outlined;
  final bool isLoading;

  ButtonWidget(
      {required this.text,
      required this.onPressed,
      required this.outlined,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    bool _outlined = outlined;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50.0,
        width: MediaQuery.of(context).size.width - 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _outlined ? Colors.transparent : Color.fromRGBO(90, 144, 53, 1),
          border: Border.all(
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 15.0,
        ),
        child: Center(
          child: !isLoading
              ? Text(
                  text,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: _outlined
                        ? Color.fromRGBO(23, 70, 200, 1)
                        : Colors.white,
                  ),
                )
              : CircularProgressIndicator(
                  backgroundColor: _outlined ? Color.fromRGBO(90, 144, 53, 1) : Colors.white,
                ),
        ),
      ),
    );
  }
}

class SignUpBar extends StatelessWidget {
  const SignUpBar({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.isLoading,
  }) : super(key: key);

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          Expanded(
            child: Center(
              child: _signUpLoadingIndicator(isLoading: isLoading),
            ),
          ),
          _RoundContinueButton(onPressed: onPressed),
        ],
      ),
    );
  }
}

class SignInBar extends StatelessWidget {
  const SignInBar({
    Key? key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
  }) : super(key: key);

  final String label;
  final bool isLoading;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      text: "Connexion",
      onPressed: onPressed,
      outlined: false,
      isLoading: isLoading,
    );
    /*return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Palette.darkBlue,
            fontSize: 24,
          ),
        ),
        Expanded(
          child: Center(
            child: _signInLoadingIndicator(isLoading: isLoading),
          ),
        ),
        _RoundContinueButton(
          onPressed: onPressed,
        )
      ],
    );*/
  }
}

class ResetBar extends StatelessWidget {
  const ResetBar({
    Key? key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
  }) : super(key: key);

  final String label;
  final bool isLoading;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      text: "Réinitialiser",
      onPressed: onPressed,
      outlined: false,
      isLoading: isLoading,
    );
    /*return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Palette.darkBlue,
            fontSize: 24,
          ),
        ),
        Expanded(
          child: Center(
            child: _signInLoadingIndicator(isLoading: isLoading),
          ),
        ),
        _RoundContinueButton(
          onPressed: onPressed,
        )
      ],
    );*/
  }
}

class _signInLoadingIndicator extends StatelessWidget {
  const _signInLoadingIndicator({
    Key? key,
    required this.isLoading,
  }) : super(key: key);

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 100),
      child: Visibility(
        visible: isLoading,
        child: const LinearProgressIndicator(
          backgroundColor: Color.fromRGBO(90, 144, 53, 1),
          // color: Palette.lightBlue,
        ),
      ),
    );
  }
}

class _signUpLoadingIndicator extends StatelessWidget {
  const _signUpLoadingIndicator({
    Key? key,
    required this.isLoading,
  }) : super(key: key);

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 100),
      child: Visibility(
        visible: isLoading,
        child: const LinearProgressIndicator(
          backgroundColor: Color.fromRGBO(90, 144, 53, 1),
          // color: Palette.darkOrange,
        ),
      ),
    );
  }
}

class _RoundContinueButton extends StatelessWidget {
  const _RoundContinueButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 0.0,
      fillColor: Color.fromRGBO(90, 144, 53, 1),
      splashColor: Color.fromRGBO(90, 144, 53, 1),
      padding: const EdgeInsets.all(22.0),
      shape: const CircleBorder(),
      child: const Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
        size: 24.0,
      ),
    );
  }
}

/*
class SocialsLogin extends StatefulWidget {
  const SocialsLogin({Key? key, required this.changeStateStart, required this.changeStateStop}) : super(key: key);

  final Function changeStateStart;
  final Function changeStateStop;


  @override
  _SocialsLoginState createState() => _SocialsLoginState();
}

class _SocialsLoginState extends State<SocialsLogin> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          child: isLoading? CircularProgressIndicator() : IconButton(
            iconSize: 45,
            icon: Image.asset('assets/images/facebook.png'),
            onPressed: () async {
                widget.changeStateStart();
              try{
                // Trigger the sign-in flow
                final LoginResult loginResult = await FacebookAuth.instance.login();

                // Create a credential from the access token
                final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

                // Once signed in, return the UserCredential
                UserCredential user = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

                if (user != null){
                    widget.changeStateStop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => HomePage()),
                  );
                }
              }
              catch(e){
                  widget.changeStateStop();
                print(" Errrrror : $e");
              }
            },
          ),
        ),
        Container(
          child: isLoading? CircularProgressIndicator() :IconButton(
            iconSize: 45,
            icon: Image.asset('assets/images/google.png'),
            onPressed: () async {
                widget.changeStateStart();
              try{
                // Trigger the authentication flow
                final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                // Obtain the auth details from the request
                final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
                // Create a new credential
                final credential = GoogleAuthProvider.credential(
                  accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken,
                );
                // Once signed in, return the UserCredential
                UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);
                if (user != null){
                    widget.changeStateStop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => HomePage()),
                  );
                }
              }
              catch(e){
                  widget.changeStateStop();
                print(e);
              }
            },
          ),
        ),
        Container(
          child: isLoading? CircularProgressIndicator() : IconButton(
            iconSize: 50,
            icon: Image.asset('assets/images/twitter.png'),
            onPressed: () async {
                widget.changeStateStart();
              try {
                final TwitterLogin twitterLogin = new TwitterLogin(
                  consumerKey: 'lLWsKhXDPVgDjNWgRLmOQRYA9',
                  consumerSecret: 'qzk8wt3BCac2M5QvU2kkidWYEhMDntBdIAFTiF7HWspGCpxBtp',
                );

                // Trigger the sign-in flow
                final TwitterLoginResult loginResult = await twitterLogin.authorize();

                // Get the Logged In session
                final TwitterSession twitterSession = loginResult.session;

                // Create a credential from the access token
                final twitterAuthCredential = TwitterAuthProvider.credential(
                  accessToken: twitterSession.token,
                  secret: twitterSession.secret,
                );

                // Once signed in, return the UserCredential
                UserCredential user = await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
                if (user != null) {
                    widget.changeStateStop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) =>
                        HomePage()),
                  );
                }
              }
              catch(e){
                  widget.changeStateStop();
                print(e);
              }
            },
          ),
        ),
      ],
    );
  }
}

class SocialsSignUp extends StatefulWidget {
  const SocialsSignUp({Key? key}) : super(key: key);

  @override
  _SocialsSignUpState createState() => _SocialsSignUpState();
}

class _SocialsSignUpState extends State<SocialsSignUp> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            try{
              // Trigger the sign-in flow
              final LoginResult loginResult = await FacebookAuth.instance.login();

              // Create a credential from the access token
              final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

              // Once signed in, return the UserCredential
              await FirebaseAuth.instance.currentUser!.linkWithCredential(facebookAuthCredential);

              print("Facebook successfully linked");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Facebook account successfully linked')),
              );
            }
            catch(e){
              print(e);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error : Some error occurred')),
              );
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.blue,
              ),
              shape: BoxShape.circle,
            ),
            child: Container(
              height: 22,
              width: 22,
              child: isLoading? CircularProgressIndicator() : null ,
              decoration: !isLoading ? BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/facebook.png')
                  )
              ) : null ,
            ),
          ),
        ),
        GestureDetector(
          onTap: ()async {
            print('button pressed');
            try{
              // Trigger the authentication flow
              final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
              // Obtain the auth details from the request
              final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
              // Create a new credential
              final googleCredential = GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken,
              );
              // Once signed in, return the UserCredential
              await FirebaseAuth.instance.currentUser!.linkWithCredential(googleCredential);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Google account successfully linked')),
              );
              print("Google Account successfully linked");
            }
            catch(e){
              print(e);
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.blue,
              ),
              shape: BoxShape.circle,
            ),
            child: Container(
              height: 22,
              width: 22,
              child: isLoading? CircularProgressIndicator() : null ,
              decoration: !isLoading ? BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/google.png')
                  )
              ) : null ,
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            try{
              final TwitterLogin twitterLogin = new TwitterLogin(
                consumerKey: 'lLWsKhXDPVgDjNWgRLmOQRYA9',
                consumerSecret: 'qzk8wt3BCac2M5QvU2kkidWYEhMDntBdIAFTiF7HWspGCpxBtp',
              );

              // Trigger the sign-in flow
              final TwitterLoginResult loginResult = await twitterLogin.authorize();

              // Get the Logged In session
              final TwitterSession twitterSession = loginResult.session;

              // Create a credential from the access token
              final twitterAuthCredential = TwitterAuthProvider.credential(
                accessToken: twitterSession.token,
                secret: twitterSession.secret,
              );

              // Once signed in, return the UserCredential
              await FirebaseAuth.instance.currentUser!.linkWithCredential(twitterAuthCredential);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Twitter account successfully linked')),
              );
              print("Twitter Account successfully linked");
            }
            catch(e){
              print(e);
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.blue,
              ),
              shape: BoxShape.circle,
            ),
            child: Container(
              height: 22,
              width: 22,
              child: isLoading? CircularProgressIndicator() : null ,
              decoration: !isLoading ? BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/google.png')
                  )
              ) : null ,
            ),
          ),
        ),
      ],
    );
  }
}
*/
class OrDivider extends StatelessWidget {
  final String text;
  OrDivider({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02),
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              color: Color(0xFFD9D9D9),
              height: 1.5,
              thickness: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
            ),
          ),
          Expanded(
            child: Divider(
              color: Color(0xFFD9D9D9),
              height: 1.5,
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration signUpInputDecoration({required String hintText}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
    hintStyle: const TextStyle(color: Colors.white, fontSize: 18),
    hintText: hintText,
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: Colors.redAccent),
    ),
    errorStyle: const TextStyle(color: Colors.redAccent),
  );
}

InputDecoration signUpPasswordInputDecoration(
    {required String hintText, required Widget icon}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
    hintStyle: const TextStyle(color: Colors.white, fontSize: 18),
    hintText: hintText,
    suffixIcon: icon,
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: Colors.redAccent),
    ),
    errorStyle: const TextStyle(color: Colors.redAccent),
  );
}


void showAlertDialogWithCustomAction(
    {required BuildContext context,
    required String title,
    required String e,
    required String button1,
    required String button2,
    required Function action1,
    required Function action2}) {
  // set up the buttons
  Widget buttonWidget1 = TextButton(
    child: Text(button1),
    onPressed: () {
      action1();
      Navigator.of(context).pop();
    },
  );

  Widget buttonWidget2 = TextButton(
    child: Text(button2),
    onPressed: () {
      action2();
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(e),
    actions: [
      buttonWidget1,
      buttonWidget2,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

InputDecoration signInPasswordInputDecoration(
    {required String hintText, required Widget icon}) {
  return InputDecoration(
    suffixIcon: icon,
    contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
    hintStyle: const TextStyle(fontSize: 18),
    hintText: hintText,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(width: 2, color: Color.fromRGBO(90, 144, 53, 1)),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(90, 144, 53, 1)),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: Colors.redAccent),
    ),
    errorStyle: const TextStyle(color: Colors.redAccent),
  );
}
