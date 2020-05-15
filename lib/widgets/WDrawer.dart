import 'package:flutter/material.dart';


class WDrawer extends StatefulWidget {
  String _userName;
  String _email;
  String _photoUrl;

  WDrawer(this._userName, this._email, this._photoUrl);

  @override
  _WDrawerState createState() => _WDrawerState();
}

class _WDrawerState extends State<WDrawer> {
  void updateUserInfo(Map<String, dynamic> dbUserInfo){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            // title: Text("Hello ${this.widget._userName}!"),
            automaticallyImplyLeading: false,
            
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            child: Image.network(
              this.widget._photoUrl,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}