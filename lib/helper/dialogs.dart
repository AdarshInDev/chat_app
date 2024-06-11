import 'package:flutter/material.dart';

// This file is made to help us making some components which require coder interaction like snackbar needs a message in it to show

class Dialogs {
  static void showSnackBar(BuildContext context, String message) {
    // var mq = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(label: 'CANCEL', onPressed: () {}),
      ),
    );
  }

  /// this is for the cicular indicator which we will show after we click the login button on our app ....
  static void showProgressBar(BuildContext context) {
    // var mq = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (_) {
          return const Center(child: CircularProgressIndicator());
        });
  }
}
