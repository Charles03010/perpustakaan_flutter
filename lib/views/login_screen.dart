import 'package:flutter/material.dart';
import 'admin_screen.dart'; // Halaman Admin
import 'book_list_screen.dart'; // Halaman untuk pengguna biasa

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Hardcoded admin credentials (for demo purposes)
  final String adminUsername = 'admin';
  final String adminPassword = 'admin123';

  void _login() {
    // Check if username and password are correct
    if (_usernameController.text == adminUsername &&
        _passwordController.text == adminPassword) {
      // Navigate to AdminScreen if admin
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminScreen()),
      );
    } else {
      // Show error if credentials are incorrect
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau password salah!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // If user is not an admin, go to book list
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BookListScreen()),
                );
              },
              child: const Text('Lanjutkan sebagai Pengguna'),
            ),
          ],
        ),
      ),
    );
  }
}
