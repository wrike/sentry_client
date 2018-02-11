class SentryDsn {
  final String protocol;
  final String host;
  final String publicKey;
  final String secretKey;
  final String path;
  final String projectId;

  SentryDsn(this.protocol, this.host, this.path, this.publicKey, this.projectId, {this.secretKey});

  // ignore: prefer_constructors_over_static_methods
  static SentryDsn fromString(String dsnStr, {bool allowSecretKey: false}) {
    final uri = Uri.parse(dsnStr);

    final keys = uri.userInfo.split(':');
    if (keys.length > 1 && !allowSecretKey) {
      throw new ArgumentError('You are using DSN with a secret key!');
    }

    final publicKey = keys.first;
    final secret = keys.last;

    final pathSegments = uri.path.split('/').where((String key) => key != '');
    if (pathSegments.isEmpty) {
      throw new ArgumentError('Invalid DSN format: $dsnStr');
    }

    final projectId = pathSegments.last;
    final path = uri.path.substring(0, uri.path.length - projectId.length);

    return new SentryDsn(uri.scheme, '${uri.host}:${uri.port}', path, publicKey, projectId, secretKey: secret);
  }
}
