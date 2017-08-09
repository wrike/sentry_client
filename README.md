# The Dart library for sending data to the Sentry server.

# Usage in browser:
```dart
var client = new SentryClientBrowser(
  SentryDsn.fromString('https://123456789abcdef123456789abcdef12@sentry.local/1')
);

client.write(new SentryPacket());
```

# Usage on server:
```dart
var client = new SentryClientServer(
  SentryDsn.fromString('https://123456789abcdef123456789abcdef12@sentry.local/1')
);

client.write(new SentryPacket());
```
