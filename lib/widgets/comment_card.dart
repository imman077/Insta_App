import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({super.key,required this.snap});

  @override
  Widget build(BuildContext context) {
    final profilePic = snap.data()['profilePic'] ?? '';
    final name = snap.data()['name'] ?? 'Unknown';
    final text = snap.data()['text'] ?? '';
    final datePublished = snap.data()['datePublished'];

    return snap.data()['datePublished']!=null? Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: profilePic.isNotEmpty ? NetworkImage(profilePic) : null,
            radius: 18,
          ),
          Expanded(child: Padding(padding: const EdgeInsets.only(left: 16),
          child: Column(
            children: [
              RichText(text: TextSpan(children: [
                TextSpan(
                  text: name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold
                  )
                ),
                TextSpan(text: ' $text')
              ])),
              Padding(padding: const EdgeInsets.only(top: 4),
                child: Text(DateFormat.yMMMd().format(datePublished.toDate()),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),)),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.favorite,
            size: 16,
            ),
          )
        ],
      ),
    ):SizedBox();
  }
}
