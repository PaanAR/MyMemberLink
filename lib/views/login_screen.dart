import 'package:flutter/material.dart';

// Define a stateful widget for the LoginScreen
class LoginScreen extends StatefulWidget {
  // Constructor for the LoginScreen widget, marked as constant
  const LoginScreen({super.key});

  // Create the state for the LoginScreen widget
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Define the state class for the LoginScreen
class _LoginScreenState extends State<LoginScreen> {
  // Controller for the email input field
  TextEditingController emailController = TextEditingController();
  // Controller for the password input field
  TextEditingController passwordController = TextEditingController();

  bool rememberme = false;
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
                controller: emailController, // Assign the email controller
                decoration: const InputDecoration(
                  // Outline border with rounded corners
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: "Email", // Placeholder text for email
                ),
              ),
              // Add vertical spacing between widgets
              const SizedBox(
                height: 10,
              ), // SizedBox widget to create spacing

              // Text field for password input
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
                obscureText: true, // Hide text input for password
              ),

              // Row widget to place "Remember me" text and checkbox horizontally
              Row(
                children: [
                  // Label text for "Remember me" option
                  const Text("Remember me"),
                  // Checkbox with fixed true value and no change handler
                  Checkbox(
                      value: rememberme,
                      onChanged: (bool? value) {
                        setState(() {
                          rememberme = value ?? false;
                        });
                      }),
                ],
              ),

              // Button to trigger the login function
              MaterialButton(
                onPressed: onLogin,
                minWidth: 400,
                height: 50,
                color: Colors.blue, // Login function called when pressed
                child: const Text("Login"), // Button label text
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: const Text("Forgot Password?"),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle login action
  void onLogin() {
    String email = emailController.text;
    String password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter email and password")));
      return;
    }
  }
}
