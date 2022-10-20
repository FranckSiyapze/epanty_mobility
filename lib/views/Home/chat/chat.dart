import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epanty_mobility/common/loading.dart';
import 'package:epanty_mobility/model/message.dart';
import 'package:epanty_mobility/views/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'message_database.dart';
import 'message_item.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final MessageDatabaseService messageService = MessageDatabaseService();

  _ChatState();

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  int _nbElement = 20;
  static const int PAGINATION_INCREMENT = 20;
  bool isLoading = false;
  int remainingTrips = 0;

  void initStateFunction() async {
    var toGet = await FirebaseFirestore.instance
        .collection("Payment")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (toGet.data() != null) {
      remainingTrips = toGet.data()!["trips"] as int;
      print("TESTTTTT NOMBRE " + remainingTrips.toString());
    } else {
      print("RESTE DE NOMBRE " + remainingTrips.toString());
    }
  }

  @override
  void initState() {
    initStateFunction();
    super.initState();
    listScrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (listScrollController.offset >=
        listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _nbElement += PAGINATION_INCREMENT;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        centerTitle: true,
        backgroundColor: Color.fromRGBO(90, 144, 53, 1),
        title: Text('Forum'),
        actions: <Widget>[],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ProfileTab(),
      ),
      body: Stack(
        children: [
          //if(remainingTrips > 0)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: buildListMessage(),
                  ),
                ),
                buildInput()
              ],
            ),
          isLoading ? Loading() : Container()
        ],
      ),
    );
  }

  Widget buildListMessage() {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height - 200,
      child: StreamBuilder<List<Message>>(
        stream: messageService.getMessage(_nbElement),
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
          if (snapshot.hasData) {
            List<Message> listMessage = snapshot.data ?? List.from([]);
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  MessageItem(
                      message: listMessage[index],
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      isLastMessage: isLastMessage(index, listMessage)),
              itemCount: listMessage.length,
              reverse: true,
              controller: listScrollController,
            );
          } else {
            return Center(child: Loading());
          }
        },
      ),
    );
  }

  bool isLastMessage(int index, List<Message> listMessage) {
    if (index == 0) return true;
    if (listMessage[index].idFrom != listMessage[index - 1].idFrom) return true;
    return false;
  }

  Widget buildInput() {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black, width: 0.5)),
          color: Colors.white),
      child: Row(
        children: [
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: Colors.blueGrey,
              ),
            ),
            color: Colors.white,
          ),
          Flexible(
            child: TextField(
              onSubmitted: (value) {
                onSendMessage(textEditingController.text, 0);
              },
              style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
              controller: textEditingController,
              decoration: InputDecoration.collapsed(
                hintText: 'Your message...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Colors.blueGrey,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Future getImage() async {
    print("Open Image gallery");
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile(pickedFile);
    }
  }

  Future uploadFile(XFile file) async {
    String fileName =
        DateTime
            .now()
            .millisecondsSinceEpoch
            .toString() + ".jpeg";
    try {
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': file.path});
      TaskSnapshot snapshot;
      if (kIsWeb) {
        snapshot = await reference.putData(await file.readAsBytes(), metadata);
      } else {
        snapshot = await reference.putFile(File(file.path), metadata);
      }

      String imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    } catch  (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      Fluttertoast.showToast(msg: "Error! Try again!");
    }
  }

  void onSendMessage(String content, int type) {
    if (content.trim() != '') {
      messageService.onSendMessage(Message(
          idFrom: FirebaseAuth.instance.currentUser!.uid,
          timestamp: DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
          content: content,
          type: type));
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      textEditingController.clear();
      listScrollController.animateTo(0.0,
          duration: Duration(seconds: 1), curve: Curves.easeOutCubic);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.red,
          //toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white);
    };
  }
}
