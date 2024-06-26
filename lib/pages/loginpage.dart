// ignore_for_file: non_constant_identifier_names, unused_local_variable, prefer_const_constructors, avoid_print, use_build_context_synchronously, unused_catch_clause, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps

import 'package:codeblock/Service/AUTHENTICATION/Authentication.dart';
import 'package:codeblock/pages/newuser.dart';
import 'package:codeblock/pages/page_navi.dart';
import 'package:codeblock/pages/password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  // All the variables
  bool _isLoading = false;
  bool _obscureText = true;
  bool _isChecked = false;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
// Login function
  loginfun(String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    if (emailcontroller.text.isEmpty && passwordcontroller.text.isEmpty) {
      setState(() {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter both email and password.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      });
    } else {
      UserCredential? userCredential;

      try {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          Authentication().SignIn(email, password);
        }).then((value) => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomeScreen())));
      } on FirebaseAuthException catch (ex) {
        setState(() {
          // Show an error message using SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Not Found: Please Enter Correct Data"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red, // Set the behavior to floating
            ),
          );
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

// Build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Main body starts here
      body: SafeArea(
        top: true,
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(right: 40, left: 40, top: 10),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome\tBack,",
                        style: TextStyle(
                            fontFamily: 'Profile',
                            fontSize: 26,
                            color: Colors.blue[400],
                            fontWeight: FontWeight.bold)),
                    Text("To Study-Circle",
                        style: TextStyle(
                            fontFamily: 'Profile',
                            fontSize: 26,
                            color: Colors.blue[400],
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),

            const SizedBox(
              height: 25,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Email",
                  style: TextStyle(fontSize: 15, color: Colors.blue[400]),
                )
              ],
            ),
            // Email text field
            TextField(
              controller: emailcontroller,
              decoration: InputDecoration(
                hintText: " Email ",
                prefixStyle: const TextStyle(color: Colors.black, fontSize: 55),
                labelStyle: const TextStyle(color: Colors.black),
                prefixIcon: const Icon(Icons.mail),
                prefixIconColor: Colors.black45,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.blue[200],
              ),
            ),

            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Password",
                  style: TextStyle(fontSize: 15, color: Colors.blue[400]),
                )
              ],
            ),
            // Password

            TextField(
              controller: passwordcontroller,
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: "Password",
                prefixStyle: const TextStyle(color: Colors.black, fontSize: 15),
                labelStyle: const TextStyle(color: Colors.black),
                prefixIcon: const Icon(Icons.password),
                prefixIconColor: Colors.black,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.blue[200],
              ),
            ),

            const SizedBox(
              height: 5,
            ),
            // Forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: const Text(
                    " Forgot Password ?",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePassword()));
                  },
                )
              ],
            ),
            // Remember me
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _isChecked = newValue;
                      });
                    }
                  },
                  fillColor: MaterialStateColor.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.blue; // Color when checkbox is checked
                    }
                    return Colors.white; // Color when checkbox is unchecked
                  }),
                ),
                const Text("Remember Me")
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            // Sign in button
            OutlinedButton(
                onPressed: () async {
                  loginfun(emailcontroller.text, passwordcontroller.text);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: const CircularProgressIndicator(
                          color: Colors.blue,
                          strokeCap: StrokeCap.round,
                          strokeWidth: 2.5,
                          backgroundColor: Colors.white,
                        ),
                      )
                    : const Text(
                        "Sign In",
                        style: TextStyle(fontSize: 15, color: Colors.blue),
                      )),
            const SizedBox(
              height: 10,
            ),
            // Create new account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Create New Account ? ",
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Newuser()));
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ),
          ],
        ),
      ),
      // Main body ends here
    );
  }
}
