import 'dart:convert';
import 'package:japx_online/features/editor/domain/models/json_diagnostic.dart';

/// Validates JSON input and returns a list of diagnostics.
class JsonValidator {
  /// Validates [input] JSON string and returns diagnostics.
  /// Returns an empty list if JSON is valid.
  List<JsonDiagnostic> validate(String input) {
    if (input.trim().isEmpty) return [];

    final diagnostics = <JsonDiagnostic>[];

    // ── Primary parse check ──────────────────────────────
    try {
      final decoded = jsonDecode(input);
      // If valid, check for warnings
      diagnostics.addAll(_checkWarnings(input, decoded));
    } on FormatException catch (e) {
      final position = _extractPosition(e, input);
      diagnostics.add(JsonDiagnostic(
        severity: DiagnosticSeverity.error,
        line: position.$1,
        column: position.$2,
        message: _cleanErrorMessage(e.message),
        path: _guessPath(input, position.$1),
      ));
    } catch (e) {
      diagnostics.add(JsonDiagnostic(
        severity: DiagnosticSeverity.error,
        line: 1,
        column: 1,
        message: 'Unable to parse JSON: ${e.toString()}',
      ));
    }

    return diagnostics;
  }

  /// Extracts (line, column) from a [FormatException].
  (int, int) _extractPosition(FormatException e, String input) {
    final offset = e.offset;
    if (offset == null || offset < 0) return (1, 1);

    int line = 1;
    int column = 1;
    for (int i = 0; i < offset && i < input.length; i++) {
      if (input[i] == '\n') {
        line++;
        column = 1;
      } else {
        column++;
      }
    }
    return (line, column);
  }

  /// Cleans up the default FormatException message.
  String _cleanErrorMessage(String message) {
    // Remove trailing position info like "(at character 42)"
    final cleaned =
        message.replaceAll(RegExp(r'\(at character \d+\)'), '').trim();
    if (cleaned.isEmpty) return 'Invalid JSON syntax';
    // Capitalize first letter
    return cleaned[0].toUpperCase() + cleaned.substring(1);
  }

  /// Tries to guess the JSON path of the error location.
  String? _guessPath(String input, int errorLine) {
    final lines = input.split('\n');
    final path = <String>[];

    for (int i = 0; i < errorLine && i < lines.length; i++) {
      final line = lines[i].trim();
      // Match key patterns like "keyName":
      final match = RegExp(r'"([^"]+)"\s*:').firstMatch(line);
      if (match != null) {
        final key = match.group(1)!;
        // Simple heuristic: track last few key levels
        if (line.contains('{') || line.contains('[')) {
          path.add(key);
        } else {
          if (path.isNotEmpty) {
            // Replace last key at same level
            path[path.length - 1] = key;
          } else {
            path.add(key);
          }
        }
      }
      // Track closing brackets to pop path
      if (line == '}' || line == '},' || line == ']' || line == '],') {
        if (path.isNotEmpty) path.removeLast();
      }
    }

    return path.isEmpty ? null : path.join('.');
  }

  /// Checks valid JSON for warnings (ISO dates, etc.).
  List<JsonDiagnostic> _checkWarnings(String input, dynamic decoded) {
    final warnings = <JsonDiagnostic>[];
    final lines = input.split('\n');

    // ISO date pattern
    final isoDateRegex = RegExp(
      r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}',
    );

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Check for ISO date strings
      if (isoDateRegex.hasMatch(line)) {
        final keyMatch = RegExp(r'"([^"]+)"\s*:').firstMatch(line);
        final fieldName = keyMatch?.group(1) ?? 'unknown';
        warnings.add(JsonDiagnostic(
          severity: DiagnosticSeverity.warning,
          line: i + 1,
          column: line.indexOf(isoDateRegex.firstMatch(line)!.group(0)!) + 1,
          message:
              "Field '$fieldName' is in ISO format. Consider a date format.",
          path: fieldName,
        ));
      }
    }

    return warnings;
  }
}
