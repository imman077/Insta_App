
import 'package:flutter/cupertino.dart';
import 'package:insta_app/screens/add_post_screen.dart';
import 'package:insta_app/screens/feed_screen.dart';
import 'package:insta_app/screens/search_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(child: Text("favorite")),
  Center(child: Text("profile")),
];