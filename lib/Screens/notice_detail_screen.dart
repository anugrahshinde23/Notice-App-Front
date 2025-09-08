import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoticeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> notice;
  final String? imageUrl;

  const NoticeDetailScreen({super.key, required this.notice, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    String category = notice['category'] ?? "General";

    return Scaffold(
      appBar: AppBar(
        title: Text(notice["title"] ?? "Notice"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teacher and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "@${notice["teacher_name"] ?? "unknown"}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0XFFB3B3B3),
                  ),
                ),
                Text(
                  notice["created_at"] != null
                      ? DateFormat('dd MMM yyyy, hh:mm a').format(
                          DateTime.parse(notice["created_at"]),
                        )
                      : "Unknown date",
                  style: const TextStyle(fontSize: 12, color: Color(0XFFB3B3B3)),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Title
            Text(
              notice["title"] ?? "No title",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 10),

            // Category
            Text(
              category,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
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

            const SizedBox(height: 20),

            // Content
            Text(
              notice['content'] ?? "No Content",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Image (zoomable)
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Text("Image not available"),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
