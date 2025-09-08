import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:notify/Screens/comment_screen.dart';
import 'package:notify/Services/api_services.dart';

class NoticeScreen extends StatefulWidget {
  final String collegeId;
  final String classId;
  final int? teacherId;
  final String? teacherName;

  const NoticeScreen({
    super.key,
    required this.collegeId,
    required this.classId,
    required this.teacherId,
    required this.teacherName,
  });

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  List<dynamic> notices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // print(widget.classId);
    // print(widget.collegeId);
    fetchNotices();
    // print(widget.teacherId);
    // print(widget.teacherName);
  }

  void _deleteNotice(int id) async {
    final success = await ApiServices.deleteNotice(id);
    if (success) {
      setState(() {
        notices.removeWhere((n) => n['id'] == id);
      });
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Notice deleted")));
  }

  void _editNotice(int id, String oldTitle, String oldContent) async {
    TextEditingController titleController = TextEditingController(
      text: oldTitle,
    );
    TextEditingController contentController = TextEditingController(
      text: oldContent,
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0XFFFFFFFF),
        title: Text(
          "Edit Notice",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: "Content"),
            ),
          ],
        ),

        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color(0XFF2B2B2B)),
            ),
            onPressed: () async {
              final success = await ApiServices.editNotice(
                id,
                titleController.text,
                contentController.text,
              );
              if (success) {
                setState(() {
                  final index = notices.indexWhere((n) => n['id'] == id);
                  notices[index]['title'] = titleController.text;
                  notices[index]['content'] = contentController.text;
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Notice updated")));
              }
            },
            child: Text("save", style: TextStyle(color: Color(0XFFFFFFFF))),
          ),
        ],
      ),
    );
  }

  Future<void> fetchNotices() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://notice-app-back.onrender.com/notice/get/${widget.collegeId}/${widget.classId}/${widget.teacherId}",
        ),
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
        title: const Text(
          "All Notices",
          style: TextStyle(color: Color(0XFFFFFFFF)),
        ),
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
                String category = notice['category'];
                final imageUrl = (filePath != null && filePath.isNotEmpty)
                    ? "https://notice-app-back.onrender.com/uploads/$filePath"
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
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category,
                              style: TextStyle(
                                color: category == "Exam"
                                    ? Colors.red
                                    : category == "Assignment"
                                    ? Colors.blue
                                    : category == "Event"
                                    ? Colors.green
                                    : category == "Alert"
                                    ? Colors.orange
                                    : category == "General"
                                    ? Colors.grey
                                    : null,
                              ),
                            ),
                            Text(
                              "Date: ${notice["created_at"] != null ? DateFormat('dd MMM yyy, hh:mm a').format(DateTime.parse(notice["created_at"])) : "unknown date"}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0XFFB3B3B3),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
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
                              errorBuilder: (context, error, stackTrace) =>
                                  const Text("Image not available"),
                            ),
                          ),

                        Row(
                          
                          spacing: 15,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _editNotice(
                                  notice['id'],
                                  notice['title'],
                                  notice['content'],
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Color(0XFF2B2B2B),
                                ),
                                minimumSize: WidgetStatePropertyAll(
                                  Size(10, 30),
                                ),
                              ),
                              child: Text(
                                "Edit",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _deleteNotice(notice['id']);
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Color(0XFFFFFFFF),
                                ),
                                minimumSize: WidgetStatePropertyAll(
                                  Size(10, 30),
                                ),
                              ),
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            SizedBox(width: 59,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                 IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CommentScreen(
                                        noticeId: notice['id'],
                                        userId: widget.teacherId,
                                        userType: widget.teacherName,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.comment),
                              ),
                              ],
                            )
                          ],
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
