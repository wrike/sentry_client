import '../src/utils.dart';
import 'sentry_stacktrace_frame.dart';

/**
 * https://docs.sentry.io/clientdev/interfaces/stacktrace/
 */
class SentryStacktrace {
  /**
   * A stacktrace contains a list of frames,
   * each with various bits (most optional) describing the context of that frame.
   * Frames should be sorted from oldest to newest.
   */
  List<SentryStacktraceFrame> frames;

  /**
   * Additionally, if the list of frames is large,
   * you can explicitly tell the system that you’ve omitted a range of frames.
   * The frames_omitted must be a single tuple two values: start and end.
   * For example, if you only removed the 8th frame, the value would be (8, 9),
   * meaning it started at the 8th frame,
   * and went until the 9th (the number of frames omitted is end-start).
   * The values should be based on a one-index.
   */
  List<int> framesOmitted;

  SentryStacktrace({
    List<SentryStacktraceFrame> frames,
    List<int> framesOmitted,
  })
      : this.frames = frames ?? [],
        this.framesOmitted = framesOmitted ?? [];

  Map<String, dynamic> toJson() =>
      cleanEmpties<String, dynamic>(<String, dynamic>{'frames': frames, 'frames_omitted': framesOmitted});
}
