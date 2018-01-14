import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'api_data/sentry_packet.dart';
import 'http_adaptors/http_adapter.dart';
import 'sentry_dsn.dart';

abstract class SentryClient {
  final SentryDsn _dsn;
  final HttpAdapter _adapter;
  final int _maxRetries;
  final String _url;

  SentryClient(SentryDsn dsn, {HttpAdapter httpAdapter, int maxRetries})
      : _dsn = dsn,
        _adapter = httpAdapter,
        _maxRetries = maxRetries,
        _url = '${dsn.protocol}://${dsn.host + dsn.path}api/${dsn.projectId}/store/';

  Future<dynamic> write(SentryPacket packet) => _send(JSON.encode(packet).toString(), _maxRetries);

  String _getAuthHeader() =>
      // ignore: prefer_adjacent_string_concatenation
      'Sentry sentry_version=7,' +
      'sentry_timestamp=${new DateTime.now().millisecondsSinceEpoch ~/ 1000},' +
      'sentry_key=${_dsn.publicKey}';

  Future<dynamic> _send(String body, int retriesLeft) => _adapter
          .post(_url, headers: <String, String>{'X-Sentry-Auth': _getAuthHeader()}, body: body)
          .catchError((dynamic response) {
        var retriesLeftNext = retriesLeft;
        //TODO: Retry only on http errors
        if (retriesLeftNext > 0) {
          final wait = new Duration(milliseconds: (500 * (pow(2, _maxRetries - retriesLeftNext))).toInt());
          new Timer(wait, () => _send(body, --retriesLeftNext));
        }
//        else {
//          //TODO: check infinite error-cycle
//          print('catchError->else');
//          throw response;
//
//        }
      });
}
