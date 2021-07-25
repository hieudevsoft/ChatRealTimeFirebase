import 'dart:ffi';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bear_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bear_chat/utils/ValidationUser.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late FirebaseAuth _auth;
  String _email = "";
  late String _password;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController passwordController = new TextEditingController();
  bool _isRegisterFailure = false;

  bool isError = false;
  String? textError = "";
  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[900],
        body: ModalProgressHUD(
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(),
          inAsyncCall: _isRegisterFailure,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: registerForm()),
        ),
      ),
    );
  }

  void onSubmit() async {
    if (_registerFormKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      _registerFormKey.currentState!.save();
      print("$_email , $_password");
      _isRegisterFailure = true;
      try {
        final user = await _auth
            .createUserWithEmailAndPassword(email: _email, password: _password)
            .timeout(const Duration(seconds: 6))
            .whenComplete(() {
          print("complete");
          setState(() {
            _isRegisterFailure = false;
          });
        });
        if (user != null) {
          print("Register Successfully");
          Navigator.pushNamed(context, "/chat");
        }
      } on FirebaseAuthException catch (e) {
        print("Exception: ${e.message}");
        setState(() {
          isError = true;
          textError = e.message;
          _isRegisterFailure = false;
        });
      } on Exception catch (e) {
        setState(() {
          isError = true;
          textError = e.toString();
          _isRegisterFailure = false;
        });
      }
    }
  }

  Widget registerForm() {
    _registerFormKey.currentState?.validate();
    return SingleChildScrollView(
      clipBehavior: Clip.antiAlias,
      child: Form(
        key: _registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'image',
              child: Container(
                height: 180.0,
                child: Image.asset('images/logo_dark_chat.png'),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              autofocus: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (input) {
                return input.isValidEmail() ? null : "Email invalid";
              },
              onChanged: (value) {
                print(value);
                _email = value;
              },
              onSaved: (value) {
                print("Onsave $value");
                _email = value!;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: inputDecorationRegister.copyWith(
                  prefixIcon: Icon(
                    Icons.email_rounded,
                  ),
                  hintText: "Enter your email"),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextFormField(
              autofocus: false,
              obscureText: true,
              controller: passwordController,
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (input) {
                return input.isValidPass()
                    ? null
                    : "Password at least 7 characters";
              },
              onChanged: (value) {
                print(value);
                _password = value;
              },
              onSaved: (value) {
                print("Onsave $value");
                _password = value!;
              },
              keyboardType: TextInputType.text,
              decoration: inputDecorationRegister.copyWith(
                  prefixIcon: Icon(Icons.vpn_key_rounded),
                  hintText: "Enter your password"),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextFormField(
              autofocus: false,
              obscureText: true,
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (input) {
                return input.isValidConfirmPass(passwordController.text)
                    ? null
                    : "Confirm password incorrect";
              },
              onChanged: (value) {
                print(value);
                _email = value;
              },
              keyboardType: TextInputType.text,
              decoration: inputDecorationRegister.copyWith(
                  prefixIcon: Icon(Icons.vpn_key_rounded),
                  hintText: "Enter your confirm password"),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              textError!,
              style: TextStyle(
                  color: isError ? Colors.red : Colors.white, fontSize: 12),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                child: WavyAnimatedTextKit(
                  text: ["Register"],
                  textStyle: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                style: kElevatedButtonStyle,
                onPressed: () {
                  onSubmit();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
