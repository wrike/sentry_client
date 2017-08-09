import 'dart:async';

abstract class HttpAdapter<T> {
  Future<T> post(String url, {Map<String, dynamic> params, Map<String, String> headers, String body});

  static String encodeParams(Map<String, dynamic> queryParameters) {
    if (queryParameters == null) {
      return '';
    }
    var result = new StringBuffer();
    var first = true;
    queryParameters.forEach((String key, dynamic value) {
      if (!first) {
        result.write('&');
      }
      first = false;
      result.write(Uri.encodeQueryComponent(key));
      if (value != null) {
        if (value.toString().isNotEmpty) {
          result.write('=');
          result.write(Uri.encodeQueryComponent(value.toString()));
        }
      }
    });
    return result.toString();
  }
}
