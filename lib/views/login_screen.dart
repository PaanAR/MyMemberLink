import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          const TextField(), // Add const to TextField
          const TextField(), // Add const to TextField
          Row(
            children: const [
              Text("Remember me"), // Add const to Text
              Checkbox(value: true, onChanged: null), // Add const to Checkbox
            ],
          ),
          MaterialButton(onPressed: onLogin, child: Text("Login"))
        ]),
      ),
    );
  }

  void onLogin() {}
}
