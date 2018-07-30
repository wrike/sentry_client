@TestOn('browser')

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:mockito/mockito.dart';
import 'package:quiver/testing/async.dart';
import 'package:sentry_client/api_data/sentry_packet.dart';
import 'package:sentry_client/http_adaptors/http_adapter_browser.dart';
import 'package:sentry_client/http_adaptors/http_request_factory.dart';
import 'package:sentry_client/sentry_client_browser.dart';
import 'package:sentry_client/sentry_dsn.dart';
import 'package:test/test.dart';

void main() {
  group('SentryClient.write should', () {
    HttpRequestFactoryMock factoryMock;
    HttpRequestMock requestMock;
    StreamController<ProgressEvent> reqOnLoadStreamController;
    StreamController<ProgressEvent> reqOnErrorStreamController;
    StreamController<ProgressEvent> reqOnAbortStreamController;
    HttpAdapterBrowser httpAdapter;

    void setUpCustom() {
      factoryMock = new HttpRequestFactoryMock();
      requestMock = new HttpRequestMock();

      when(factoryMock.call()).thenReturn(requestMock);

      reqOnLoadStreamController = new StreamController<ProgressEvent>.broadcast();
      when(requestMock.onLoad).thenAnswer((_) => reqOnLoadStreamController.stream);

      reqOnErrorStreamController = new StreamController<ProgressEvent>.broadcast();
      when(requestMock.onError).thenAnswer((_) => reqOnErrorStreamController.stream);

      reqOnAbortStreamController = new StreamController<ProgressEvent>.broadcast();
      when(requestMock.onAbort).thenAnswer((_) => reqOnAbortStreamController.stream);

      httpAdapter = new HttpAdapterBrowser(httpRequestFactory: factoryMock);
      new SentryClientBrowser(
        SentryDsn.fromString('https://123456789abcdef123456789abcdef12@sentry.local/1'),
        httpAdapter: httpAdapter,
      )..write(new SentryPacket());
    }

    test('open POST request to the Setnry server', () {
      new FakeAsync().run((selfAsync) {
        setUpCustom();
        selfAsync.elapse(const Duration());

        expect(verify(requestMock.open(captureAny, captureAny)).captured,
            ['POST', 'https://sentry.local:443/api/1/store/']);
      });
    });

    test('setup the Sentry auth header', () {
      new FakeAsync().run((selfAsync) {
        setUpCustom();
        selfAsync.elapse(const Duration());

        expect(verify(requestMock.setRequestHeader(captureAny, captureAny)).captured,
            ['X-Sentry-Auth', contains('sentry_key=123456789abcdef123456789abcdef12')]);
      });
    });

    test('send serialized data', () {
      new FakeAsync().run((selfAsync) {
        setUpCustom();
        selfAsync.elapse(const Duration());

        final capturedData =
            json.decode(verify(requestMock.send(captureAny)).captured[0] as String) as Map<String, dynamic>;
        expect(capturedData['event_id'], isNotEmpty);
        expect(capturedData['timestamp'], isNotNull);
      });
    });

    test('retry on a fail', () {
      new FakeAsync().run((selfAsync) {
        setUpCustom();
        selfAsync.elapse(const Duration());

        reqOnErrorStreamController.add(new ProgressEvent('error'));
        selfAsync
          ..elapse(const Duration())
          ..flushTimers();

        verify(requestMock.send(any)).called(2);
      });
    });

    test('not contain null fields', () {
      new FakeAsync().run((selfAsync) {
        setUpCustom();
        selfAsync.elapse(const Duration());

        final capturedData = verify(requestMock.send(captureAny)).captured[0] as String;

        expect(capturedData, isNot(contains('logger')));
      });
    });

//    tearDown(() {
//      logInvocations([factoryMock, requestMock]);
//    });
  });
}

class HttpRequestFactoryMock extends Mock implements HttpRequestFactory {}

class HttpRequestMock extends Mock implements HttpRequest {}
