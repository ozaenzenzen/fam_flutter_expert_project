import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class HttpCustomClient {
  HttpCustomClient() {
    ioClientFunc();
  }
  
  Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('assets/certificates/SSLthemoviedb.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  Future<IOClient> ioClientFunc() async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    return ioClient;
  }
}
