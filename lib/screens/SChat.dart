import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../widgets/WMessages.dart';
import '../widgets/WNewMsg.dart';


class SChat extends StatefulWidget {
  @override
  _SChatState createState() => _SChatState();
}

class _SChatState extends State<SChat> {

  @override
  void initState() {
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
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your chats"),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color
            ),
            items: [
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
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: WMessages()),

            WNewMsg(),
          ],
        ),
      ),
    );
  }
}
