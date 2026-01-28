import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'comment.dart';
import 'mypost.dart';
import 'profile.dart';
import 'create_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Dio dio = Dio();

  List posts = [];
  bool loading = true;
  int currentIndex = 0;

  String nama = ""; // ✅ NAMA USER LOGIN

  static const primaryColor = Colors.redAccent;

  @override
  void initState() {
    super.initState();
    loadUser();
    loadPosts();
  }

  // 🔹 AMBIL DATA USER LOGIN
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? "User";
    });
  }

  // 🔹 LOAD POST
  Future<void> loadPosts() async {
    setState(() => loading = true);
    try {
      final response = await dio.get(
        "https://pencarijawabankaisen.my.id/pencari2_wirabuana_api/post_list.php",
      );
      setState(() {
        posts = response.data;
        loading = false;
      });
    } catch (_) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // 🔴 APPBAR
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        title: const Text(
          "Pinterest Aja",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      // ➕ FLOAT BUTTON
      floatingActionButton: Transform.translate(
        offset: const Offset(0, -35),
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          elevation: 8,
          child: const Icon(Icons.add, size: 28),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreatePostPage()),
            );
            if (result == true) loadPosts();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 🔻 BOTTOM NAVBAR
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navItem(Icons.home_rounded, "Home", 0),
              navItem(Icons.collections_bookmark, "My Post", 1),
              navItem(Icons.person_rounded, "Profile", 2),
            ],
          ),
        ),
      ),

      // 📌 BODY
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: loadPosts,
        child: CustomScrollView(
          slivers: [
            // SharedPref
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Selamat datang, $nama ",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 🧩 GRID POST
            SliverPadding(
              padding:
              const EdgeInsets.fromLTRB(12, 8, 12, 90),
              sliver: SliverGrid(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, i) => postCard(posts[i]),
                  childCount: posts.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🖼️ CARD POST
  Widget postCard(dynamic p) {
    final imageUrl =
        "https://pencarijawabankaisen.my.id/pencari2_wirabuana_api/${p['image']}";

    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CommentPage(
                postId: int.parse(p['id']),
                imageUrl: imageUrl,
                caption: p['caption'],
              ),
            ),
          );
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder.png',
                image: imageUrl,
                fit: BoxFit.cover,
                imageErrorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 40),
              ),
            ),

            // CAPTION
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Text(
                  p['caption'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 NAV ITEM
  Widget navItem(IconData icon, String label, int index) {
    final active = currentIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        setState(() => currentIndex = index);

        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MyPostPage()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: active ? primaryColor : Colors.grey.shade500,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                color: active ? primaryColor : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
