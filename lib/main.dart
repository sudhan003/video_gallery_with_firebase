import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_uploader/Pages/Home_Page.dart';
import 'package:video_uploader/Pages/Phone_Number_Auth.dart';
import 'package:video_uploader/provider/auth_provider.dart';
import 'Pages/AuthScreen.dart';
import 'firebase_options.dart';
import 'keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await availableCameras();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: Keys.scaffoldMessengerKey,
        themeMode: ThemeMode.system,
        theme: ThemeData(canvasColor: Colors.white,appBarTheme: const AppBarTheme(color: Colors.amber),),
        darkTheme: ThemeData.dark(),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const HomePage();
              } else {
                return const AuthScreen();
              }
            }),
      ),
    );
  }
}
