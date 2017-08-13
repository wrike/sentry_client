[![pub](https://img.shields.io/pub/v/sentry_client.svg)](https://pub.dartlang.org/packages/sentry_client)
[![build status](https://api.travis-ci.org/wrike/sentry_client.svg?branch=master)](https://api.travis-ci.org/wrike/sentry_client)
[![codecov](https://codecov.io/gh/wrike/sentry_client/branch/master/graph/badge.svg)](https://codecov.io/gh/wrike/sentry_client)
[![documentation](https://img.shields.io/badge/Documentation-sentry_client-blue.svg)](https://www.dartdocs.org/documentation/sentry_client/latest)

### The Dart library for sending data to the Sentry server.

### Usage in browser:
```dart
var client = new SentryClientBrowser(
  SentryDsn.fromString('https://123456789abcdef123456789abcdef12@sentry.local/1')
);

client.write(new SentryPacket());
```

### Usage on server:
```dart
var client = new SentryClientServer(
  SentryDsn.fromString('https://123456789abcdef123456789abcdef12@sentry.local/1')
);

client.write(new SentryPacket());
```
