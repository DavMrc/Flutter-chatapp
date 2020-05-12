import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SChat extends StatelessWidget {
  static const routeName = "/chat";
  static const msgsCollection = 'chats/Ka5W8FF8IUVaGbeukU6C/messages';

  Widget onFSValue(AsyncSnapshot<dynamic> snapshot){
    if(snapshot.connectionState == ConnectionState.waiting){
      return Center(child: CircularProgressIndicator(),);
    }

    final documents = snapshot.data.documents;
  
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (_, index) => Container(
        padding: const EdgeInsets.all(8),
        child: Text(documents[index]['text']),
      ),
    );
  }

  void addMessage(){
    Firestore.instance.collection(SChat.msgsCollection).add({
      'text': "This was added by clicking the button!"
    });
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
              if(itemIdentifier == 'logout'){
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),

      body: StreamBuilder(
        stream: Firestore.instance.collection(SChat.msgsCollection).snapshots(),  // autonotified listener
        builder: (_, snapshot) => this.onFSValue(snapshot),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => this.addMessage(),
      ),
    );
  }
}