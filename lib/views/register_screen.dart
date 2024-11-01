import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mymemberlink/myconfig.dart';
import 'package:mymemberlink/views/login_screen.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers for the input fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Global key to validate the form

  bool _isPasswordVisible = false; // Visibility state for password 1
  bool _isPassword2Visible = false; // Visibility state for password 2

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey, // Assign the form key to enable validation
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Name input field
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Name",
                  ),
                  // Validates that name is at least 3 characters long
                  validator: (val) => val!.isEmpty || val.length < 3
                      ? "Name must be longer than 3 characters"
                      : null,
                ),
                const SizedBox(height: 10),

                // Email input field
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Email",
                  ),
                  // Basic email validation
                  validator: (val) =>
                      val!.isEmpty || !val.contains('@') || !val.contains('.')
                          ? "Enter a valid email"
                          : null,
                ),
                const SizedBox(height: 10),

                // Phone number input field
                TextFormField(
                  controller: phoneNumController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Phone Number",
                  ),
                ),
                const SizedBox(height: 10),

                // Password input field with visibility toggle
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Password",
                    // Eye icon to toggle password visibility
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      child: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText:
                      !_isPasswordVisible, // Controls password visibility
                  validator: (val) =>
                      validatePassword(val ?? ''), // Password validation
                ),
                const SizedBox(height: 10),

                // Confirm password input field with visibility toggle
                TextFormField(
                  controller: password2Controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Re-enter Password",
                    // Eye icon to toggle confirm password visibility
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPassword2Visible = !_isPassword2Visible;
                        });
                      },
                      child: Icon(
                        _isPassword2Visible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText:
                      !_isPassword2Visible, // Controls password visibility
                  validator: (val) =>
                      validatePassword(val ?? ''), // Password validation
                ),

                const SizedBox(height: 20),

                // Register button that triggers registration dialog
                MaterialButton(
                  elevation: 10,
                  onPressed: _registerUserDialog,
                  minWidth: 400,
                  height: 50,
                  color: Colors.blue,
                  child: const Text("Register"),
                ),

                const SizedBox(height: 20),

                // Link to navigate to the login screen
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text("Already Register?"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to validate password strength
  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else if (!regex.hasMatch(value)) {
      return 'Password must be at least 6 characters and include an uppercase letter, lowercase letter, and a number';
    } else {
      return null;
    }
  }

  // Dialog to confirm registration and validate form
  void _registerUserDialog() {
    String pass1 = passwordController.text;
    String pass2 = password2Controller.text;

    // Check if passwords match
    if (pass1 != pass2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords do not match!"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
      return;
    }

    // Validate the form inputs
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show confirmation dialog for registration
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text("Register new account?", style: TextStyle()),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            // Button to confirm registration
            TextButton(
              child: const Text("Yes", style: TextStyle()),
              onPressed: () {
                Navigator.of(context).pop();
                _registerUser();
              },
            ),
            // Button to cancel registration
            TextButton(
              child: const Text("No", style: TextStyle()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to register user by sending data to the server
  void _registerUser() {
    String name = nameController.text;
    String email = emailController.text;
    String phoneNum = phoneNumController.text;
    String password = passwordController.text;

    // HTTP POST request to register user
    http.post(
        Uri.parse("${MyConfig.servername}/mymemberlink/api/register_user.php"),
        body: {
          "name": name,
          "email": email,
          "phoneNum": phoneNum,
          "password": password
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // Registration success
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Success"),
            backgroundColor: Colors.green,
          ));
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => const LoginScreen()));
        } else {
          // Registration failed
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
