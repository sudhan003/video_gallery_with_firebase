
import
'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../keys.dart';
import '../widgets/Custom_Text_Field.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //firebase Phone number verification
  TextEditingController phoneNumberController =
      TextEditingController(text: '+919943312165');
  verifyPhoneNumber(BuildContext context) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumberController.text,
          timeout: const Duration(seconds: 30),
          verificationCompleted: (AuthCredential authCredential) {
            Keys.scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
              content: Text("Verification completed"),
              backgroundColor: Colors.green,
            ));
          },
          verificationFailed: (FirebaseException exception) {
            Keys.scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
              content: Text("Verification failed"),
              backgroundColor: Colors.red,
            ));
          },
          codeSent: (String? verId, int? forceCodeResent) {
            Keys.scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
              content: Text("Code sent successfully"),
              backgroundColor: Colors.green,
            ));
            verificationId = verId;
            otpDialogBox(context);
          },

          codeAutoRetrievalTimeout: (verId) {
            Keys.scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
              content: Text("Time out"),
              backgroundColor: Colors.red,
            ));
          });
    } on FirebaseException catch (e) {
      Keys.scaffoldMessengerKey.currentState!
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  TextEditingController otpController = TextEditingController();
  otpDialogBox(BuildContext context) {
    return showDialog(context: context, builder: (_) {
      return  AlertDialog(
        title: const Text("Enter the OTP"),
        content: CustomTextField(
          hinttext: 'OTP',
          prefixicon: Icons.code,
          controller: otpController,
        ),
        actions: [
         TextButton(onPressed: () {
           Navigator.pop(context);
           signinWithPhone();
         },
         child: const Text("Submit"))
        ],
      );
    }
    );
  }

  String? verificationId;
  signinWithPhone() async{
   await firebaseAuth.signInWithCredential(
       PhoneAuthProvider.credential(
           verificationId: verificationId!,
           smsCode: otpController.text));
  }

  signOut () async{
    await firebaseAuth.signOut();
  }
}
