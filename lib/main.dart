import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_app/providers/user_provider.dart';
import 'package:insta_app/responsive/mobile_screen_layout.dart';
import 'package:insta_app/responsive/responsive_layout.dart';
import 'package:insta_app/responsive/web_screen_layout.dart';
import 'package:insta_app/screens/login_screen.dart';
import 'package:insta_app/utils/colors.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: "AIzaSyBhB9MM4LlzpaUE4iJa_QelOU56wrzBfyQ",
      appId: "1:79085326941:web:99a67af13bb4b9e650b3b4",
      messagingSenderId: "79085326941",
      projectId: "instagramapp-7b490",
      storageBucket: "instagramapp-7b490.appspot.com",
    ));
  }
  else{
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot){
          if(snapshot.connectionState==ConnectionState.active){
            if(snapshot.hasData){
            return ResponsiveLayout(mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout());
          }
          else if (snapshot.hasError){
            return Center(child: Text('${snapshot.error}'));

      }

      if(snapshot.connectionState==ConnectionState.waiting){
        return Center(child: CircularProgressIndicator());
      }}
      return LoginScreen();
      }
        ),

      ),
    );
  }
}
