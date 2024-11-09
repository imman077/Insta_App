import 'package:flutter/material.dart';
import 'package:insta_app/resources/auth_methods.dart';
import 'package:insta_app/responsive/mobile_screen_layout.dart';
import 'package:insta_app/responsive/responsive_layout.dart';
import 'package:insta_app/responsive/web_screen_layout.dart';
import 'package:insta_app/screens/sign_up_screen.dart';
import 'package:insta_app/utils/colors.dart';
import 'package:insta_app/utils/utils.dart';
import 'package:insta_app/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: emailController.text, password: passwordController.text);
    if (res == "success") {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:
      (context)=>ResponsiveLayout(mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout())),(route)=> false);
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              GestureDetector(
                onTap: loginUser,
                child: Container(
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: primaryColor,
                        )
                      : Text(
                          "Log in",
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
                    onTap: () async {
                      try {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        );
                      } catch (e) {
                        // Handle errors if the async operation fails
                        print('Error occurred: $e');
                      }
                    },
                    child: Container(
                      child: Text(
                        "Sign up",
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
