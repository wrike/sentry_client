class SentryLogLevel {
  static const SentryLogLevel fatal = const SentryLogLevel._('fatal');
  static const SentryLogLevel error = const SentryLogLevel._('error');
  static const SentryLogLevel warning = const SentryLogLevel._('warning');
  static const SentryLogLevel info = const SentryLogLevel._('info');
  static const SentryLogLevel debug = const SentryLogLevel._('debug');

  final String value;

  const SentryLogLevel._(this.value);

  String toJson() => value;
}
