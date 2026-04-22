/// Severity level for a JSON diagnostic.
enum DiagnosticSeverity { error, warning, info }

/// Represents a single validation issue in the JSON input.
class JsonDiagnostic {
  final DiagnosticSeverity severity;
  final int line;
  final int column;
  final String message;
  final String? path;

  const JsonDiagnostic({
    required this.severity,
    required this.line,
    required this.column,
    required this.message,
    this.path,
  });

  String get severityLabel {
    switch (severity) {
      case DiagnosticSeverity.error:
        return 'Error';
      case DiagnosticSeverity.warning:
        return 'Warning';
      case DiagnosticSeverity.info:
        return 'Info';
    }
  }

  String get locationLabel => 'line $line, column $column';
}
