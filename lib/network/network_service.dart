import 'package:http/http.dart' as http;
import 'package:news_app/network/network_helper.dart';

enum RequestType { get, put, post }

class NetworkService {
  const NetworkService._();

  static Map<String, String> _getHeaders() =>
      {'Content-Type': 'application/json', "Access-Control-Allow-Origin": "\*"};

  static Future<http.Response>? _createRequest(
      {required RequestType requestType,
      required Uri uri,
      Map<String, String>? headers,
      Map<String, dynamic>? body}) {
    if (requestType == RequestType.get) {
      print("Api Call $uri");
      return http.get(uri, headers: headers);
    }
  }

  static Future<http.Response?>? sendRequest({
    required RequestType requestType,
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? queryParam,
  }) async {
    try {
      final _header = _getHeaders();
      final _url = NetworkHelper.concatUrlQP(url, queryParam);
      print("URL Request ${_url}");

      final response = _createRequest(
          requestType: requestType,
          uri: Uri.parse(_url),
          headers: _header,
          body: body);

      return response;
    } catch (e) {
      print(' Api Error - $e');
      return null;
    }
  }
}
