import 'dart:developer';
import 'dart:io';

import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleBtnclk() {
    Dialogs.showProgressBar(context);
    signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        if ((await Apis.userExists())) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Homepage()));
        } else {
          Apis.createUser().then((value) => null);

          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Homepage()));
        }

        // log('\nUser: ${user.user}');
        // log('\nUserAdditonalInfo : ${user.additionalUserInfo}');
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      // will check is internet on by searching this page in the background
      await InternetAddress.lookup('www.google.com');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await Apis.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n _SignInWithGoogle: $e');

      Dialogs.showSnackBar(
          // ignore: use_build_context_synchronously
          context,
          'Something went wrong \nCheck your Internet!!');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 203, 156, 205),

        // Appbar
        appBar: AppBar(
          title: const Text('Welcome To The ChatApp '),
        ),

        // floating actionbutton

        //  main body of the home page
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1000),
              top: mq.height * .07,
              width: mq.width * .7,
              right: _isAnimate ? mq.width * .15 : -mq.width * .7,
              child: Image.asset(
                'lib/assets/images/img1.png',
                height: 320,
              ),
            ),
            Positioned(
              top: mq.height * .57,
              left: mq.width * .16,
              height: mq.height * .08,
              child: AnimatedOpacity(
                opacity: _isAnimate ? 1 : 0,
                duration: const Duration(milliseconds: 1000),
                child: const Text(
                  'Easy On Boarding',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1300),
              top: mq.height * .74,
              width: mq.width * .9,
              right: _isAnimate ? mq.width * .05 : mq.width * 1,
              height: mq.height * .07,
              child: Center(
                child: ElevatedButton.icon(
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Color.fromARGB(255, 76, 107, 77))),
                  onPressed: () {
                    _handleGoogleBtnclk();
                  },
                  icon: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      'lib/assets/images/emails.png',
                    ),
                  ),
                  label: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 20),
                      children: [
                        TextSpan(text: 'Login With '),
                        TextSpan(
                          text: ' E-mail',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1300),
              top: mq.height * .64,
              width: mq.width * .9,
              left: _isAnimate ? mq.width * .055 : mq.width * 1,
              height: mq.height * .07,
              child: Center(
                child: ElevatedButton.icon(
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Color.fromARGB(255, 218, 53, 146))),
                  onPressed: () {
                    _handleGoogleBtnclk();
                  },
                  icon: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset('lib/assets/images/google.png'),
                  ),
                  label: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 20),
                      children: [
                        TextSpan(text: 'Login With '),
                        TextSpan(
                          text: 'Google',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
