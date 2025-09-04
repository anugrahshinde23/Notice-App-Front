import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String baseURL = "http://10.46.74.71:1000";

  // authRoutes :
  // 1. register
  static Future<Map<String, dynamic>> register(
    String name,
    String role,
    String password,
  ) async {
    final url = Uri.parse("$baseURL/api/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "role": role, "password": password}),
    );

    return jsonDecode(response.body);
  }

  // 2. login
  static Future<Map<String, dynamic>> login(
    String name,
    String password,
  ) async {
    final url = Uri.parse("$baseURL/api/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "password": password}),
    );

    return jsonDecode(response.body);
  }

  // static Future<Map<String, dynamic>> createNotice(
  //   String title,
  //   String content,
  // ) async {
  //   final url = Uri.parse('$baseURL/notice/create');
  //   final response = await http.post(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({"title": title, "content": content}),
  //   );
  //   return jsonDecode(response.body);
  // }

//    Future<List<dynamic>> fetchNotices() async {
//   final response = await http.get(Uri.parse("$baseURL/notice/get"));

//   if (response.statusCode == 200) {
//     final Map<String, dynamic> data = jsonDecode(response.body);

//     // yaha se sirf "allnotice" list nikalo
//     return data["allnotice"];
//   } else {
//     throw Exception("Failed to fetch notices");
//   }
// }

}
