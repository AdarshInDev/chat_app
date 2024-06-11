import 'dart:developer';
import 'dart:io';

import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Apis {
  // for accesing authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  // for connecting to data base and store data and retrieve data

  static FirebaseFirestore fstore = FirebaseFirestore.instance;

//for accessing  fibase storage
  static FirebaseStorage storage = FirebaseStorage.instance;
  //for storing self information
  static late ChatUser me;

  //to return current user
  static User get user => auth.currentUser!;

  // for checking if user exists or not ?

  static Future<bool> userExists() async {
    return (await fstore.collection('users').doc(auth.currentUser!.uid).get())
        .exists;
  }

  //for getting self user information
  static Future<void> getSelfInfo() async {
    await fstore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) {});
      }
    });
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "Hello I am in the Cloud and coding in the Stars",
        createdAt: time,
        lastActive: time,
        isOnline: false,
        id: auth.currentUser!.uid,
        email: user.email.toString(),
        pushToken: '');

    return await fstore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllusers() {
    return fstore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

//function which changes the profile data at the firestore database
  static Future<void> updateUserInfo() async {
    return await fstore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  //function to change amd update the profile picture

  static Future<void> updateProfilePic(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    log('extension: $ext');
    //storing image file reference path
    final ref = storage.ref().child('profile_picture/${user.uid}.$ext');
    //uploading image
    ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      log('Transferred data : ${p0.bytesTransferred / 1000} Kb');
    });
    me.image = await ref.getDownloadURL();
    await fstore.collection('users').doc(user.uid).update({'image': me.image});
  }

  /// ***************** ChatScreen Related APIs ****************************

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

//for  getting messages fromm a specific conversation from the firebase server

//path we will follow in firestore or structure of frirestore
  ///chats(collection)=>conversationId(doc)=>messages(collection)=>message(doc)....
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return fstore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .snapshots();
  }

  //for sending message

  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        toId: chatUser.id,
        sent: time,
        type: Type.text,
        msg: msg,
        fromId: user.uid,
        read: '');

    final ref =
        fstore.collection('chats/${getConversationID(chatUser.id)}/messages/');
    ref.doc().set(message.toJson());
  }

  static void deleteChat() {
    fstore.collection('chats').doc(getConversationID(me.id)).delete();
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    fstore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }
}
