class SentrySDK {
  final String name = 'dart-sentry-client';

  final String version = '4.0.2';

  const SentrySDK();

  Map<String, String> toJson() => <String, String>{'name': name, 'version': version};
}
