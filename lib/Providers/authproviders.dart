import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../ManagerSide/managerdashboard.dart';


class LoginProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoggingIn = false;

  // Function to handle login
  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Set loading to true
      isLoggingIn = true;
      notifyListeners();

      // Sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Get the user object
      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        // If the email is not verified
        await _auth.signOut(); // Sign out the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please verify your email to log in.')),
        );
        return;
      }

      // Get the user ID
      String uid = user?.uid ?? '';

      // Check admin node first
      String role = await _checkUserRoleInNode(uid, 'admin');
      if (role.isNotEmpty) {
        if (role == '0') {
          // Navigate to the admin dashboard
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          //   return dashBoard(); // Your existing admin dashboard
          // }));
          return; // Exit after navigation
        } else {
          // Show error if not admin
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access denied: Not an admin.')),
          );
          return; // Exit if the user is not an admin
        }
      }

      // If not found in admin node, check employee node
      role = await _checkUserRoleInNode(uid, 'employee');
      if (role.isNotEmpty) {
        if (role == '2') {
          // Navigate to the employee dashboard
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          //   return kataidashBoard(); // Your existing employee dashboard
          // }));
          return; // Exit after navigation
        } else if(role == '1'){
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return SilaidashBoard();
          // },));
        }
        else {
          // Show error if role is not recognized
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Access denied: Not an employee.')),
          );
        }
      } else {
        // Show error if user not found in both nodes
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access denied: Not an admin or employee.')),
        );
      }

    } on FirebaseAuthException catch (e) {
      // Show authentication error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } finally {
      // Set loading to false
      isLoggingIn = false;
      notifyListeners();
    }
  }

  // Helper function to check user role in a specified node
  Future<String> _checkUserRoleInNode(String uid, String nodeName) async {
    DatabaseReference nodeRef = FirebaseDatabase.instance.ref("$nodeName/$uid");
    DataSnapshot snapshot = await nodeRef.get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      return data['role'] ?? ''; // Return role if exists
    }
    return ''; // Return empty if not found
  }
  Future<void> checkUserRoleAndNavigate(String uid, BuildContext context) async {
    // Check role in admin node
    String role = await _checkUserRoleInNode(uid, 'admin');
    if (role.isNotEmpty) {
      if (role == '0') {
        // Navigate to the admin dashboard
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return dashBoard(); // Your existing admin dashboard
        }));
        return; // Exit after navigation
      }
    }

    // If not found in admin node, check employee node
    role = await _checkUserRoleInNode(uid, 'employee');
    if (role.isNotEmpty && role == '2') {
      // Navigate to the employee dashboard
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      //   return kataidashBoard(); // Your existing employee dashboard
      // }));
    } else if(role == '1'){
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return SilaidashBoard();
      // },));
    } else {
      // Handle case where user does not have access
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Access denied: Not an admin or employee.')),
      );
    }
  }

}
