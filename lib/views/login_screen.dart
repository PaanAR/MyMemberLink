import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Boolean variable to keep track of "Remember me" checkbox state
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
                keyboardType: TextInputType.emailAddress,
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
                  // Checkbox with a change handler to update "rememberme" state
                  Checkbox(
                    value: rememberme, // Current state of the checkbox
                    onChanged: (bool? value) {
                      setState(() {
                        String email = emailController.text;
                        String pass = passwordController.text;
                        if (value!) {
                          print("Yes");
                          if (email.isNotEmpty && pass.isNotEmpty) {
                            storeSharedPrefs(value, email, pass);
                          } else {
                            rememberme = false;
                            setState(() {}); // Update "rememberme" state
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Please Enter Your Credentials"),
                              backgroundColor: Colors.red,
                            ));
                            return;
                          }
                        } else {
                          print("NAY");
                          email = "";
                          pass = "";
                          storeSharedPrefs(value, email, pass);
                        }
                        rememberme = value ?? false;
                        setState(() {}); // Update "rememberme" state
                      });
                    },
                  ),
                ],
              ),

              // Button to trigger the login function
              MaterialButton(
                elevation: 10,
                onPressed: onLogin, // Login function called when pressed
                minWidth: 400, // Set minimum width for button
                height: 50, // Set height for button
                color: Colors.blue, // Button color
                child: const Text("Login"), // Button label text
              ),

              // Add vertical spacing below the button
              const SizedBox(
                height: 20,
              ),

              // GestureDetector to handle tap events on "Forgot Password?" text
              GestureDetector(
                child: const Text(
                    "Forgot Password?"), // Text to indicate forgot password option
              )
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle login action
  void onLogin() {
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
  }

  Future<void> storeSharedPrefs(bool value, String email, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      prefs.setString('email', email);
      prefs.setString('pass', pass);
      prefs.setBool('rememberme', value);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Stored"),
        duration: Duration(seconds: 1),
      ));
    } else {
      prefs.setString('email', email);
      prefs.setString('pass', pass);
      prefs.setBool('rememberme', value);
      emailController.text = "";
      passwordController.text = "";
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Removed"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
    }
  }
}
