import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/app_info.dart';
import '../../core/diagnostic_log.dart';

/// Creates a diagnostics package (ZIP) with meta + logs.
/// NO DB/PDF. NO PII. Per SECURITY_PRIVACY_GUIDE.
class DiagnosticExportService {
  static const int _maxLogLines = 1000;

  /// Exports diagnostics to user-selected location.
  /// Returns (path, null) on success, (null, error) on failure, (null, null) if cancelled.
  static Future<({String? path, String? error})> exportToFile(
    BuildContext context,
  ) async {
    final locale = Localizations.localeOf(context).toString();
    final suggestedName =
        'timerevo_diagnostics_${DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now())}.zip';
    final saveLocation = await getSaveLocation(
      suggestedName: suggestedName,
      acceptedTypeGroups: [
        const XTypeGroup(label: 'ZIP', extensions: ['zip']),
      ],
    );
    if (saveLocation == null) return (path: null, error: null);

    try {
      final archive = Archive();

      // meta.json
      final meta = _buildMeta(locale);
      archive.addFile(ArchiveFile(
        'meta.json',
        meta.length,
        utf8.encode(meta),
      ));

      // recent_logs.ndjson
      final logsContent = await _buildRecentLogs();
      archive.addFile(ArchiveFile(
        'recent_logs.ndjson',
        logsContent.length,
        utf8.encode(logsContent),
      ));

      final zipData = ZipEncoder().encode(archive);
      if (zipData.isEmpty) return (path: null, error: 'Failed to create ZIP');
      await File(saveLocation.path).writeAsBytes(zipData);
      return (path: saveLocation.path, error: null);
    } on Exception catch (e) {
      return (path: null, error: e.runtimeType.toString());
    }
  }

  static String _buildMeta(String locale) {
    final m = <String, Object?>{
      'appVersion': appVersion,
      'platform': Platform.operatingSystem,
      'platformVersion': Platform.operatingSystemVersion,
      'locale': locale,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
    return const JsonEncoder.withIndent('  ').convert(m);
  }

  static Future<String> _buildRecentLogs() async {
    final lines = await DiagnosticLog.readLastLines(_maxLogLines);
    if (lines.isEmpty) {
      final header = jsonEncode({
        'event': '_placeholder',
        'ts': DateTime.now().toUtc().toIso8601String(),
        'message': 'Logging not fully implemented yet. No recent entries.',
      });
      return '$header\n';
    }
    return '${lines.join('\n')}\n';
  }
}
