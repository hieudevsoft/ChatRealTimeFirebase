import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bear_chat/HeroType.dart';
import 'package:bear_chat/animated_sequences.dart';
import 'package:bear_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  HeroImage image = HeroImage(image: Image.asset("images/logo_dark_chat.png"));
  late AnimationController controller;
  late AnimationSequences animationSequences;
  @override
  void initState() {
    controller = AnimationController(vsync: this);
    animationSequences = AnimationSequences(controler: controller);
    animationSequences.create();
    animationSequences.addAnimated(
        new ColorTween(begin: Colors.grey, end: Colors.grey[100]),
        const Duration(seconds: 0),
        const Duration(seconds: 2),
        'color',
        Curves.linear);
    animationSequences.addAnimated(
        new ColorTween(begin: Colors.grey[100], end: Colors.white10),
        const Duration(seconds: 2),
        const Duration(seconds: 4),
        'color',
        Curves.easeInOut);
    animationSequences.addAnimated(
        new ColorTween(begin: Colors.white10, end: Colors.white),
        const Duration(seconds: 4),
        const Duration(seconds: 6),
        'color',
        Curves.easeIn);
    animationSequences.addAnimated(
        new Tween<double>(begin: 0, end: 80),
        const Duration(seconds: 0),
        const Duration(seconds: 5),
        'size',
        Curves.easeInExpo);

    animationSequences.buid();
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                width: 30,
              ),
              Hero(
                tag: 'image',
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) => Container(
                    height: animationSequences.getValueTag('size'),
                    width: animationSequences.getValueTag('size'),
                    decoration: BoxDecoration(
                        boxShadow: List.generate(
                            1,
                            (index) => BoxShadow(
                                color: animationSequences.getValueTag('color'),
                                blurRadius: 20,
                                spreadRadius: -10,
                                offset: Offset(10, 10)))),
                    child: image.image,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 32,
                      fontFamily: 'Avenir',
                      letterSpacing: 5,
                      fontWeight: FontWeight.w400),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      RotateAnimatedText('HELLO'),
                      ScaleAnimatedText("I'm"),
                      WavyAnimatedText('BEAR CHAT'),
                    ],
                    onTap: () {
                      print("Tap Event");
                    },
                    pause: const Duration(milliseconds: 100),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: false,
                    totalRepeatCount: 1,
                    onFinished: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          fullscreenDialog: true,
                          transitionDuration: Duration(seconds: 1),
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return WelcomeScreen(image: image);
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
