import 'package:uuid/uuid.dart';

import '../src/utils.dart';
import 'sentry_exception.dart';
import 'sentry_log_level.dart';
import 'sentry_platform.dart';
import 'sentry_request.dart';
import 'sentry_sdk.dart';
import 'sentry_user.dart';

/**
 * https://docs.sentry.io/clientdev/attributes/
 */
class SentryPacket {
  static final Uuid _uuidGenerator = new Uuid();
  static const String defaultFingerprintBehavior = '{{ default }}';

  /**
   * Hexadecimal string representing a uuid4 value.
   * The length is exactly 32 characters (no dashes!).
   * "fc6d8c0c43fc4630ad850ee518f1b9d0"
   */
  final String eventId;

  /**
   * Indicates when the logging record was created (in the Sentry SDK).
   * The Sentry server assumes the time is in UTC.
   * The timestamp should be in ISO 8601 format, without a timezone.
   * "2011-05-02T17:41:36"
   * Actually the field requires secondsSinceEpoch
   */
  final num timestamp;

  /**
   * The name of the logger which created the record.
   * "my.logger.name"
   */
  String logger;

  /**
   * A string representing the platform the SDK is submitting from.
   * This will be used by the Sentry interface to customize various components in the interface.
   * [as3, c, cfml, cocoa, csharp, go, java, javascript, node, objc, other, perl, php, python, ruby]
   */
  SentryPlatform platform;

  /**
   * Information about the SDK sending the event.
   */
  final SentrySDK sdk = const SentrySDK();

  /**
   * The record severity.
   * Defaults to "error".
   * The value needs to be one on the supported level string values.
   */
  SentryLogLevel level = SentryLogLevel.error;

  /**
   * The name of the transaction (or culprit) which caused this exception.
   * For example, in a web app, this might be the route name: /welcome/
   * "my.module.function_name"
   */
  String culprit;

  /**
   * Identifies the host SDK from which the event was recorded.
   */
  String serverName;

  /**
   * The release version of the application.
   * This value will generally be something along the lines of the git SHA for the given project.
   */
  String release;

  /**
   * A map of tags for this event.
   * {
   *   "ios_version": "4.0",
   *   "context": "production"
   * }
   */
  Map<String, String> tags;

  /**
   * The environment name, such as ‘production’ or ‘staging’.
   */
  String environment;

  /**
   * A list of relevant modules and their versions.
   * {
   *   "my.module.name": "1.0"
   * }
   */
  Map<String, String> modules;

  /**
   * An arbitrary mapping of additional metadata to store with the event.
   * {
   *   "my_key": 1,
   *   "some_other_value": "foo bar"
   * }
   */
  Map<String, String> extra;

  /**
   * An array of strings used to dictate the deduplication of this event.
   * A value of "{{ default }}" will be replaced with the built-in behavior,
   * thus allowing you to extend it, or completely replace it.
   */
  List<String> fingerprint;

  /**
   * https://docs.sentry.io/clientdev/interfaces/exception/
   */
  List<SentryException> exceptionValues;

  /**
   * https://docs.sentry.io/clientdev/interfaces/http/
   */
  SentryRequest request;

  /**
   * https://docs.sentry.io/clientdev/interfaces/user/
   */
  SentryUser user;

  SentryPacket({
    String eventId,
    num timestamp,
    this.logger,
    SentryPlatform platform,
    this.level,
    this.culprit,
    this.serverName,
    this.release,
    Map<String, String> tags,
    this.environment,
    Map<String, String> modules,
    Map<String, String> extra,
    List<String> fingerprint,
    List<SentryException> exceptionValues,
    SentryRequest request,
    SentryUser user,
  })  : this.eventId = eventId ?? _uuidGenerator.v4().toString().replaceAll('-', ''),
        this.timestamp = timestamp ?? new DateTime.now().millisecondsSinceEpoch / 1000,
        this.platform = platform ?? SentryPlatform.javascript,
        this.tags = tags ?? {},
        this.modules = modules ?? {},
        this.extra = extra ?? {},
        this.fingerprint = fingerprint ?? [defaultFingerprintBehavior],
        this.exceptionValues = exceptionValues ?? [],
        this.request = request ?? new SentryRequest(),
        this.user = user ?? new SentryUser();

  Map<String, dynamic> toJson() => cleanEmpties<String, dynamic>(<String, dynamic>{
        'event_id': eventId,
        'timestamp': timestamp,
        'logger': logger,
        'platform': platform,
        'sdk': sdk,
        'level': level,
        'culprit': culprit,
        'server_name': serverName,
        'release': release,
        'tags': tags,
        'environment': environment,
        'modules': modules,
        'extra': extra,
        'fingerprint': fingerprint,
        'exception': {'values': exceptionValues},
        'request': request,
        'user': user,
      });
}
