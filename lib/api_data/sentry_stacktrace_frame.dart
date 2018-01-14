import '../src/utils.dart';

class SentryStacktraceFrame {
  /**
   * The relative filepath to the call
   */
  String filename;

  /**
   * The name of the function being called
   */
  String function;

  /**
   * Platform-specific module path (e.g. sentry.interfaces.Stacktrace)
   */
  String module;

  /**
   * The line number of the call
   */
  int lineno;

  /**
   * The column number of the call
   */
  int colno;

  /**
   * The absolute path to filename
   */
  String absPath;

  /**
   * Source code in filename at lineno
   */
  String contextLine;

  /**
   * A list of source code lines before context_line (in order) – usually [lineno - 5:lineno]
   */
  String preContext;

  /**
   * A list of source code lines after context_line (in order) – usually [lineno + 1:lineno + 5]
   */
  String postContext;

  /**
   * Signifies whether this frame is related to the execution
   * of the relevant code in this stacktrace. For example,
   * the frames that might power the framework’s webserver
   * of your app are probably not relevant, however calls
   * to the framework’s library once you start handling code likely are.
   */
  bool inApp;

  /**
   * A mapping of variables which were available within this frame (usually context-locals).
   */
  Map<String, dynamic> vars;

  /**
   * The “package” the frame was contained in.
   * Depending on the platform this can be different things.
   * For C# it can be the name of the assembly,
   * for native code it can be the path of the dynamic library etc.
   */
  String package;

  SentryStacktraceFrame({
    this.filename,
    this.function,
    this.module,
    this.lineno,
    this.colno,
    this.absPath,
    this.contextLine,
    this.preContext,
    this.postContext,
    this.inApp: true,
    Map<String, dynamic> vars,
    this.package,
  })
      : this.vars = vars ?? <String, dynamic>{};

  Map<String, dynamic> toJson() => cleanEmpties<String, dynamic>(<String, dynamic>{
        'filename': filename,
        'function': function,
        'module': module,
        'lineno': lineno,
        'colno': colno,
        'abs_path': absPath,
        'context_line': contextLine,
        'pre_context': preContext,
        'post_context': postContext,
        'in_app': inApp,
        'vars': vars,
        'package': package,
      });
}
