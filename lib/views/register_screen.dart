import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mymemberlink/views/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for storing data locally
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller for the email input field
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  // Controller for the password input field
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Center the content within the Scaffold
      body: Center(
        // Add padding around the content
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          // Create a column layout for the child widgets
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text field for email input
              TextField(
                controller: nameController, // Assign the email controller
                keyboardType: TextInputType.text, // Set keyboard type for email
                decoration: const InputDecoration(
                  // Outline border with rounded corners
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: "Name", // Placeholder text for email
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController, // Assign the email controller
                keyboardType:
                    TextInputType.emailAddress, // Set keyboard type for email
                decoration: const InputDecoration(
                  // Outline border with rounded corners
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: "Email", // Placeholder text for email
                ),
              ),
              const SizedBox(height: 10), // SizedBox widget to create spacing
              // Text field for password input
              TextField(
                controller: phoneNumController, // Assign the email controller
                keyboardType:
                    TextInputType.phone, // Set keyboard type for email
                decoration: const InputDecoration(
                  // Outline border with rounded corners
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: "Phone Number", // Placeholder text for email
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller:
                    passwordController, // Assign the password controller
                decoration: const InputDecoration(
                  // Outline border with rounded corners
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: "Password", // Placeholder text for password
                ),
                obscureText: true,
                // Hide text input for password
              ),

              const SizedBox(height: 10),
              TextField(
                controller:
                    password2Controller, // Assign the password controller
                decoration: const InputDecoration(
                  // Outline border with rounded corners
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText:
                      "Re-enter Password", // Placeholder text for password
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // Row widget to place "Remember me" text and checkbox horizontally

              // Button to trigger the login function
              MaterialButton(
                elevation: 10, // Button elevation for shadow effect
                onPressed:
                    onRegisterDialog, // Login function called when pressed
                minWidth: 400, // Set minimum width for button
                height: 50, // Set height for button
                color: Colors.blue, // Button color
                child: const Text("Register"), // Button label text
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const Text(
                    "Already Register?"), // Text to indicate forgot password option
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  void onRegisterDialog() {
    // Retrieve the text from email and password controllers
    String email = emailController.text;
    String password = passwordController.text;

    // Check if either email or password is empty
    if (email.isEmpty || password.isEmpty) {
      // Show a SnackBar message if email or password is missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return; // Exit the function if fields are empty
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                userRegistration();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //   content: Text("Registration Canceled"),
                //   backgroundColor: Colors.red,
                // ));
              },
            ),
          ],
        );
      },
    );
    // Send HTTP POST request to login API
  }

  void userRegistration() {
    // Retrieve the text from email and password controllers
    String email = emailController.text;
    String password = passwordController.text;

    // Check if either email or password is empty
    if (email.isEmpty || password.isEmpty) {
      // Show a SnackBar message if email or password is missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return; // Exit the function if fields are empty
    }
    // Send HTTP POST request to login API
    http.post(Uri.parse("http://10.19.5.209/mymemberlink/api/login_user.php"),
        body: {"email": email, "password": password}).then((response) {
      print("masuk");
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          // User user = User.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success"),
            backgroundColor: Color.fromARGB(255, 12, 12, 12),
          ));
          //Navigator.push(context,
          //  MaterialPageRoute(builder: (content) => const MainScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
