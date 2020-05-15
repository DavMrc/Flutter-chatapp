import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class WConversationItem extends StatelessWidget {
  final DocumentSnapshot _contactFullData;

  WConversationItem(this._contactFullData);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(this._contactFullData['imageUrl']),
          radius: 25,
        ),
        title: Text(
          this._contactFullData['username'],
          style: TextStyle(
            fontSize: 20
          ),
        ),
        onTap: (){
          
        },  // go to private chat
      ),
    );
  }
}