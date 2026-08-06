import 'dart:io';
import 'dart:convert';
import 'dart:async';

class SocketClient {
  // Change this to 10.0.2.2 for Android emulator, 127.0.0.1 for iOS
  // simulator, or your machine's LAN IP for a physical device.
  static const String serverIp = 10.0.2.2;

  static Future<Map<String, dynamic>> send({
    required String method,
    required String userName,
    required String route,
    required Map<String, dynamic> payload,
  }) async {
    final socket = await Socket.connect(serverIp, 8080);

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

    try {
      final raw = await completer.future.timeout(const Duration(seconds: 10));
      return jsonDecode(raw) as Map<String, dynamic>;
    } finally {
      socket.destroy();
    }
  }

  static Future<Map<String, dynamic>> register({
    required String displayName,
    required String userName,
    required String password,
  }) async {
    return send(
      method: 'POST',
      userName: userName,
      route: '/register',
      payload: {
        'displayName': displayName,
        'userName': userName,
        'password': password,
      },
    );
  }

  static Future<Map<String, dynamic>> login({
    required String userName,
    required String password,
  }) async {
    return send(
      method: 'POST',
      userName: userName,
      route: '/login',
      payload: {'userName': userName, 'password': password},
    );
  }
}
