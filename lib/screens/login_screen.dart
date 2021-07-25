import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bear_chat/animated_sequences.dart';
import 'package:bear_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late FirebaseAuth _auth;
  late AnimationController animationController;
  String _email = "";
  String _password = "";
  bool _isLoginFailure = false;
  bool isError = false;
  String? textError = "";
  @override
  void initState() {
    _auth = FirebaseAuth.instance;

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animationController.addListener(() {
      setState(() {});
    });
    animationController.addStatusListener((status) {
      print(status);
    });
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    print("$_email , $_password");
    setState(() {
      _isLoginFailure = true;
    });
    try {
      final user = await _auth
          .signInWithEmailAndPassword(email: _email, password: _password)
          .timeout(const Duration(seconds: 6))
          .whenComplete(() {
        print("complete");
        setState(() {
          _isLoginFailure = false;
        });
      });
      if (user != null) {
        print("Login Successfully");
        setState(() {
          textError = "";
          isError = false;
        });
        Navigator.pushNamed(context, "/chat");
      }
    } on FirebaseAuthException catch (e) {
      print("Exception: ${e.message}");
      setState(() {
        isError = true;
        textError = e.message;
        _isLoginFailure = false;
      });
    } on Exception catch (e) {
      setState(() {
        isError = true;
        textError = e.toString();
        _isLoginFailure = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
        inAsyncCall: _isLoginFailure,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: "image",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo_dark_chat.png'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText("Login",
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                            fontFamily: "Avenir",
                            color: Colors.white,
                            fontSize: 40)),
                  ],
                  displayFullTextOnTap: false,
                  repeatForever: true,
                ),
                SizedBox(
                  height: 48.0,
                ),
                SlideTransition(
                  position:
                      Tween<Offset>(begin: Offset(0, -1), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: animationController,
                              curve: Curves.decelerate)),
                  child: TextField(
                      onChanged: (value) {
                        _email = value;
                      },
                      decoration: inputDecorationRegister.copyWith(
                          hintText: "Enter your Email")),
                ),
                SizedBox(
                  height: 8.0,
                ),
                SlideTransition(
                  position: Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: animationController,
                          curve: Curves.decelerate)),
                  child: TextField(
                      obscureText: true,
                      onChanged: (value) {
                        _password = value;
                      },
                      decoration: inputDecorationRegister.copyWith(
                          hintText: "Enter your pasword")),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  textError!,
                  style: TextStyle(
                      color: isError ? Colors.red : Colors.white, fontSize: 12),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: AnimatedBuilder(
                        animation: animationController,
                        builder: (context, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                                    begin: Offset(-1, 0), end: Offset.zero)
                                .animate(CurvedAnimation(
                                    parent: animationController,
                                    curve: Curves.decelerate)),
                            child: FadeTransition(
                              opacity: Tween<double>(begin: 0, end: 1).animate(
                                  CurvedAnimation(
                                      parent: animationController,
                                      curve: Curves.easeIn)),
                              child: ElevatedButton(
                                  onPressed: () {
                                    _onSubmit();
                                  },
                                  style: kElevatedButtonStyle,
                                  child: Text("Log In",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800))),
                            ),
                          );
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
