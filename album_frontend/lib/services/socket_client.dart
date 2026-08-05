import 'dart:io';
import 'dart:convert';

class SocketClient {
  static Future<Map<String, dynamic>> send({
    required String method,
    required String userName,
    required String route,
    required Map<String, dynamic> payload,
  }) async {
    final socket = await Socket.connect('YOUR_SERVER_IP', 8080);
    final request = jsonEncode({
      'method': method,
      'userName': userName,
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
    userName: username,
    route: "/register",
    payload: {
      "username": username,
      "password": password,
    },
  );
}
}
