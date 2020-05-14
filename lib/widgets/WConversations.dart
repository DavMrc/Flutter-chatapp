import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class WConversations extends StatelessWidget {
  final List<dynamic> _contacts;

  WConversations(this._contacts);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this._contacts.length,
      itemBuilder: (_, index){

        return FutureBuilder(
          future: Firestore.instance.collection('users')
            .where('username', isEqualTo: this._contacts[index])
            .getDocuments(),
          builder: (_, snapshot){
            if(snapshot.hasData){
              final contactFullData = snapshot.data.documents[0].data;
              return ConversationItem(contactFullData);
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          },
        );
      }
    );
  }
}


class ConversationItem extends StatelessWidget {
  final Map<String, dynamic> _contactFullData;

  ConversationItem(this._contactFullData);

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
        onTap: (){},  // go to private chat
      ),
    );
  }
}