import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class WDrawer extends StatelessWidget {

  String getUsername() {
    var s = "";
    FirebaseAuth.instance.currentUser().then((value) => s = value.displayName);
    return s;
  }
  
  @override
  Widget build(BuildContext context) {
    String username = this.getUsername();

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello $username!"),
            automaticallyImplyLeading: false,
          ),
        ],
      ),
    );
  }
}