// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_app/resources/storage_methods.dart';
import 'package:insta_app/models/user.dart' as model;

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<model.User>getUserDetails()async{
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =  await FirebaseFirestore.instance.collection
      ('users').doc(FirebaseAuth
        .instance.currentUser!.uid).get();

        return model.User.fromSnap(snap);

  }

  signUpUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    required file,
  }) async {
    String res = "some error occured";
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage("profilepic", file, false);
        model.User _user = model.User(
            username: username,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            followers: [],
            following: [],
            photoUrl: photoUrl);
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(_user.toJson());
        res = "success";
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  loginUser({required String email, required String password}) async {
    String res = "Some error Occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }
}
