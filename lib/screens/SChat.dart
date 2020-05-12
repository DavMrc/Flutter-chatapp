import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/WMessages.dart';
import '../widgets/WNewMsg.dart';


class SChat extends StatelessWidget {
  static const routeName = "/chat";
  static const msgsCollection = 'chats';

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
