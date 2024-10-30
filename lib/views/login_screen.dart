import 'dart:convert'; // Import for JSON encoding and decoding
import 'package:flutter/material.dart'; // Import Flutter material library for UI components
import 'package:shared_preferences/shared_preferences.dart'; // Import for storing data locally
import 'package:http/http.dart' as http; // Import for handling HTTP requests

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
  void initState() {
    // Load saved preferences on widget initialization
    loadPref();
    super.initState();
  }

  // Build method to construct the UI of the LoginScreen
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
                          // If "Remember me" is checked
                          // Check if email and password are provided
                          if (email.isNotEmpty && pass.isNotEmpty) {
                            storeSharedPrefs(
                                value, email, pass); // Save preferences
                          } else {
                            rememberme = false; // Uncheck if fields are empty
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Please Enter Your Credentials"),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 1),
                            ));
                            return;
                          }
                        } else {
                          // If "Remember me" is unchecked
                          email = "";
                          pass = "";
                          storeSharedPrefs(
                              value, email, pass); // Clear preferences
                        }
                        rememberme =
                            value ?? false; // Update "rememberme" state
                        setState(() {}); // Refresh state
                      });
                    },
                  ),
                ],
              ),

              // Button to trigger the login function
              MaterialButton(
                elevation: 10, // Button elevation for shadow effect
                onPressed: onLogin, // Login function called when pressed
                minWidth: 400, // Set minimum width for button
                height: 50, // Set height for button
                color: Colors.blue, // Button color
                child: const Text("Login"), // Button label text
              ),
              const SizedBox(
                  height: 20), // Add vertical spacing below the button

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
    // Send HTTP POST request to login API
    http.post(Uri.parse("http://10.19.5.209/mymemberlink/api/login_user.php"),
        body: {"email": email, "password": password}).then((response) {
      if (response.statusCode == 200) {
        // Check for successful response
        var data = jsonDecode(response.body); // Parse response data
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success"),
            backgroundColor: Colors.green,
          ));
          // Navigate to main page (commented out here)
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  // Function to store email, password, and rememberme state in shared preferences
  Future<void> storeSharedPrefs(bool value, String email, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      // If "Remember me" is checked
      prefs.setString('email', email);
      prefs.setString('pass', pass);
      prefs.setBool('rememberme', value);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Stored"),
        duration: Duration(seconds: 1),
      ));
    } else {
      // If "Remember me" is unchecked, clear stored values
      prefs.setString('email', email);
      prefs.setString('pass', pass);
      prefs.setBool('rememberme', value);
      emailController.text = ""; // Clear email input field
      passwordController.text = ""; // Clear password input field
      setState(() {});
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Removed"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
    }
  }

  // Function to load stored email, password, and rememberme state
  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailController.text = prefs.getString("email")!; // Load email
    passwordController.text = prefs.getString("pass")!; // Load password
    rememberme = prefs.getBool("rememberme")!; // Load "Remember me" state
    setState(() {}); // Update UI with loaded values
  }
}
