import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class Shared {
  static Future<HttpClient> customHttpClient() async {
    final sslCert = await rootBundle.load('certificates/certificates.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());

    HttpClient httpClient = HttpClient(context: securityContext);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;

    return httpClient;
  }

  static Future<http.Client> createLEClient() async {
    IOClient client = IOClient(await Shared.customHttpClient());
    return client;
  }
}
