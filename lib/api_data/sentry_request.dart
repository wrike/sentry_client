import '../src/utils.dart';

/**
 * https://docs.sentry.io/clientdev/interfaces/http/
 */
class SentryRequest {
  static const String userAgentHeaderKey = 'User-Agent';

  /**
   * The full URL of the request if available.
   */
  String url;

  /**
   * The actual HTTP method of the request.
   */
  String method;

  /**
   * Submitted data in whatever format makes most sense.
   * This data should not be provided by default as it can get quite large
   */
  Map<String, String> data;

  /**
   * The unparsed query string as it is provided.
   */
  String queryString;

  /**
   * The cookie values. Typically unparsed as a string.
   */
  String cookies;

  /**
   * A dictionary of submitted headers.
   * If a header appears multiple times it needs to be merged according to the HTTP standard for header merging.
   */
  Map<String, String> headers;

  /**
   * Optional environment data.
   * This is where information such as CGI/WSGI/Rack keys go that are not HTTP headers.
   */
  Map<String, String> env;

  SentryRequest({
    this.url,
    this.method,
    Map<String, String> data,
    this.queryString,
    this.cookies,
    Map<String, String> headers,
    Map<String, String> env,
  })  : this.data = data ?? {},
        this.headers = headers ?? {},
        this.env = env ?? {};

  Map<String, dynamic> toJson() => cleanEmpties<String, dynamic>(<String, dynamic>{
        'url': url ?? '',
        'method': method ?? 'GET',
        'data': data,
        'query_string': queryString,
        'cookies': cookies,
        'headers': headers,
        'env': env,
      });
}
