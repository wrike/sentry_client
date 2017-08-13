import 'http_adaptors/http_adapter.dart';
import 'http_adaptors/http_adapter_server.dart';
import 'sentry_dsn.dart';
import 'sentry_client.dart';

class SentryClientServer extends SentryClient {
  SentryClientServer(SentryDsn dsn, {HttpAdapter httpAdapter, int maxRetries: 0})
      : super(dsn, httpAdapter: httpAdapter ?? new HttpAdapterServer(), maxRetries: maxRetries);
}
