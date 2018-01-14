import '../src/utils.dart';

/**
 * https://docs.sentry.io/clientdev/interfaces/user/
 * An interface which describes the authenticated User for a request.
 *
 * You should provide at least either an id (a unique identifier for an authenticated user)
 * or ip_address (their IP address).
 */
class SentryUser {
  /**
   * The unique ID of the user.
   */
  String id;

  /**
   * The email address of the user.
   */
  String email;

  /**
   * The IP of the user.
   */
  String ipAddress;

  /**
   * The username of the user
   */
  String userName;

  SentryUser({this.id, this.email, this.ipAddress, this.userName});

  Map<String, dynamic> toJson() => cleanNulls<String, dynamic>(<String, dynamic>{
        'id': id,
        'email': email,
        'ip_address': ipAddress,
        'user_name': userName,
      });
}
