import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/pages/HomePage.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

String _idbanner = "ca-app-pub-1577485202493071/9244066135";

class UploadPhotoPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _UploadPhotoPageState();
  }
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  File sampleImage;
  String _myValue;
  String url;
  final formKey = GlobalKey<FormState>();

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadStatusImage() async {
    if (validateAndSave()) {
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child("Post Images");
      var timeKey = DateTime.now();

      final StorageUploadTask uploadtask =
          postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

      var ImageUrl = await (await uploadtask.onComplete).ref.getDownloadURL();

      url = ImageUrl.toString();
      print("Image Url = " + url);
      goToHomePage();
      saveToDatabase(url);
    }
  }

  void saveToDatabase(url) {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "image": url,
      "description": _myValue,
      "date": date,
      "time": time,
    };

    ref.child("Posts").push().set(data);
  }

  void goToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Imagem"),
        centerTitle: true,
      ),
      body: Center(
        child:
            sampleImage == null ? Text("Selecione uma imagem") : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
      ),
      bottomNavigationBar: AdmobBanner(
        adUnitId: _idbanner,
        adSize: AdmobBannerSize.BANNER,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          handleEvent(event, args, 'Banner');
        },
      ),
    );
  }

  Widget enableUpload() {
    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Image.file(
                sampleImage,
                height: 330.0,
                width: 660.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  return value.isEmpty ? 'Descrição é requerida' : null;
                },
                onSaved: (value) {
                  return _myValue = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              RaisedButton(
                elevation: 10.0,
                child: Text("Adicionar novo post"),
                textColor: Colors.white,
                color: Colors.blueGrey,
                onPressed: uploadStatusImage,
              )
            ],
          ),
        ),
      ),
    );
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        print("################ LOADED #########");
        break;
      case AdmobAdEvent.opened:
        print("################ OPENED #########");
        break;
      case AdmobAdEvent.closed:
        print("################ Goto next page #########");
        break;
      case AdmobAdEvent.failedToLoad:
        print("################ FAILEDTOLOAD #########");
        break;
      case AdmobAdEvent.rewarded:
        print("################ REWARDED #########");
        break;
      default:
    }
  }
}
