import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_app/models/user.dart';
import 'package:insta_app/providers/user_provider.dart';
import 'package:insta_app/resources/firestore_methods.dart';
import 'package:insta_app/screens/comments_screen.dart';
import 'package:insta_app/utils/colors.dart';
import 'package:insta_app/utils/global_variables.dart';
import 'package:insta_app/utils/utils.dart';
import 'package:insta_app/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.snap});

  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCommentLen();
  }
  
  fetchCommentLen() async{
    try{
      QuerySnapshot snap = await FirebaseFirestore.instance.collection
        ('posts').doc(widget.snap['postId']).collection('comments').get();
      commentLen=snap.docs.length;
    }catch(err){
      showSnackBar(context, err.toString());
    }
    setState(() {

    });
  }

  deletePost(String postId) async{
    try{
      await FirestoreMethods().deletePost(postId);
    }catch(err){
      showSnackBar(context, err.toString());
    }
  }

  
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color:
                width > webScreenSize ? secondaryColor : mobileBackgroundColor),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                  child: ListView(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                shrinkWrap: true,
                                children: [
                                  'Delete',
                                ]
                                    .map((e) => InkWell(
                                          onTap: () {
                                            deletePost(widget.snap['postId']
                                                .toString());
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0,
                                                horizontal: 16.0),
                                            child: Text(e),
                                          ),
                                        ))
                                    .toList(),
                              )));
                    },
                    icon: Icon(Icons.more_vert))
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () {
              FirestoreMethods().likePost(widget.snap['postId'].toString(),
                  user!.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.snap['postUrl'] ??
                      'https://placeholder'
                          '.com/placeholder.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset('assets/img_placeholder.png'),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    )),
              ),
            ]),
          ),
          Row(
            children: [
              LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user?.uid),
                  smallLike: true,
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                      onPressed: () => FirestoreMethods().likePost(
                          widget.snap['postId'].toString(),
                          user!.uid,
                          widget.snap['likes']),
                      icon: widget.snap['likes'].contains(user?.uid)
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(Icons.favorite_border))),
              IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentsScreen(postId: widget.snap['postId'].toString(),))),
                  icon: Icon(
                    Icons.comment_outlined,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                  )),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bookmark_border,
                    )),
              ))
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      "${widget.snap['likes'].length} likes",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(color: primaryColor),
                          children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "  ${widget.snap['description']}",
                        ),
                      ])),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text("View all $commentLen comments"),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
