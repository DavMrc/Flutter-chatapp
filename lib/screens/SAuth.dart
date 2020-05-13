import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../widgets/WAuthForm.dart';



class SAuth extends StatefulWidget {
  @override
  _SAuthState createState() => _SAuthState();
}

class _SAuthState extends State<SAuth> {
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm({
    String username,
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
  }) async {
    try{
      var authResult;

      if(isLogin) {
        // bool isLoggedIn = false;
        // this._auth.onAuthStateChanged.listen((event) {
        //   if(event.email == email){
        //     isLoggedIn = true;
        //   }
        // });
        // // final currentUser = await this._auth.currentUser();
        // if(isLoggedIn){
        //   showDialog(
        //     context: ctx,
        //     builder: (_) => AlertDialog(
        //       title: Text("Warning!", style: TextStyle(fontWeight: FontWeight.bold),),
        //       content: Text("You seem to be already logged in on another device.\nPlease sign out from the other authenticated device."),
        //       actions: [
        //         FlatButton(
        //           child: Text("Okay"),
        //           onPressed: () => Navigator.of(ctx).pop(),
        //         )
        //       ],
        //     ),
        //   );
        // }else{  // login normaly
        //   authResult = await this._auth.signInWithEmailAndPassword(
        //     email: email,
        //     password: password
        //   );
        // }
        authResult = await this._auth.signInWithEmailAndPassword(
          email: email,
          password: password
        );
      }
      
      else {  // sign up
        authResult = await this._auth.createUserWithEmailAndPassword(
          email: email,
          password: password
        );
        this._auth.onAuthStateChanged.listen((userData) {  // add extra info
          if(userData != null){
            var userInfo = UserUpdateInfo();
            userInfo.displayName = username;

            userData.updateProfile(userInfo);
          }
        });

        await Firestore.instance.collection('users')
          .document(authResult.user.uid)
          .setData({
            'username': username,
            'email': email,
          });
      }

    }
    on PlatformException catch (error){
      var msg = "An error occurred, check your credentials";

      if(error.message != null) msg = error.message;

      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
    catch(error){
      throw error;
    }
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