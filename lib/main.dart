import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:youtube_testing/fetch_auth_client.dart';



 const CHANNEL_ID = 'UCshJkIDg8JxgFLzlXGZAgFg';
 const key = 'AIzaSyDK0GLBwrb00uC3uu0060O2QPoaYi6ySNk';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: VideosHomeScreen(),
      //  home: LoginWithGoogle(),
      home: SignInDemoWidget(),
    );
  }
}
