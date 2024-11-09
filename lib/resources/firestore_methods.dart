

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_app/models/post.dart';
import 'package:insta_app/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async{
    String res = "some error occured";

    try {
      String photoUrl = await StorageMethods().uploadImageToStorage('posts',
          file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
    }
    Future<String> likePost(String postId,String uid,List likes) async{
    String res = "some error occured";
    try{
      if(likes.contains((uid))){
        _firestore.collection('posts').doc(postId).update({'likes':FieldValue.arrayRemove([uid])});
      }
      else{
        _firestore.collection('posts').doc(postId).update({'likes':FieldValue
            .arrayUnion([uid])});
      }
      res="success";
    } catch (err){
      res = err.toString();
    }
    return res;
    }

    Future<String> postComment(String postId, String text, String uid, String
    name, String profilePic)async{
    String res = "some error occured";
    try{
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        _firestore.collection('posts').doc(postId).collection('comments').doc
          (commentId).set({
          'profilepic':profilePic,
          'name':name,
          'uid':uid,
          'text':text,
          'commentId':commentId,
          'datePublished':DateTime.now(),

        });
        res = "success";
      }else{
        res = "please enter text";
      }
    }catch(err){
      res = err.toString();
    }
    return res;
    }

    Future<String> deletePost(String postId) async{
    String res = "some error occured";
    try{
      await _firestore.collection('posts').doc(postId).delete();
      res = "success";
    }catch(err){
      res = err.toString();
    }
    return res;
    }
  }


