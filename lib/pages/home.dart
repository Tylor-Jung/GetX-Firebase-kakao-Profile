import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakao_profile/pages/login.dart';
import 'package:kakao_profile/pages/profile.dart';
import 'package:kakao_profile/src/controller/profile_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        ProfileController.to.authStateChanges(snapshot.data);
        if (snapshot.hasData) {
          return Profile();
        } else {
          return LoginWidget();
        }
      },
    );
  }
}
