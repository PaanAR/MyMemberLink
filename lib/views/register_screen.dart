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
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // Assign the form key to enable validation
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTextField(
                  controller: nameController,
                  hintText: "Name",
                  validator: (val) => val!.isEmpty || val.length < 3
                      ? "Name must be longer than 3 characters"
                      : null,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: emailController,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) =>
                      val!.isEmpty || !val.contains('@') || !val.contains('.')
                          ? "Enter a valid email"
                          : null,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: phoneNumController,
                  hintText: "Phone Number",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                _buildPasswordField(
                  controller: passwordController,
                  hintText: "Password",
                  isPasswordVisible: _isPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _buildPasswordField(
                  controller: password2Controller,
                  hintText: "Re-enter Password",
                  isPasswordVisible: _isPassword2Visible,
                  onToggleVisibility: () {
                    setState(() {
                      _isPassword2Visible = !_isPassword2Visible;
                    });
                  },
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  elevation: 8,
                  onPressed: _registerUserDialog,
                  minWidth: double.infinity,
                  height: 50,
                  color: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Colors.black87, fontSize: 18),
                  ),
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
                    "Already Registered? Login",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade600),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isPasswordVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        suffixIcon: GestureDetector(
          onTap: onToggleVisibility,
          child: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey.shade600,
          ),
        ),
      ),
      validator: validatePassword,
    );
  }

  String? validatePassword(String? value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    } else if (!regex.hasMatch(value)) {
      return 'Password must be at least 6 characters, include uppercase, lowercase, and a number';
    }
    return null;
  }

  void _registerUserDialog() {
    String pass1 = passwordController.text;
    String pass2 = password2Controller.text;

    if (pass1 != pass2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords do not match!"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Register new account?"),
          content: const Text("Are you sure?"),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                _registerUser();
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _registerUser() {
    String name = nameController.text;
    String email = emailController.text;
    String phoneNum = phoneNumController.text;
    String password = passwordController.text;

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
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Success"),
            backgroundColor: Colors.green,
          ));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
