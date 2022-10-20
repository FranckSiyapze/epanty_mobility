import 'package:animations/animations.dart';
import 'package:epanty_mobility/views/authentication/login_page.dart';
import 'package:epanty_mobility/views/authentication/sign_up_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  ValueNotifier<bool> showSignInPage = ValueNotifier<bool>(true);
  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ValueListenableBuilder(
        valueListenable: showSignInPage,
        builder: (BuildContext context, bool value, Widget? child) {
          return SizedBox.expand(
            child: PageTransitionSwitcher(
              reverse: !value,
              duration: const Duration(milliseconds: 800),
              transitionBuilder: (child, animation, secondaryAnimation){
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.vertical,
                  fillColor: Colors.transparent,
                  child: child,
                );
              },
              child: value
                  ? LoginPage(
                  goToSignUp: (){
                showSignInPage.value = false;
                _controller.forward();
              })
                  : SignUpPage(goToSignIn: (){
                showSignInPage.value = true;
                _controller.reverse();
              }),
            ),
          );
        },
      ),
    );
  }
}
