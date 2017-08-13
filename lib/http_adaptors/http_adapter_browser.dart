import 'dart:async';
import 'dart:html';

import 'http_adapter.dart';
import 'http_request_factory.dart';

class HttpAdapterBrowser extends HttpAdapter<HttpRequest> {
  final HttpRequestFactory _httpRequestFactory;

  HttpAdapterBrowser({HttpRequestFactory httpRequestFactory})
      : _httpRequestFactory = httpRequestFactory ?? new HttpRequestFactory();

  @override
  Future<HttpRequest> post(String url, {Map<String, dynamic> params, Map<String, String> headers, String body}) =>
      _request('POST', url, body, params: params, headers: headers);

  bool _isSuccessfulResponse(HttpRequest xhr) {
    var accepted = xhr.status >= 200 && xhr.status < 300;
    var fileUri = xhr.status == 0; // file:// URIs have status of 0.
    var notModified = xhr.status == 304;
    var unknownRedirect = xhr.status > 307 && xhr.status < 400;
    return accepted || fileUri || notModified || unknownRedirect;
  }

  Future<HttpRequest> _request(String method, String url, String data,
      {Map<String, dynamic> params,
      Map<String, String> headers: const <String, String>{},
      String requestId,
      bool withCredentials: false}) {
    var completer = new Completer<HttpRequest>();

    if (params != null && params.isNotEmpty) {
      url += '?' + HttpAdapter.encodeParams(params);
    }

    var xhr = _httpRequestFactory();
    xhr.open(method, url);

    if (headers != null && headers.isNotEmpty) {
      headers.forEach(xhr.setRequestHeader);
    }

    xhr.onLoad.first.then((ProgressEvent e) {
      if (_isSuccessfulResponse(xhr)) {
        completer.complete(xhr);
      } else {
        completer.completeError(xhr);
      }
    });

    xhr.onError.first.then((ProgressEvent e) => completer.completeError(xhr));

    if (withCredentials) {
      xhr.withCredentials = true;
    }

    xhr.send(data);

    return completer.future;
  }
}
