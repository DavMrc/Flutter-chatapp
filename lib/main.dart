import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/SAuth.dart';
import './screens/SConversations.dart';
import './screens/SSettings.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Colors.pink,
        primarySwatch: Colors.pink,
        accentColor: Colors.deepPurple,
        secondaryHeaderColor: Colors.amber,
        accentColorBrightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
      routes: {
        '/': (_) => StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (_, snapshot){
            if(snapshot.hasData){
              return SConversations(snapshot.data);
            }
            else return SAuth();
          },
        ),
        SSettings.routeName: (_) => SSettings(),
      },
    );
  }
}
