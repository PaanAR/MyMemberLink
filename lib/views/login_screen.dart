import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: "Email"),
            ),
            SizedBox(
              height: 10,
            ), // Add const to TextField
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: "Password"),
              obscureText: true,
            ), // Add const to TextField
            Row(
              children: const [
                Text("Remember me"), // Add const to Text
                Checkbox(value: true, onChanged: null), // Add const to Checkbox
              ],
            ),
            MaterialButton(onPressed: onLogin, child: const Text("Login"))
          ]),
        ),
      ),
    );
  }

  void onLogin() {}
}
