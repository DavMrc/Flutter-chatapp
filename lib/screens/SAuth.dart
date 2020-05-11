import 'package:flutter/material.dart';

import '../widgets/WAuthForm.dart';


class SAuth extends StatefulWidget {
  @override
  _SAuthState createState() => _SAuthState();
}

class _SAuthState extends State<SAuth> {

  void _submitAuthForm({String username, String email, String password, bool isLogin}){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: WAuthForm(this._submitAuthForm),
            ),
          ),
        ),
      ),
    );
  }
}