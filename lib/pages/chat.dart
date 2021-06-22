import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto_app/pages/chatMessage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

<<<<<<< HEAD
final googleSignIn = new GoogleSignIn();
final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;
var currentUserEmail;
var _scaffoldContext;
=======
void main() {
  runApp(
    FriendlyChatApp(),
  );
}

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.orange,
  accentColor: Colors.orangeAccent,
);

String _name = '';

class FriendlyChatApp extends StatelessWidget {
  const FriendlyChatApp({
    Key key,
  }) : super(key: key);
>>>>>>> 75e3eeda5d33d34dbb34610048a71c75825a869b

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isComposingMessage = false;
  final reference = FirebaseDatabase.instance.reference().child('messages');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      child: new Column(
        children: <Widget>[
          new Flexible(
            child: new FirebaseAnimatedList(
              query: reference,
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              sort: (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key),
              itemBuilder: (BuildContext context, DataSnapshot messageSnapshot,
                  Animation<double> animation, int index) {
                return new ChatMessage(
                  messageSnapshot: messageSnapshot,
                  animation: animation,
                );
              },
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
          new Builder(builder: (BuildContext context) {
            _scaffoldContext = context;
            return new Container(width: 0.0, height: 0.0);
          })
        ],
      ),
      decoration: Theme.of(context).platform == TargetPlatform.iOS
          ? new BoxDecoration(
              border: new Border(
                  top: new BorderSide(
              color: Colors.grey[200],
            )))
          : null,
    ));
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isComposingMessage
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () async {
                      await _ensureLoggedIn();
                      File imageFile = await ImagePicker.pickImage();
                      int timestamp = new DateTime.now().millisecondsSinceEpoch;
                      Reference storageReference = FirebaseStorage.instance
                          .ref()
                          .child("img_" + timestamp.toString() + ".jpg");
                      storageReference.putFile(imageFile);
                      var url = Uri.parse(
                          await storageReference.getDownloadURL() as String);
                      _sendMessage(messageText: null, imageUrl: url.toString());
                    }),
              ),
              new Flexible(
                child: new TextField(
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.length > 0;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? getIOSSendButton()
                    : getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

    await _ensureLoggedIn();
    _sendMessage(messageText: text, imageUrl: null);
  }

  void _sendMessage({String messageText, String imageUrl}) {
    reference.push().set({
      'text': messageText,
      'email': googleSignIn.currentUser.email,
      'imageUrl': imageUrl,
      'senderName': googleSignIn.currentUser.displayName,
      'senderPhotoUrl': googleSignIn.currentUser.photoUrl,
    });

    analytics.logEvent(name: 'send_message');
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount signedInUser = googleSignIn.currentUser;
    if (signedInUser == null)
      signedInUser = await googleSignIn.signInSilently();
    if (signedInUser == null) {
      await googleSignIn.signIn();
      analytics.logLogin();
    }

    currentUserEmail = googleSignIn.currentUser.email;
  }
}
