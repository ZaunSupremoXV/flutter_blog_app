import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/Authentication.dart';
import 'package:flutter_blog_app/models/Posts.dart';
import 'package:flutter_blog_app/pages/PhotoUpload.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignedOut});
  final AuthImplementaion auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<Posts> postsList = [];

  @override
  void initState() {
    super.initState();
    DatabaseReference postsRef =
        FirebaseDatabase.instance.reference().child("Posts");

    postsRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postsList.clear();

      for (var individualKey in KEYS) {
        Posts posts = Posts(
          DATA[individualKey]['time'],
          DATA[individualKey]['image'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
        );
        postsList.add(posts);
      }

      setState(() {
        print('Length : $postsList.length');
      });
    });
  }

  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print("Erro aqui mano: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        child: postsList.length == 0
            ? Center(
                child: SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      backgroundColor: Colors.grey,
                      strokeWidth: 6,
                    )))
            : ListView.builder(
                itemCount: postsList.length,
                itemBuilder: (_, index) {
                  return PostsUI(
                      postsList[index].date,
                      postsList[index].description,
                      postsList[index].image,
                      postsList[index].time);
                }),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[900],
        child: Container(
          margin: EdgeInsets.only(left: 70.0, right: 70.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                iconSize: 50,
                color: Colors.white,
                onPressed: _logoutUser,
              ),
              IconButton(
                icon: Icon(Icons.add_a_photo),
                iconSize: 40,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return UploadPhotoPage();
                  }));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget PostsUI(String image, String description, String date, String time) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Image.network(image, fit: BoxFit.cover),
            SizedBox(
              height: 10.0,
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
    );
  }
}
