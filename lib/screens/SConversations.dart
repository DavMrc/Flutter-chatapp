import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../screens/SSettings.dart';
import '../widgets/WConversationItem.dart';


class SConversations extends StatefulWidget {
  FirebaseUser _user;
  DocumentSnapshot _userData;

  SConversations(this._user);

  @override
  _SConversationsState createState() => _SConversationsState();
}

class _SConversationsState extends State<SConversations> {

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
        title: Text("Your conversations"),
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
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (_, snapshot) {
            if(snapshot.hasData){
              final users = snapshot.data.documents;

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (_, index) {
                  if(users[index]['username'] == this.widget._user.displayName){
                    this.widget._userData = users[index];
                    return Container();
                  }
                  return WConversationItem(users[index]);
                },
              );
            }
            else{
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ),

    );
  }
}
