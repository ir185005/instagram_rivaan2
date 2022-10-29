import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_rivaan/providers/user_pr.dart';
import 'package:instagram_rivaan/responsive/layout_scr.dart';
import 'package:instagram_rivaan/responsive/mobile_scr.dart';
import 'package:instagram_rivaan/responsive/web_scr.dart';
import 'package:instagram_rivaan/screens/login_scr.dart';
import 'package:instagram_rivaan/screens/signup_scr.dart';
import 'package:instagram_rivaan/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDF0T-OAHzT8VqwC3jSctt5ZCIXS1gFDDU",
          authDomain: "instagram-rivaan-92cc6.firebaseapp.com",
          projectId: "instagram-rivaan-92cc6",
          storageBucket: "instagram-rivaan-92cc6.appspot.com",
          messagingSenderId: "250924580985",
          appId: "1:250924580985:web:7129292bf572b6d77c14a8"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          title: 'Instagram Clone',
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              return const LoginScreen();
            },
          )),
    );
  }
}
