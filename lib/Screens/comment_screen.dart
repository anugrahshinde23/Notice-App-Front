import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notify/Services/commet_service.dart';
import 'package:notify/Services/socket_service.dart';

class CommentScreen extends StatefulWidget {
  final int noticeId;
  final int? userId;
  final String? userType;
  const CommentScreen({
    super.key,
    required this.noticeId,
    required this.userId,
    required this.userType,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final CommetService _commentService = CommetService();
  final SocketService _socketService = SocketService();

  final TextEditingController _controller = TextEditingController();
  List<dynamic> _comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
    _socketService.connect(widget.noticeId);
    _socketService.listenForComments((data) {
      setState(() {
        _comments.add(data);
      });
    });
  }

  Future<void> _loadComments() async {
    final data = await _commentService.fetchComments(widget.noticeId);
    setState(() {
      _comments = data;
    });
  }

  Future<void> sendComments() async {
    if (_controller.text.isEmpty) {
      return;
    }

    final commentData = {
      "notice_id": widget.noticeId,
      "user_id": widget.userId,
      "user_type": widget.userType,
      "comment": _controller.text,
      "parent_comment_id": null,
    };

    await _commentService.postComment(commentData);

    _controller.clear();
  }

  @override
  void dispose() {
    _socketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      appBar: AppBar(
        title: Text('Comments', style: TextStyle(color: Color(0XFFFFFFFF))),
        backgroundColor: Color(0XFF2B2B2B),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Color(0XFFFFFFFF)),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey, // 👈 border color
                      width: 0.5, // 👈 border width
                    ),
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // 👈 rounded corners
                  ),
                  child: ListTile(
                    title: Text(comment["comment"]),
                    subtitle: Text(
                      comment["created_at"] != null
                          ? DateFormat(
                              'dd MMM yyy, hh:mm a',
                            ).format(DateTime.parse(comment["created_at"]))
                          : "unknown date",
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: Text(comment["user_type"]),
                  ),
                );
              },
            ),
          ),

          Container(
            color: Color(0XFF2B2B2B),
            child: Padding(
              padding: EdgeInsets.all(20),
            
              child: Row(
                children: [
                  Expanded(
                    
                    child: TextField(
                      controller: _controller,
                      decoration:  InputDecoration(
                        hintText: "Write a comment...",
                        hintStyle: TextStyle(color: Color(0XFFFFFFFF)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0XFFD4D4D4), width: 0.5)
                        ),
                        border: InputBorder.none,
                        
                      ),
                      style: TextStyle(color: Color(0XFFFFFFFF)),
                    ),
                  ),
                  IconButton(onPressed: sendComments, icon: Icon(Icons.send_rounded), color: Color(0XFFFFFFFF),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
