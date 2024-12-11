import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 150), // Add logo
                SizedBox(height: 16),
                Text(
                  'Welcome to Cocktail Explorer',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;

                    if (email == 'hyw@gmail.com' && password == 'password123') {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Invalid email or password'),
                        ),
                      );
                    }
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Add sign-up navigation
                  },
                  child: Text('Don\'t have an account? Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
