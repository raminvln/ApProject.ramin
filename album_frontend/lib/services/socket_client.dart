import 'dart:io';
import 'dart:convert';
import 'dart:async';

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
    await socket.flush();

    final completer = Completer<String>();
    final buffer = StringBuffer();
    socket.transform(utf8.decoder).listen(
      (data) => buffer.write(data),
      onDone: () => completer.complete(buffer.toString()),
      onError: (e) => completer.completeError(e),
    );

    final raw = await completer.future.timeout(const Duration(seconds: 10));
    socket.destroy();
    return jsonDecode(raw) as Map<String, dynamic>;
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
        "displayName": username,
        "userName": username,
        "password": password,
      },
    );
  }
}
