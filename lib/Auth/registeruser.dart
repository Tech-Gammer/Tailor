
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Models/adminmodel.dart';
import 'loginpage.dart';



class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authentication = FirebaseAuth.instance;
  final nc = TextEditingController();
  final ec = TextEditingController();
  final phonec = TextEditingController();
  final pass = TextEditingController();
  final DatabaseReference dref = FirebaseDatabase.instance.ref();

  bool isRegistering = false;
  bool isAdminAvailable = false;
  String selectedRole = '1'; // Default to Silai ('1') if dropdown is shown

  @override
  void initState() {
    super.initState();
    _checkAdminExistence();
  }

  // Check if any admin exists in the database
  Future<void> _checkAdminExistence() async {
    final DataSnapshot adminSnapshot = await dref.child('admin').get();
    setState(() {
      isAdminAvailable = adminSnapshot.exists;
    });
  }

  void RegisterUser() async {
    setState(() {
      isRegistering = true;
    });
    try {


      // Determine admin or employee role based on admin existence
      if (!isAdminAvailable) {
        UserCredential userCredential = await authentication.createUserWithEmailAndPassword(
          email: ec.text.trim(),
          password: pass.text.trim(),
        );

        String uid = userCredential.user!.uid;
        final DatabaseReference adminRef = dref.child('admin');
        // final DatabaseReference employeeRef = dref.child('employee');
        // Register as the first admin if no admin exists
        await _registerAdmin(uid, adminRef, "0");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Admin registered successfully")),
        );
        User? user = authentication.currentUser;
        if (user != null) {
          await user.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Verification email sent. Please check your email.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User not found for sending verification email.")),
          );
        }
      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Admin Already Registered.... ")),
        );
      }

      // Send verification email


      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    } finally {
      setState(() {
        isRegistering = false;
      });
    }
  }

  Future<void> _registerAdmin(String uid, DatabaseReference adminRef, String role) async {
    int adminNumber = 1;
    final DataSnapshot adminSnapshot = await adminRef.get();

    if (adminSnapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Admin Already Registered')));
      return;
    }

    AdminModel adminModel = AdminModel(
      uid,
      nc.text.trim(),
      ec.text.trim(),
      phonec.text.trim(),
      pass.text.trim(),
      role,
      adminNumber.toString(),
    );

    await adminRef.child(uid).set(adminModel.toMap());
  }


  String? validatePhoneNumber(String? value) {
    final RegExp phonePattern = RegExp(r'^(03[0-9]{9}|(\+92)[0-9]{10})$');
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!phonePattern.hasMatch(value)) {
      return 'Please enter a valid phone number (03XXXXXXXXX or +92XXXXXXXXXX)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Image.asset("assets/images/logo.png"),
            ),
            Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: nc,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: "Enter Your Name",
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: ec,
                        decoration: const InputDecoration(
                          hintText: "Enter Your Email Address",
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: phonec,
                        decoration: const InputDecoration(
                          hintText: "Enter Your Phone No",
                          labelText: "Phone No",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        validator: validatePhoneNumber,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: pass,
                        decoration: const InputDecoration(
                          hintText: "Enter Your Password",
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        obscureText: true,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Card(
                      child: InkWell(
                        onTap: isRegistering ? null : RegisterUser,
                        child: Container(
                          width: 200.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.blueAccent,
                              Colors.greenAccent
                            ]),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Text(
                              isRegistering ? "Registering..." : "Register",
                              style: const TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Text("If you are already registered, please click on"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                          child: const Text("Login"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
