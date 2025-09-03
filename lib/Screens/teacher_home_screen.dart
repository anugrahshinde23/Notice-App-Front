import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;

class TeacherHomeScreen extends StatefulWidget {
 
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  List<File> pickedFiles = [];
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  bool isLoading = false;

  Future<void> createNotice() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and content are required")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      var uri = Uri.parse("http://192.168.179.124:1000/notice/create");

      var request = http.MultipartRequest("POST", uri);
      request.fields["title"] = titleController.text;
      request.fields["content"] = contentController.text;
      request.fields["created_by"] = "teacher1"; // 👈 change as per your auth

      if (pickedFiles.isNotEmpty) {
        for (var file in pickedFiles) {
          var stream = http.ByteStream(file.openRead());
          var length = await file.length();
          var multipartFile = http.MultipartFile(
            "file", // 👈 multer.single("file") ke liye
            stream,
            length,
            filename: p.basename(file.path),
          );
          request.files.add(multipartFile);
        }
      }

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Notice created successfully")),
        );
        titleController.clear();
        contentController.clear();
        setState(() {
          pickedFiles.clear();
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed: ${responseBody.body}")));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  pickFile() async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        pickedFiles = result.files.map((file) => File(file.path!)).toList();
      });
    }
  }

  openFile(File file) {
    OpenFile.open(file.path);
  }

  //0XFFBAC095 // background color
  //0XFFD4DE95 // text
  //0XFF3D4127 // headings
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      appBar: AppBar(
        title: const Text(
          "Teacher Panel",
          style: TextStyle(color: Color(0XFFFFFFFF)),
        ),
        backgroundColor: Color(0XFF2B2B2B),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Post a new Notice",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF2B2B2B),
                  ),
                ),
                const SizedBox(height: 20),

                _buildLabel("Enter the Title"),
                _buildTextField(titleController, maxLines: 1),

                const SizedBox(height: 20),

                _buildLabel("Enter the Notice Body"),
                _buildTextField(contentController, maxLines: 8),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: isLoading ? null : createNotice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFF2B2B2B),
                    minimumSize: const Size(320, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Post Notice",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFF2B2B2B),
                    minimumSize: const Size(320, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Select File",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                pickedFiles.isNotEmpty
                    ? SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: pickedFiles.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => openFile(pickedFiles[index]),
                              child: Card(
                                child: ListTile(
                                  leading: returnLogo(pickedFiles[index]),
                                  title: Text(
                                    p.basename(pickedFiles[index].path),
                                  ),
                                  subtitle: Text(
                                    pickedFiles[index].path,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Text("No files selected"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 42),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: TextStyle(color: Color(0XFFB3B3B3))),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {int maxLines = 1}) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Color(0XFFD4D4D4),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }
}

returnLogo(File file) {
  var ex = p.extension(file.path).toLowerCase();

  if (['.jpg', '.jpeg', '.png'].contains(ex)) {
    return const Icon(Icons.image, color: Colors.green);
  } else if (ex == '.pdf') {
    return const Icon(Icons.picture_as_pdf, color: Colors.orange);
  } else if (['.mp4', '.mkv'].contains(ex)) {
    return const Icon(Icons.movie, color: Colors.red);
  } else if (['.mp3', '.wav'].contains(ex)) {
    return const Icon(Icons.music_note, color: Colors.purple);
  } else {
    return const Icon(Icons.insert_drive_file, color: Colors.grey);
  }
}
