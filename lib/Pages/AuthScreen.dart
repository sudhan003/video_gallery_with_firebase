import 'package:flutter/material.dart';
import 'package:video_uploader/Pages/Phone_Number_Auth.dart';
import 'package:video_uploader/widgets/auth_button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            authbutton(
              icon: Icons.phone,
              text: "Phone Number",
              ontap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PhoneAuthScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
