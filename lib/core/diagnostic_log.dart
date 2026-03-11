import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Minimal NDJSON sink for diagnostics. NO PII. Only event codes and allowed
/// technical data (e.g. error runtimeType). Per SECURITY_PRIVACY_GUIDE.
///
/// Rotation: 5MB max, keep 2 backup files.
const int _maxBytes = 5 * 1024 * 1024;
const String _logFileName = 'timerevo_diagnostics.ndjson';

/// Allowed event codes. Do NOT add events that could contain PII.
enum DiagnosticEvent {
  appStart,
  appInitFailed,
  adminUnlockSuccess,
  adminUnlockFail,
  backupStart,
  backupSuccess,
  backupFail,
  diagnosticExportStart,
  diagnosticExportSuccess,
  diagnosticExportFail,
  terminalClockIn,
  terminalClockOut,
  terminalClockInSuccess,
  terminalClockOutSuccess,
  terminalClockInFail,
  terminalClockOutFail,
  appUnhandledError,
  appFlutterError,
}

/// Sanitized log entry. No names, notes, PIN, raw exception messages.
class DiagnosticLogEntry {
  const DiagnosticLogEntry({
    required this.event,
    required this.ts,
    this.errorType,
  });

  final DiagnosticEvent event;
  final String ts;

  /// Only exception runtimeType (e.g. "SqliteException"); no message.
  final String? errorType;

  Map<String, Object?> toJson() {
    final m = <String, Object?>{'event': event.name, 'ts': ts};
    if (errorType != null) m['errorType'] = errorType;
    return m;
  }

  String toNdjson() => jsonEncode(toJson());
}

bool _initialized = false;
File? _logFile;
String? _logDir;

Future<void> _ensureInit() async {
  if (_initialized) return;
  final dir = await getApplicationSupportDirectory();
  _logDir = dir.path;
  _logFile = File(p.join(_logDir!, _logFileName));
  _initialized = true;
}

/// Static API for diagnostic logging. NO PII.
class DiagnosticLog {
  DiagnosticLog._();

  static Future<void> append(DiagnosticLogEntry entry) => _appendImpl(entry);
  static Future<List<String>> readLastLines(int n) => _readLastLinesImpl(n);
}

Future<void> _appendImpl(DiagnosticLogEntry entry) async {
  try {
    await _ensureInit();
    final f = _logFile!;
    await f.writeAsString('${entry.toNdjson()}\n', mode: FileMode.append);
    await _rotateIfNeeded();
  } catch (_) {
    // Silently ignore log write failures; never surface to user
  }
}

Future<void> _rotateIfNeeded() async {
  final f = _logFile!;
  final stat = await f.stat();
  if (stat.size < _maxBytes) return;

  final dir = _logDir!;
  final base = p.withoutExtension(_logFileName);
  final ext = p.extension(_logFileName);
  final path1 = p.join(dir, '$base.1$ext');
  final path2 = p.join(dir, '$base.2$ext');

  // Rotate: delete .2, rename .1->.2, rename main->.1, create new main
  final f2 = File(path2);
  if (await f2.exists()) await f2.delete();
  final f1 = File(path1);
  if (await f1.exists()) await f1.rename(path2);
  await f.rename(path1);
  _logFile = File(p.join(dir, _logFileName));
  await _logFile!.writeAsString('');
}

/// Read last N lines from the log file. Returns lines in chronological order.
/// If file does not exist or is empty, returns empty list.
Future<List<String>> _readLastLinesImpl(int n) async {
  try {
    await _ensureInit();
    final f = _logFile!;
    if (!await f.exists()) return [];
    final content = await f.readAsString();
    final lines = content
        .split('\n')
        .where((s) => s.trim().isNotEmpty)
        .toList();
    if (lines.length <= n) return lines;
    return lines.sublist(lines.length - n);
  } catch (_) {
    return [];
  }
}

/// Check if log file exists (for export).
Future<bool> hasLogFile() async {
  try {
    await _ensureInit();
    return _logFile != null && await _logFile!.exists();
  } catch (_) {
    return false;
  }
}
