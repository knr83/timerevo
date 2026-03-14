import 'dart:convert';
import 'dart:io';

/// Session-scoped debug logger. Writes NDJSON to debug-4fd0ab.log.
/// Used only for debugging attendance flow; remove after fix verified.
void debugLog({
  required String location,
  required String message,
  Map<String, dynamic>? data,
  String? hypothesisId,
}) {
  try {
    final payload = <String, dynamic>{
      'sessionId': '4fd0ab',
      'location': location,
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    if (data != null) payload['data'] = data;
    if (hypothesisId != null) payload['hypothesisId'] = hypothesisId;
    File f = File('debug-4fd0ab.log');
    f.writeAsStringSync('${jsonEncode(payload)}\n', mode: FileMode.append);
  } catch (_) {}
}
