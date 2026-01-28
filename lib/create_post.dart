import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final Dio dio = Dio();
  final caption = TextEditingController();

  File? imageFile;
  bool loading = false;

  Future pickImage() async {
    final picker = ImagePicker();
    final XFile? picked =
    await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future submitPost() async {
    if (imageFile == null || caption.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gambar & caption wajib diisi")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) return;

    setState(() => loading = true);

    FormData formData = FormData.fromMap({
      "user_id": userId,
      "caption": caption.text,
      "image": await MultipartFile.fromFile(
        imageFile!.path,
        filename: imageFile!.path.split('/').last,
      ),
    });

    await dio.post(
      "https://pencarijawabankaisen.my.id/pencari2_wirabuana_api/post_create.php",
      data: formData,
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Postingan")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: pickImage,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade200,
              ),
              child: imageFile == null
                  ? const Center(
                child: Icon(Icons.add_photo_alternate, size: 60),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: caption,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Tulis caption...",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 45,
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Posting"),
            ),
          )
        ],
      ),
    );
  }
}
