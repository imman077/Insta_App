import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_app/utils/colors.dart';
import 'package:insta_app/utils/global_variables.dart';
import 'package:insta_app/utils/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: width>webScreenSize?webBackgroundColor:mobileBackgroundColor,
      appBar: width>webScreenSize? null :
      AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Image.asset("assets/instagram_logo.png",
            color: secondaryColor, scale: 30),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.messenger_outline, color: primaryColor,))],
      ),
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection
        ('posts').snapshots(), builder: (context,
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No posts available',
              style: TextStyle(color: primaryColor),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => PostCard(snap: snapshot.data!
                .docs[index].data()));
      })
    );
  }
}
