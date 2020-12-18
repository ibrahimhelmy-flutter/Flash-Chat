import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loin_with_auth/components/rounded_bottun.dart';
import 'package:loin_with_auth/constants.dart';
import 'package:loin_with_auth/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loin_with_auth/screens/login_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "/regs";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  String email;
  String password;

  TextEditingController textControllerEmail = TextEditingController();
  TextEditingController textControllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(

                child: Hero(tag: "logo", child:Container(child: Image.asset('images/logo.png'), height: 200.0,) ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  controller: textControllerEmail,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: KTextInputFieldDecoration.copyWith(
                      hintText: "Enter your Email .")),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  controller: textControllerPassword,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: KTextInputFieldDecoration.copyWith(
                      hintText: "Enter your Password .")),
              SizedBox(height: 24.0),
              RoundedButton("Register", Colors.blueAccent, () async {
                setState(() {
                  showSpinner = true;
                });
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);

                  if (newUser != null) {
                    Navigator.pushNamed(context, LoginScreen.id);
                    textControllerEmail.clear();
                    textControllerPassword.clear();
                  }
                } catch (e) {
                  print(e);
                }
                setState(() {
                  showSpinner = false;
                });
              })
            ],
          ),
        ),
      ),
    );
  }
}
