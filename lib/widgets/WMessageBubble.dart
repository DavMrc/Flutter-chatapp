import 'package:flutter/material.dart';


class WMessageBubble extends StatelessWidget {
  final String _text;

  WMessageBubble(this._text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.55,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor.withOpacity(0.65),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 1.8,
              color: Theme.of(context).accentColor
            ),
          ),

          child: Text(
            this._text,
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.headline6.color,
            ),
          ),
        ),
      ],
    );
  }
}