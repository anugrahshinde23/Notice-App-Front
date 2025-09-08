import 'dart:convert';
import 'package:http/http.dart' as http;

class CommetService {
  final String baseUrl = "https://notice-app-back.onrender.com";

  Future<List<dynamic>> fetchComments(int noticeId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/cmt/comments/$noticeId"),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed fetch the comments");
    }
  }

  Future<Map<String, dynamic>> postComment(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/cmt/comments"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to Post Comment");
    }
  }
}
