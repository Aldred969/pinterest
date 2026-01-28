import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_post.dart';

class MyPostPage extends StatefulWidget {
  const MyPostPage({super.key});

  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  final Dio dio = Dio();
  List posts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    setState(() => loading = true);

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      setState(() => loading = false);
      return;
    }

    final response = await dio.get(
      "https://pencarijawabankaisen.my.id/pencari2_wirabuana_api/user_post_list.php",
      queryParameters: {"user_id": userId},
    );

    setState(() {
      posts = response.data;
      loading = false;
    });
  }

  Future<void> deletePost(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    try {
      final response = await dio.post(
        "https://pencarijawabankaisen.my.id/pencari2_wirabuana_api/post_delete.php",
        data: {
          "id": id,
          "user_id": userId,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.data['status'] == true) {
        loadPosts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Post berhasil dihapus")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menghapus post")),
      );
    }
  }

  Future<void> editPost(int id, String caption) async {
    final c = TextEditingController(text: caption);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Caption"),
        content: TextField(
          controller: c,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final response = await dio.post(
                  "https://pencarijawabankaisen.my.id/pencari2_wirabuana_api/post_update.php",
                  data: {
                    "id": id,
                    "caption": c.text,
                  },
                  options: Options(
                    contentType: Headers.formUrlEncodedContentType,
                  ),
                );

                if (response.data['status'] == true) {
                  Navigator.pop(context);
                  loadPosts();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Post berhasil diupdate")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.data['message'])),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Gagal update post")),
                );
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("My Posts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Buat Post",
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreatePostPage(),
                ),
              );

              if (result == true) {
                loadPosts();
              }
            },
          )
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : posts.isEmpty
          ? const Center(
        child: Text(
          "Belum ada postingan",
          style: TextStyle(fontSize: 16),
        ),
      )
          : RefreshIndicator(
        onRefresh: loadPosts,
        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: posts.length,
          itemBuilder: (context, i) {
            final p = posts[i];

            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    "https://pencarijawabankaisen.my.id/pencari2_wirabuana_api/${p['image']}",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.image)),
                  ),
                ),

                // MENU EDIT & DELETE
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text("Edit"),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text("Delete"),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'delete') {
                          deletePost(int.parse(p['id']));
                        } else {
                          editPost(
                            int.parse(p['id']),
                            p['caption'],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
