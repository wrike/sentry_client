import '../src/utils.dart';
import 'sentry_stacktrace.dart';

/**
 * https://docs.sentry.io/clientdev/interfaces/exception/
 */
class SentryException {
  /**
   * the type of exception, e.g. ValueError
   */
  String type;

  /**
   * the value of the exception (a string)
   */
  String value;

  /**
   * the optional module, or package which the exception type lives in
   */
  String module;

  /**
   * an optional value which refers to a thread in the threads interface.
   */
  String threadId;

  /**
   * Additionally an optional mechanism key can be sent with information about
   * how the exception was delivered from a low level point of view.
   * Currently it supports the following nested sub attributes
   * (the dot signifies a key in a sub object):
   * mach_exception.exception_name,
   * mach_exception.code_name,
   * posix_signal.name and posix_signal.signal.
   */
  String mechanism;

  /**
   * The stacktrace of this exception
   */
  SentryStacktrace stacktrace;

  SentryException({
    this.type,
    this.value,
    this.module,
    this.threadId,
    this.mechanism,
    SentryStacktrace stacktrace,
  })
      : this.stacktrace = stacktrace ?? new SentryStacktrace();

  Map<String, dynamic> toJson() => cleanEmpties<String, dynamic>(<String, dynamic>{
        'type': type,
        'value': value,
        'module': module,
        'thread_id': threadId,
        'mechanism': mechanism,
        'stacktrace': stacktrace
      });
}
