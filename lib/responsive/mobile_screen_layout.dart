import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_app/models/user.dart' as model;
import 'package:flutter/material.dart';
import 'package:insta_app/providers/user_provider.dart';
import 'package:insta_app/utils/colors.dart';
import 'package:insta_app/utils/global_variables.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {

    int _page = 0;
    late PageController pageController;
    @override
    void initState(){
      super.initState();
      pageController = PageController();
    }
    @override
    void dispose(){
      super.dispose();
      pageController.dispose();
    }

    void navigationTapped(int page){
    pageController.jumpToPage(page);
    }

    void onPageChanged(int page){
      setState(() {
        _page = page;
      });
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar:
          CupertinoTabBar(backgroundColor: mobileBackgroundColor, items: [
        BottomNavigationBarItem(icon: Icon(Icons.home,
            color:_page==0?primaryColor:
            secondaryColor)),
        BottomNavigationBarItem(
            icon: Icon(Icons.search, color:_page==1?primaryColor:
            secondaryColor)),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color:_page==2?primaryColor:
            secondaryColor)),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color:_page==3?primaryColor:
            secondaryColor)),
        BottomNavigationBarItem(
            icon: Icon(Icons.person, color:_page==4?primaryColor:
            secondaryColor)),

      ],
              onTap: navigationTapped,
          ),
    );
  }
}


// final userProvider = Provider.of<UserProvider>(context);
//

// Check if `getUser` is null and show a loading indicator if it is
// if (userProvider.getUser == null) {
//   return Scaffold(
//     body: Center(
//         child: CircularProgressIndicator()), // Show a loading indicator
//   );
// }
// model.User user = userProvider.getUser!;
// print(user.username);