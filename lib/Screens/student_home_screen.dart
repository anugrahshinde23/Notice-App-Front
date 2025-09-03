import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentHomeScreen extends StatefulWidget {
  
  const StudentHomeScreen({super.key});

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
        Uri.parse("http://192.168.179.124:1000/notice/get"),
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

                    final imageUrl = (filePath != null && filePath.isNotEmpty)
                        ? "http://192.168.179.124:1000/uploads/$filePath"
                        : null;

                    return Card(
                      color: const Color(0XFFD4D4D4),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10), // ✅ fixed
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notice["title"] ?? "No title",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(notice['content'] ?? "No Content"),
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
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
