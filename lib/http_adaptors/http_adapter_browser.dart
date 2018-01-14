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
    final accepted = xhr.status >= 200 && xhr.status < 300;
    final fileUri = xhr.status == 0; // file:// URIs have status of 0.
    final notModified = xhr.status == 304;
    final unknownRedirect = xhr.status > 307 && xhr.status < 400;
    return accepted || fileUri || notModified || unknownRedirect;
  }

  Future<HttpRequest> _request(String method, String url, String data,
      {Map<String, dynamic> params,
      Map<String, String> headers: const <String, String>{},
      String requestId,
      bool withCredentials: false}) {
    final completer = new Completer<HttpRequest>();
    var urlString = url;

    if (params != null && params.isNotEmpty) {
      urlString += '?' + HttpAdapter.encodeParams(params);
    }

    final xhr = _httpRequestFactory()..open(method, urlString);

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
