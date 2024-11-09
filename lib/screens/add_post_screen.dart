import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_app/models/user.dart';
import 'package:insta_app/providers/user_provider.dart';
import 'package:insta_app/resources/firestore_methods.dart';
import 'package:insta_app/utils/colors.dart';
import 'package:insta_app/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool _isLoading = false;
  final _descriptionController = TextEditingController();

  void postImage(
      String uid,
      String username,
      String profImage,
      ) async{
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage);
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, 'Posted');
        clearImage();
      }
      else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, res);
        print(res.toString());
      }
    } catch(e){
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, e.toString());
    }
  }

  void clearImage(){
    setState(() {
      _file = null;
      _descriptionController.clear();
    });
  }

  _selectImage() async{
    return showDialog(context: context, builder: (BuildContext context){
      return SimpleDialog(
        title: Text("create a post"),
        children: [
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: Text("Take a Photo"),
            onPressed: () async{
              Navigator.pop(context);
              Uint8List file = await pickImage(ImageSource.camera);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: Text("choose from gallery"),
            onPressed: () async{
              Navigator.pop(context);
              Uint8List file = await pickImage(ImageSource.gallery);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: Text("cancel"),
            onPressed: () async{
              Navigator.pop(context);
            },
          )
        ],
      );
    });
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return _file == null? Center(
      child: IconButton(onPressed: ()=> _selectImage(), icon: Icon(Icons.upload)),
    ):
      Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(onPressed: clearImage, icon: Icon(Icons.arrow_back)),
        title: Text('Post to'),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                if (user != null) {
                  postImage(user.uid, user.username, user.photoUrl);
                } else {
                  showSnackBar(context, "User not found");
                }
              },

              child: Text("Post",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold))),
        ],
      ),
      body: Column(
        children: [
          _isLoading?LinearProgressIndicator():
        SizedBox(),
        Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: user != null
                    ? NetworkImage(user.photoUrl)
                    : NetworkImage(
                    "https://img.freepik.com/free-photo/3d-portrait-people_23-2150793852.jpg"),
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.3,
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: "write a caption...",
                    border: InputBorder.none
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(height: 45,width: 45,child: AspectRatio(aspectRatio: 487/451,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: MemoryImage(_file!),
                      fit: BoxFit.fill, alignment: FractionalOffset.topCenter),
                ),
              ),
              )
            ),
          Divider(),
        ]),
      ]
      ),
    );
  }
}
