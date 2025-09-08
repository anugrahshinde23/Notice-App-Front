import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect(int noticeId) {
    socket = IO.io("https://notice-app-back.onrender.com", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    socket.onDisconnect((_) {
      print("Disconnected from socket");
    });
  }

  void listenForComments(Function(dynamic) onComment) {
    socket.on("newComment", (data) {
      onComment(data);
    });
  }

  void sendComment(Map<String, dynamic> commentData) {
    socket.emit("sendComment", commentData);
  }

  void dispose() {
    socket.disconnect();
  }
}
