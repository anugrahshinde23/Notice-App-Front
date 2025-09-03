import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  List<dynamic> notices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotices();
  }

  Future<void> fetchNotices() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.179.124:1000/notice/get"),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          notices = data["allnotice"];
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load notices");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching notices: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      appBar: AppBar(
        title: const Text("All Notices",style: TextStyle(color: Color(0XFFFFFFFF)),),
        backgroundColor: Color(0XFF2B2B2B),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notices.isEmpty
              ? const Center(child: Text("No notices available"))
              : ListView.builder(
                  itemCount: notices.length,
                  itemBuilder: (context, index) {
                    final notice = notices[index];
                    String? filePath = notice["file_path"];

                    // 🔥 Normalize file path
                    if (filePath != null && filePath.isNotEmpty) {
                      filePath = filePath.replaceAll("\\", "/"); // windows fix
                      if (filePath.contains("/")) {
                        // sirf filename lo
                        filePath = filePath.split("/").last;
                      }
                    }

                    final imageUrl = (filePath != null && filePath.isNotEmpty)
                        ? "http://192.168.179.124:1000/uploads/$filePath"
                        : null;

                    return Card(
                      color: Color(0XFFD4D4D4),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notice["title"] ?? "No Title",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(notice["content"] ?? "No Content"),
                            const SizedBox(height: 10),

                            // 👇 image preview
                            if (imageUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                              
                                child: Image.network(
                                  imageUrl,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Text("Image not available"),
                                ),
                              ),

                            const SizedBox(height: 10),
                            Text(
                              "Date: ${notice["created_at"]}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0XFFB3B3B3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
