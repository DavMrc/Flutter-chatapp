import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SSettings extends StatefulWidget {
  static const routeName = "/settings";
  @override
  _SSettingsState createState() => _SSettingsState();
}

class _SSettingsState extends State<SSettings> {
  @override
  Widget build(BuildContext context) {
    DocumentSnapshot userData = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(title: const Text("Your account settings"),),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userData['imageUrl']),
                    radius: 70,
                  ),
                  const SizedBox(width: 30,),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          userData['username'],
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                          ),
                        ),
                        Text(
                          userData['email'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 30,),

            ],
          ),
        ),
      ),
    );
  }
}