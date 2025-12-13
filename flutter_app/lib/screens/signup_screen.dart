import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _message;

  void _signup() async {
    setState(() { _loading = true; _message = null; });
    final res = await ApiService.post('/api/auth/signup', {
      'email': _email.text.trim(),
      'username': _username.text.trim(),
      'password': _password.text.trim()
    });
    setState(() { _loading = false; });
    if (res['status'] == 201) {
      setState(() { _message = 'Account created. Please login.'; });
    } else {
      setState(() {
        _message = res['body'] != null && res['body']['error'] != null ? res['body']['error'].toString() : 'Signup failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _email, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _username, decoration: InputDecoration(labelText: "Username")),
            TextField(controller: _password, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 12),
            if (_message != null) Text(_message!),
            ElevatedButton(onPressed: _loading ? null : _signup, child: _loading ? CircularProgressIndicator() : Text("Signup")),
          ],
        ),
      ),
    );
  }
}
