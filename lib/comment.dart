import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentPage extends StatefulWidget {
  final int postId;
  final String imageUrl;
  final String caption;

  const CommentPage({
    super.key,
    required this.postId,
    required this.imageUrl,
    required this.caption,
  });

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final Dio dio = Dio();
  final TextEditingController commentController = TextEditingController();

  List comments = [];
  bool loading = true;
  int? myUserId;

  @override
  void initState() {
    super.initState();
    loadUser();
    loadComments();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    myUserId = prefs.getInt('user_id');
  }

  Future<void> loadComments() async {
    try {
      final res = await dio.get(
        "https://pencarijawabankaisen.my.id/pencari2_wirabuana_api/comment_list.php",
        queryParameters: {
          "post_id": widget.postId,
        },
      );

      setState(() {
        comments = res.data;
        loading = false;
      });
    } catch (_) {
      setState(() => loading = false);
    }
  }

  Future<void> sendComment() async {
    if (commentController.text.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) return;

    await dio.post(
      "https://pencarijawabankaisen.my.id/pencari2_wirabuana_api/comment_create.php",
      data: {
        "post_id": widget.postId,
        "user_id": userId,
        "comment": commentController.text.trim(),
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    commentController.clear();
    loadComments();
  }

  Future<void> deleteComment(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    await dio.post(
      "https://pencarijawabankaisen.my.id/pencari2_wirabuana_api/comment_delete.php",
      data: {
        "id": id,
        "user_id": userId,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    loadComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Komentar")),
      body: Column(
        children: [
          // GAMBAR FULL Size
          Container(
            width: double.infinity,
            color: Colors.black,
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                const Center(child: Icon(Icons.image, size: 60)),
              ),
            ),
          ),

          // PREVIEW CAPTION
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Text(
              widget.caption,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const Divider(height: 1),

          // LIST KOMENTAR
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : comments.isEmpty
                ? const Center(child: Text("Belum ada komentar"))
                : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final c = comments[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(
                      c['nama'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(c['comment']),
                    trailing: myUserId == c['user_id']
                        ? IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.red),
                      onPressed: () {
                        deleteComment(
                            int.parse(c['id']));
                      },
                    )
                        : null,
                  ),
                );
              },
            ),
          ),

          // INPUT KOMENTAR
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: "Tulis komentar...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send,
                        color: Colors.redAccent),
                    onPressed: sendComment,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
