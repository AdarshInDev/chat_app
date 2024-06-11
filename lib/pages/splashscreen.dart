import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Homepage()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 203, 156, 205),

        //  main body of the home page
        body: Stack(
          children: [
            Positioned(
              // duration: const Duration(milliseconds: 1000),
              top: mq.height * .24,
              width: mq.width * .6,
              right: mq.width * .187,
              child: Image.asset(
                'lib/assets/images/img1.png',
                height: 320,
              ),
            ),
            Positioned(
              // duration: const Duration(milliseconds: 1300),
              top: mq.height * .88,
              width: mq.width * .9,
              left: mq.width * .055,
              height: mq.height * .08,
              child: const Center(
                  child: Text(
                'MADE WITH LOVE BY AADI ❤️',
                style: TextStyle(fontSize: 17),
              )),
            )
          ],
        ));
  }
}
