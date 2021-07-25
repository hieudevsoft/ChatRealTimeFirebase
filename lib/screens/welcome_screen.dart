import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bear_chat/HeroType.dart';
import 'package:bear_chat/screens/login_screen.dart';
import 'package:bear_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({required this.image});
  final HeroImage image;
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController controller;
  late Animation colorAnimation;
  late Tween scaleAnimation;
  @override
  void initState() {
    _controller = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this)
      ..addListener(() {
        setState(() {});
      });
    scaleAnimation = new Tween(
      begin: 0.0,
      end: 1.0,
    );
    _controller.forward();
    controller = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this)
      ..addListener(() {
        setState(() {});
      });
    colorAnimation = ColorTween(begin: Colors.blueAccent, end: Colors.grey[900])
        .animate(new CurvedAnimation(parent: controller, curve: Curves.easeIn));
    controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorAnimation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Hero(
                    tag: 'image',
                    child: Container(
                      child: widget.image.image,
                      height: 300,
                    ),
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText("Bear chat",
                          curve: Curves.easeInOutSine,
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: "Avenir",
                              fontSize: 45,
                              fontWeight: FontWeight.w800))
                    ],
                    displayFullTextOnTap: true,
                    repeatForever: true,
                  ),
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Transform.scale(
                  scale: scaleAnimation
                      .animate(new CurvedAnimation(
                          parent: _controller, curve: Curves.decelerate))
                      .value,
                  child: ElevatedButton(
                    style: kElevatedButtonStyle,
                    child: Text("Log In",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800)),
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          fullscreenDialog: true,
                          transitionDuration: Duration(seconds: 1),
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return LoginScreen();
                          },
                          transitionsBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Transform.scale(
                  scale: scaleAnimation
                      .animate(new CurvedAnimation(
                          parent: _controller, curve: Curves.decelerate))
                      .value,
                  child: ElevatedButton(
                    style: kElevatedButtonStyle,
                    child: Text("Register",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800)),
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          fullscreenDialog: true,
                          transitionDuration: Duration(seconds: 1),
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return RegistrationScreen();
                          },
                          transitionsBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
