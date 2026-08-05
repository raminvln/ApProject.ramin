import 'dart:io';
import 'dart:convert';

class SocketClient {
  static Future<Map<String, dynamic>> send({
    required String method,
    required String username,
    required String route,
    required Map<String, dynamic> payload,
  }) async {
    final socket = await Socket.connect('YOUR_SERVER_IP', 8080);
    final request = jsonEncode({
      'method': method,
      'username': username,
      'route': route,
      'payload': payload,
    });
    socket.write(request);
    socket.write('\n'); 
    final response = await socket.first; 
    socket.destroy();
    return jsonDecode(utf8.decode(response));
  }
  
  static Future<Map<String, dynamic>> register({
  required String username,
  required String password,
}) async {
  return await send(
    method: "POST",
    username: username,
    route: "/register",
    payload: {
      "username": username,
      "password": password,
    },
  );
}
}
