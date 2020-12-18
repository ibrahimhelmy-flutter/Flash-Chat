


import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/widgets.dart';
import 'package:loin_with_auth/components/rounded_bottun.dart';
import 'package:loin_with_auth/screens/login_screen.dart';
import 'package:loin_with_auth/screens/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "/welcom";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();


    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);

    controller.forward();
    controller.addStatusListener((status) {
      if(status==AnimationStatus.completed){
        controller.reverse();
      }else if(status==AnimationStatus.dismissed){
        controller.forward();
      }

    });
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                      Container(
                        child: Hero(
                            tag: "logo", child: Image.asset('images/logo.png')),
                        height: controller.value * 100,
                      ),
                      // SizedBox(
                      //   width: 250,
                      //   child: TyperAnimatedTextKit(
                      //     text: ["Flash Chat"],
                      //     onTap: () {},
                      //     textAlign: TextAlign.start,
                      //     textStyle: TextStyle(
                      //       fontSize: 45.0,
                      //       color: Colors.black45,
                      //       fontWeight: FontWeight.w900,
                      //     ),
                      //   ),
                      // ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: SizedBox(
                    width: 250,
                    child: TyperAnimatedTextKit(
                      text: ["Flash Chat"],
                      onTap: () {},
                      textAlign: TextAlign.start,
                      textStyle: TextStyle(
                        fontSize: 45.0,
                        color: Colors.black45,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 48.0),
                RoundedButton("Log In", Colors.green,(){
                  Navigator.pushNamed(context, LoginScreen.id);
                }),
                RoundedButton("Register", Colors.blueAccent,(){
                  Navigator.pushNamed(context, RegistrationScreen.id);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}


