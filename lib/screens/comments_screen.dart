import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_app/models/user.dart';
import 'package:insta_app/providers/user_provider.dart';
import 'package:insta_app/resources/firestore_methods.dart';
import 'package:insta_app/utils/colors.dart';
import 'package:insta_app/utils/utils.dart';
import 'package:insta_app/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({super.key,required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController = TextEditingController();

  void postComment(String uid, String name, String profilePic) async{
    try{
      String res = await FirestoreMethods().postComment(widget.postId,
          commentEditingController.text, uid, name, profilePic);
      if(res!='success'){
        if(context.mounted)showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text="";
      });
    }catch(err){
      showSnackBar(context, err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    if (user == null) {
      return Center(child: Text("User not available"));  // Handle null user case
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('comments'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').doc(widget
            .postId).collection('comments').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String,
            dynamic>>>snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length ?? 0,
            itemBuilder: (context, index) {
              final snap = snapshot.data!.docs[index] ?? {};
              return CommentCard(snap: snap);
            }
          );
        }
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: user.photoUrl != null
                  ? NetworkImage(user.photoUrl)
                  : null, radius: 18,
            ),
            Expanded(child: Padding(padding: const EdgeInsets.only(left: 16, right: 8),
            child: TextField(controller: commentEditingController,
            decoration: InputDecoration(
              hintText: 'comment as ${user.username}', border: InputBorder.none
            ),
            ),
            )),
            InkWell(
              onTap: () => postComment(user.uid,user.username,user.photoUrl),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Text('Post', style: TextStyle(color: Colors.blue),),
              ),
            )
          ],
        ),
      )),
    );
  }
}
