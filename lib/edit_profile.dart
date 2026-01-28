import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Dio dio = Dio();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  // LOAD DATA DARI SHARED PREFERENCES
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('nama') ?? "";
      bioController.text = prefs.getString('bio') ?? "";
    });
  }

  // 🔔 DIALOG KONFIRMASI
  Future<void> showConfirmDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text(
          "Apakah Anda yakin ingin menyimpan perubahan profil?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Ya, Simpan"),
          ),
        ],
      ),
    );

    if (result == true) {
      saveProfile();
    }
  }

  // SIMPAN PERUBAHAN KE SERVER
  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama tidak boleh kosong")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User belum login")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await dio.post(
        "https://pencarijawabankaisen.my.id/pencari2_wirabuana_api/profile_update.php",
        data: {
          "user_id": userId,
          "nama": nameController.text.trim(),
          "bio": bioController.text.trim(),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.data['status'] == true) {
        // UPDATE SHARED PREFERENCES
        await prefs.setString('nama', nameController.text.trim());
        await prefs.setString('bio', bioController.text.trim());

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil berhasil diperbarui")),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data['message'] ?? "Gagal menyimpan data"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server tidak dapat diakses")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // AVATAR
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),

            const SizedBox(height: 20),

            // NAMA
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 15),

            // BIO
            TextField(
              controller: bioController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Bio",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.info_outline),
              ),
            ),

            const SizedBox(height: 25),

            // SIMPAN
            SizedBox(
              width: double.infinity,
              height: 45,
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: showConfirmDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
