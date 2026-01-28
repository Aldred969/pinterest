import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'login.dart';
import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Dio dio = Dio();

  String nama = "User";
  String bio = "Belum ada bio";
  int userId = 0;

  List posts = [];
  bool loadingPost = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  // ================= LOAD USER =================
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id') ?? 0;

    if (userId == 0) return;

    setState(() {
      nama = prefs.getString('nama') ?? "User";
      bio = prefs.getString('bio') ?? "Belum ada bio";
    });

    await loadMyPost();
  }

  // ================= LOAD MY POST =================
  Future<void> loadMyPost() async {
    try {
      final res = await dio.get(
        "https://pencarijawabankaisen.my.id/pencari2_wirabuana_api/user_post_list.php",
        queryParameters: {
          "user_id": userId,
        },
      );

      setState(() {
        posts = res.data;
        loadingPost = false;
      });
    } catch (e) {
      setState(() => loadingPost = false);
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 30),

                Column(
                  children: [
                    Text(
                      posts.length.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text("Posts"),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // NAMa & BIO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bio,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // BUTTON Edit
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfilePage(),
                    ),
                  );
                  loadUser();
                },
                child: const Text("Edit Profile"),
              ),
            ),
          ),

          const Divider(height: 30),

          //  GRID POST
          Expanded(
            child: loadingPost
                ? const Center(child: CircularProgressIndicator())
                : posts.isEmpty
                ? const Center(child: Text("Belum ada post"))
                : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    "https://pencarijawabankaisen.my.id/pencari2_wirabuana_api/${post['image']}",
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.image)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
