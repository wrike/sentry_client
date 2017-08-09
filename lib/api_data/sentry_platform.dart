class SentryPlatform {
  static const SentryPlatform java = const SentryPlatform._('java');
  static const SentryPlatform node = const SentryPlatform._('node');
  static const SentryPlatform javascript = const SentryPlatform._('javascript');
  static const SentryPlatform other = const SentryPlatform._('other');

  final String value;

  const SentryPlatform._(this.value);

  String toJson() => value;
}
