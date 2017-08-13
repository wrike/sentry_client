import 'dart:async';
import 'dart:io';

import 'http_adapter.dart';

class HttpAdapterServer implements HttpAdapter<HttpClientResponse> {
  @override
  Future<HttpClientResponse> post(String url,
      {Map<String, dynamic> params, Map<String, String> headers, String body}) async {
    var client = new HttpClient();

    if (params != null && params.isNotEmpty) {
      url += '?' + HttpAdapter.encodeParams(params);
    }

    var httpClientRequest = await client.postUrl(Uri.parse(url));

    if (headers != null && headers.isNotEmpty) {
      headers.forEach(httpClientRequest.headers.set);
    }

    httpClientRequest.write(body);

    return httpClientRequest.close();
  }
}
