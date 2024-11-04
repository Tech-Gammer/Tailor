import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'Auth/loginpage.dart';
import 'ManagerSide/Shalwaar Kameez/add_shalwarkameez.dart';
import 'ManagerSide/Shalwaar Kameez/total_Shalwaar Kameez.dart';
import 'Providers/admin provider.dart';
import 'Providers/authproviders.dart';
import 'Providers/clientprovider.dart';
import 'Providers/measurementprovider.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ClientProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddShalwarKameez(),  // Use AuthStateHandler to manage navigation
    );
  }
}

class AuthStateHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),  // Listen to the auth state
      builder: (context, snapshot) {
        // Check if the connection is established and the user is authenticated
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data; // Get the current user

          // If the user is logged in, check their role
          if (user != null) {
            // Check user role from both nodes in the LoginProvider
            Provider.of<LoginProvider>(context, listen: false).checkUserRoleAndNavigate(user.uid, context);
            return const Center(child: CircularProgressIndicator()); // Show loading while checking role
          } else {
            // If the user is not logged in, navigate to the login page
            return const LoginPage();
          }
        }

        // While checking the authentication state, show a loading indicator
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
