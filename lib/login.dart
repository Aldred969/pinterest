import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.plain,
    ),
  );

  bool loading = false;

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  // ================= LOGIN =================
  Future<void> doLogin() async {
    if (username.text.trim().isEmpty || password.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username dan password wajib diisi")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await dio.post(
        "https://pencarijawabankaisen.my.id/pencari2_wirabuana_api/login.php",
        data: {
          "username": username.text.trim(),
          "password": password.text.trim(),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      // 🔑 PARSE JSON STRING
      final Map<String, dynamic> data = jsonDecode(response.data);

      if (data['status'] == true) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setBool('isLogin', true);
        await prefs.setInt(
          'user_id',
          int.parse(data['user_id'].toString()),
        );
        await prefs.setString('nama', data['nama']);
        await prefs.setString('bio', data['bio'] ?? "");

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "Login gagal"),
          ),
        );
      }
    } catch (e) {
      debugPrint("LOGIN ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server tidak dapat diakses")),
      );
    }

    setState(() => loading = false);
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // LOGO
              Image.asset(
                "assets/images/pinterest_logo.png",
                height: 120,
              ),

              const SizedBox(height: 16),

              const Text(
                "Selamat Datang",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Masuk ke akun Pinterest kamu",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              // USERNAME
              TextField(
                controller: username,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // PASSWORD
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : doLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Login",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // REGISTER
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterPage(),
                    ),
                  );
                },
                child: const Text(
                  "Belum punya akun? Daftar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
