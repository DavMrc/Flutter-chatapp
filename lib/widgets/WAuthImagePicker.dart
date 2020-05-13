import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';


class WAuthImagePicker extends StatefulWidget {
  final Function _submitImage;

  WAuthImagePicker(this._submitImage);

  @override
  _WAuthImagePickerState createState() => _WAuthImagePickerState();
}

class _WAuthImagePickerState extends State<WAuthImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    try{
      final image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        this._pickedImage = image;
      });

      this.widget._submitImage(this._pickedImage);
    }
    on PlatformException catch(error){
      if(error.code.toLowerCase() == "photo_access_denied"){
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Warning!"),
            content: Text("You need to grant permission to the storage in order to upload an image!"),
            actions: [
              FlatButton(child: Text("Okay"), onPressed: () => Navigator.of(context).pop(),)
            ],
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: this._pickedImage != null
            ? FileImage(this._pickedImage)
            : null,
          backgroundColor: Colors.grey,
        ),

        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: this._pickImage,
          icon: Icon(Icons.photo),
          label: Text("Upload image"),
        ),
      ],
    );
  }
}