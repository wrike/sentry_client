import 'http_adaptors/http_adapter.dart';
import 'http_adaptors/http_adapter_browser.dart';
import 'sentry_client.dart';
import 'sentry_dsn.dart';

class SentryClientBrowser extends SentryClient {
  SentryClientBrowser(SentryDsn dsn, {HttpAdapter httpAdapter, int maxRetries: 3})
      : super(dsn, httpAdapter: httpAdapter ?? new HttpAdapterBrowser(), maxRetries: maxRetries);
}
