import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class HttpCustomClient {
  static HttpCustomClient? _httpCustomClient;
  HttpCustomClient._instance() {
    _httpCustomClient = this;
  }

  factory HttpCustomClient() => _httpCustomClient ?? HttpCustomClient._instance();

  static IOClient? _ioClient;

  Future<IOClient?> get ioClient async {
    _ioClient ??= await _ioClientFunc();
    return _ioClient;
  }

  Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('assets/certificates/SSLthemoviedb.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  Future<IOClient> _ioClientFunc() async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    return ioClient;
  }

  
  Future<Response> get(Uri url) async {
    final client = await ioClient;
    return await client!.get(url);
  }
}
