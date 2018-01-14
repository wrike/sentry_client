import 'dart:async';
import 'dart:io';

import 'http_adapter.dart';

class HttpAdapterServer implements HttpAdapter<HttpClientResponse> {
  @override
  Future<HttpClientResponse> post(String url,
      {Map<String, dynamic> params, Map<String, String> headers, String body}) async {
    final client = new HttpClient();
    var urlString = url;

    if (params != null && params.isNotEmpty) {
      urlString += '?' + HttpAdapter.encodeParams(params);
    }

    final httpClientRequest = await client.postUrl(Uri.parse(urlString));

    if (headers != null && headers.isNotEmpty) {
      headers.forEach(httpClientRequest.headers.set);
    }

    httpClientRequest.write(body);

    return httpClientRequest.close();
  }
}
