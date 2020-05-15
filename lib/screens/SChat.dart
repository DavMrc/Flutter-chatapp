import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../screens/SSettings.dart';
import '../widgets/WConversations.dart';


class SChat extends StatefulWidget {
  FirebaseUser _user;
  Map<String, dynamic> _userData = {};

  SChat(this._user);

  @override
  _SChatState createState() => _SChatState();
}

class _SChatState extends State<SChat> {

  @override
  void initState() {
    super.initState();

    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (msg){   // if app is on foreground
        print(msg);
        return;
      },
      onLaunch: (msg){    // if app was totally closed
        print(msg);
        return;
      },
      onResume: (msg){    // if app was on background
        print(msg);
        return;
      },
    );

    fbm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your chats"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: DropdownButton(
              underline: Container(),
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 8,),
                        Text("Settings"),
                      ],
                    ),
                  ),
                  value: "settings",
                ),

                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 8,),
                        Text("Logout"),
                      ],
                    ),
                  ),
                  value: "logout",
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') FirebaseAuth.instance.signOut();
                else if (itemIdentifier == "settings"){
                  Navigator.of(context).pushNamed(
                    SSettings.routeName,
                    arguments: this.widget._userData,
                  );
                }
              },
            ),
          ),
        ],
      ),

      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('users').document(this.widget._user.uid).snapshots(),
          builder: (_, snapshot) {
            if(snapshot.hasData){
              this.widget._userData = snapshot.data.data;

              if(snapshot.data['contacts'] == []){
                return Text("You have no contacts");
              }else{
                return WConversations(snapshot.data['contacts']);
              }
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   backgroundColor: Theme.of(context).accentColor,
      //   onPressed: this._createNewConversation,
      // ),
    );
  }
}
