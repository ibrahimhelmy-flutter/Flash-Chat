
import 'package:flutter/material.dart';
import 'package:loin_with_auth/screens/chat_screen.dart';
import 'package:loin_with_auth/screens/login_screen.dart';
import 'package:loin_with_auth/screens/registration_screen.dart';
import 'package:loin_with_auth/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}




class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

     home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id:(context)=>WelcomeScreen(),
        RegistrationScreen.id:(context)=>RegistrationScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        ChatScreen.id:(context)=>ChatScreen(),
      },

    );
  }
}
