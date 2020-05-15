import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    File imageFile,
    bool isLogin,
    BuildContext ctx,
  }) async {
    try{
      var authResult;

      if(isLogin) {
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

        final imageExtension = imageFile.path.substring(imageFile.path.lastIndexOf('.'));
        final imageLocation = FirebaseStorage.instance.ref()
          .child('user_images')
          .child(authResult.user.uid);
          // .child(authResult.user.uid + imageExtension);
        await imageLocation.putFile(imageFile).onComplete;
        final url = await imageLocation.getDownloadURL();

        this._auth.onAuthStateChanged.listen((userData) {  // add extra info to FirebaseAuth.currentUser()
          if(userData != null){
            var userInfo = UserUpdateInfo();
            userInfo.displayName = username;
            // userInfo.photoUrl = url;

            userData.updateProfile(userInfo);
          }
        });

        await Firestore.instance.collection('users')
          .document(authResult.user.uid)
          .setData({
            'username': username,
            'email': email,
            'imageUrl': url,
            'contacts': [],
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