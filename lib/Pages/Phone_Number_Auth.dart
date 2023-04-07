import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_uploader/Pages/Home_Page.dart';
import '../provider/auth_provider.dart';
import '../widgets/Custom_Text_Field.dart';

class PhoneAuthScreen extends StatelessWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          }
          return Scaffold(
              body: Consumer<AuthProvider>(builder: (context, model, _) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField(
                        hinttext: 'Enter phone number',
                        controller: model.phoneNumberController,
                        prefixicon: Icons.phone),
                    TextButton(
                        onPressed: () {
                          model.verifyPhoneNumber(context);
                        },
                        child: const Text('Sent OTP'))
                  ],
                ),
              ),
            );
          }));
        });
  }
}
