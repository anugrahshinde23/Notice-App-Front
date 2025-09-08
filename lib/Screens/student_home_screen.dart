import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:notify/Screens/comment_screen.dart';
import 'package:notify/Screens/notice_detail_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  final String collegeId;
  final String classId;
  final String studentName;
  final int studentId;
  const StudentHomeScreen({
    super.key,
    required this.collegeId,
    required this.classId,
    required this.studentName,
    required this.studentId,
  });

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  // 🔥 Function to open full screen zoomable image
  void openImageViewer(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(imageUrl),
            ),
          ),
        ),
      ),
    );
  }

  List<dynamic> notices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotices(); // ✅ Call here
  }

  Future<void> fetchNotices() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://notice-app-back.onrender.com/notice/get/${widget.collegeId}/${widget.classId}/${widget.studentId}",
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          notices = data["allnotice"]; // ✅ Correct key
          isLoading = false;
        });
      } else {
        throw Exception("Failed to Load Notices");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching notices $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notices.isEmpty
          ? const Center(child: Text("No notices yet"))
          : ListView.builder(
              itemCount: notices.length,
              itemBuilder: (context, index) {
                final notice = notices[index];
                String? filePath = notice["file_path"];

                if (filePath != null && filePath.isNotEmpty) {
                  filePath = filePath.replaceAll("\\", "/");
                  if (filePath.contains("/")) {
                    filePath = filePath.split("/").last;
                  }
                }

                String category = notice['category'];
                String content = notice['content']?.toString() ?? "No Content";

                final imageUrl = (filePath != null && filePath.isNotEmpty)
                    ? "https://notice-app-back.onrender.com/uploads/$filePath"
                    : null;

                return Card(
                  color: Color(0XFFD4D4D4),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: notice['is_read'] == true
                          ? Colors.grey
                          : Colors.blue,
                      width: 2,
                    ),
                  ),
                  elevation: 5,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      await http.post(
                        Uri.parse("https://notice-app-back.onrender.com/notice/mark-read"),
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode({
                          "noticeId": notice['id'],
                          "studentId": widget.studentId,
                        }),
                      );
                      setState(() {
                        notice["is_read"] = true;
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NoticeDetailScreen(notice: notice),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20), // ✅ fixed
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              notice["is_read"] == true ? Icon(Icons.check_circle, color: Colors.grey, size: 18,) : Icon(Icons.fiber_manual_record, color: Colors.blue,size: 14,),
                              SizedBox(height: 5,),
                              
                             Text(
                                "@${notice["teacher_name"] ?? "unknown"}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0XFFB3B3B3),
                                ),
                              ),
                              Text(
                                notice["created_at"] != null
                                    ? DateFormat('dd MMM yyyy, hh:mm a').format(
                                        DateTime.parse(notice["created_at"]),
                                      )
                                    : "unknow date",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0XFFB3B3B3),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            notice["title"] ?? "No title",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 5),

                          Text(
                            content.length > 50
                                ? "${content.substring(0, 50)}..."
                                : content,
                            style: TextStyle(),
                          ),
                          if (imageUrl != null) // ✅ fixed
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: GestureDetector(
                                  onTap: () => openImageViewer(imageUrl),
                                  child: Image.network(
                                    imageUrl,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Text("Image not available"),
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CommentScreen(
                                        noticeId: notice['id'],
                                        userId: widget.studentId,
                                        userType: widget.studentName,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.comment),
                              ),

                              Text(
                                category,
                                style: TextStyle(
                                  color: category == "General"
                                      ? Colors.grey
                                      : category == "Alert"
                                      ? Colors.orange
                                      : category == "Event"
                                      ? Colors.green
                                      : category == "Assignment"
                                      ? Colors.blue
                                      : category == "Exam"
                                      ? Colors.red
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
