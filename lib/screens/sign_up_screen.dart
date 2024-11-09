import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_app/resources/auth_methods.dart';
import 'package:insta_app/responsive/mobile_screen_layout.dart';
import 'package:insta_app/responsive/responsive_layout.dart';
import 'package:insta_app/responsive/web_screen_layout.dart';
import 'package:insta_app/screens/login_screen.dart';
import 'package:insta_app/utils/colors.dart';
import 'package:insta_app/utils/utils.dart';
import 'package:insta_app/widgets/text_field_input.dart';
// import 'dart:typed_data';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bioController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  selectImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) {
      print("No image selected");
      return;
    }
    final img = await image.readAsBytes();
    setState(() {
      _image = img;
    });
  }

  signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        username: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        bio: bioController.text,
        file: _image);
    if (res == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ResponsiveLayout(mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout())));
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);

    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2),
              Image.asset("assets/instagram_logo.png", scale: 15),
              SizedBox(height: 64),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64, backgroundImage: MemoryImage(_image!))
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("assets/img_avatar.png"),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 65,
                      child: IconButton(
                          onPressed: selectImage,
                          icon: Icon(Icons.add_a_photo_rounded)))
                ],
              ),
              SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: nameController,
                  hintText: "Enter your username",
                  textInputType: TextInputType.text),
              SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: emailController,
                  hintText: "Enter your email",
                  textInputType: TextInputType.emailAddress),
              SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textEditingController: passwordController,
                hintText: "Enter your password",
                textInputType: TextInputType.text,
                isPass: true,
              ),
              SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: bioController,
                  hintText: "Enter your bio",
                  textInputType: TextInputType.text),
              SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: signUpUser,
                child: Container(
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: primaryColor,
                        )
                      : Text(
                          "Sign Up",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15),
                        ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: Colors.blue),
                ),
              ),
              Flexible(child: Container(), flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Don't have an account?"),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Container(
                      child: Text(
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
