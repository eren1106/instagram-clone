import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/color_provider.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCY-K7lLZp81IW8KJK1zEu9q9f_H1EF9Ik",
        appId: "1:555953032989:web:35c339b18310297642dbf4",
        messagingSenderId: "555953032989",
        projectId: "instagram-clone-15850",
        storageBucket: "instagram-clone-15850.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ColorProvider(),
          ),
        ],
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Instagram Clone',
            theme: Provider.of<ColorProvider>(context).getIsDark
                ? ThemeData.dark().copyWith(
                    scaffoldBackgroundColor:
                        Provider.of<ColorProvider>(context).backgroundColor,
                  )
                : ThemeData.light().copyWith(
                    scaffoldBackgroundColor:
                        Provider.of<ColorProvider>(context).backgroundColor,
                  ),
            // home: ResponsiveLayout(
            //   mobileScreenLayout: MobileScreenLayout(),
            //   webScreenLayout: WebScreenLayout(),
            // ),
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return const ResponsiveLayout(
                        mobileScreenLayout: MobileScreenLayout(),
                        webScreenLayout: WebScreenLayout(),
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

                  return LoginScreen();
                }),
          );
        });
  }
}
