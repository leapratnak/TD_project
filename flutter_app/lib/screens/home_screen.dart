import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final res = await ApiService.getAuth('/api/auth/profile');
    if (res['status'] == 200 && res['body'] != null) {
      setState(() => _profile = res['body']['user']);
    } else {
      await ApiService.logout();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  void _logout() async {
    await ApiService.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final username = _profile?['username'] ?? _profile?['Username'] ?? 'user';
    final email = _profile?['email'] ?? _profile?['Email'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: _logout
          )
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.deepPurple,
                  child: Text(
                    username[0].toUpperCase(),
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Welcome, $username!",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.email, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Text(email, style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 30),

                // ⭐ Go to Category Button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, "/category");
                  },
                  icon: const Icon(Icons.category, color: Colors.white),
                  label: const Text("Go to Category",style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                const SizedBox(height: 10),

                // ⭐ Go to Product Button (NEW)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, "/product");
                  },
                  icon: const Icon(Icons.shopping_bag, color: Colors.white),
                  label: const Text("Go to Product",style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                const SizedBox(height: 20),

                // ⭐ Logout Button
                ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("Logout",style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
