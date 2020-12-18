import 'package:flutter/material.dart';
import 'package:loin_with_auth/components/rounded_bottun.dart';
import 'package:loin_with_auth/constants.dart';
import 'package:loin_with_auth/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        opacity: 0.1,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(

                child: Hero(tag: "logo", child:Container(child: Image.asset('images/logo.png'),height: 200.0,) ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: KTextInputFieldDecoration.copyWith(
                      hintText: "Enter your Email .")),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration: KTextInputFieldDecoration.copyWith(
                      hintText: "Enter your Password.")),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton("Log In", Colors.green, () async {
                setState(() {showSpinner = true;});
                try {
                  var userCred = await _auth.signInWithEmailAndPassword(email: email, password: password);

                  if (userCred != null) {Navigator.pushNamed(context, ChatScreen.id);}



                } catch (e) {
                  print(e);
                }
                setState(() {showSpinner = false;});

              })
            ],
          ),
        ),
      ),
    );
  }
}
