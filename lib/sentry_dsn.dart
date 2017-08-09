class SentryDsn {
  final String protocol;
  final String host;
  final String publicKey;
  final String secretKey;
  final String path;
  final String projectId;

  SentryDsn(this.protocol, this.host, this.path, this.publicKey, this.projectId, {this.secretKey: null});

  static SentryDsn fromString(String dsnStr, {bool allowSecretKey: false}) {
    var uri = Uri.parse(dsnStr);

    Iterable<String> keys = uri.userInfo.split(':');
    if (keys.length > 1 && !allowSecretKey) {
      throw new ArgumentError('You are using DSN with a secret key!');
    }

    var publicKey = keys.first;
    var secret = keys.last;

    var pathSegments = uri.path.split('/').where((String key) => key != '');
    if (pathSegments.isEmpty) {
      throw new ArgumentError('Invalid DSN format: $dsnStr');
    }

    var projectId = pathSegments.last;
    var path = uri.path.substring(0, uri.path.length - projectId.length);

    return new SentryDsn(uri.scheme, '${uri.host}:${uri.port}', path, publicKey, projectId, secretKey: secret);
  }
}
