import 'package:japx_online/features/model_generator/domain/models/generated_model.dart';

class DartModelGenerator {
  GeneratedModel generate(Map<String, dynamic> json, {String? className}) {
    final name = className ?? _inferClassName(json) ?? 'GeneratedModel';

    final buffer = StringBuffer();
    final nestedClasses = <String>[];

    _generateClass(buffer, name, json, nestedClasses);

    // Append nested classes
    for (final nested in nestedClasses) {
      buffer.writeln();
      buffer.write(nested);
    }

    final sourceCode = buffer.toString();
    final fileName = _toSnakeCase(name);

    return GeneratedModel(
      className: name,
      sourceCode: sourceCode,
      language: 'dart',
      fileName: '$fileName.dart',
    );
  }

  void _generateClass(
    StringBuffer buffer,
    String className,
    Map<String, dynamic> json,
    List<String> nestedClasses,
  ) {
    final fields = <_FieldInfo>[];

    json.forEach((key, value) {
      final dartType = _inferDartType(key, value, className, nestedClasses);
      final fieldName = _toCamelCase(key);
      fields.add(_FieldInfo(
        jsonKey: key,
        fieldName: fieldName,
        dartType: dartType,
        isNullable: value == null,
      ));
    });

    buffer.writeln('class $className {');

    for (final field in fields) {
      final nullSuffix = field.isNullable ? '?' : '';
      buffer
          .writeln('  final ${field.dartType}$nullSuffix ${field.fieldName};');
    }
    buffer.writeln();

    buffer.writeln('  $className({');
    for (final field in fields) {
      final required = field.isNullable ? '' : 'required ';
      buffer.writeln('    ${required}this.${field.fieldName},');
    }
    buffer.writeln('  });');
    buffer.writeln();

    buffer
        .writeln('  factory $className.fromJson(Map<String, dynamic> json) {');
    buffer.writeln('    return $className(');
    for (final field in fields) {
      buffer
          .writeln('      ${field.fieldName}: ${_fromJsonExpression(field)},');
    }
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln();

    // toJson method
    buffer.writeln('  Map<String, dynamic> toJson() {');
    buffer.writeln('    return {');
    for (final field in fields) {
      buffer.writeln("      '${field.jsonKey}': ${_toJsonExpression(field)},");
    }
    buffer.writeln('    };');
    buffer.writeln('  }');

    buffer.writeln('}');
  }

  /// Infers Dart type from a JSON value.
  String _inferDartType(
    String key,
    dynamic value,
    String parentClass,
    List<String> nestedClasses,
  ) {
    if (value == null) return 'dynamic';
    if (value is bool) return 'bool';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is String) {
      // Check for ISO date
      if (_isIsoDate(value)) return 'DateTime';
      return 'String';
    }
    if (value is List) {
      if (value.isEmpty) return 'List<dynamic>';
      final first = value.first;
      if (first is Map<String, dynamic>) {
        final nestedName = _toPascalCase(key);
        final nestedBuffer = StringBuffer();
        _generateClass(nestedBuffer, nestedName, first, nestedClasses);
        nestedClasses.add(nestedBuffer.toString());
        return 'List<$nestedName>';
      }
      final itemType = _inferDartType(key, first, parentClass, nestedClasses);
      return 'List<$itemType>';
    }
    if (value is Map<String, dynamic>) {
      final nestedName = _toPascalCase(key);
      final nestedBuffer = StringBuffer();
      _generateClass(nestedBuffer, nestedName, value, nestedClasses);
      nestedClasses.add(nestedBuffer.toString());
      return nestedName;
    }
    return 'dynamic';
  }

  String _fromJsonExpression(_FieldInfo field) {
    final access = "json['${field.jsonKey}']";

    if (field.isNullable) return access;

    switch (field.dartType) {
      case 'String':
        return "$access as String";
      case 'int':
        return "$access as int";
      case 'double':
        return "($access as num).toDouble()";
      case 'bool':
        return "$access as bool";
      case 'DateTime':
        return "DateTime.parse($access as String)";
      case 'dynamic':
        return access;
      default:
        if (field.dartType.startsWith('List<')) {
          final innerType =
              field.dartType.substring(5, field.dartType.length - 1);
          if (['String', 'int', 'double', 'bool', 'dynamic']
              .contains(innerType)) {
            return "List<$innerType>.from($access as List)";
          }
          return "($access as List).map((e) => $innerType.fromJson(e as Map<String, dynamic>)).toList()";
        }
        // Nested object
        return "${field.dartType}.fromJson($access as Map<String, dynamic>)";
    }
  }

  /// Generates toJson expression for a field.
  String _toJsonExpression(_FieldInfo field) {
    final name = field.fieldName;

    if (field.dartType == 'DateTime') {
      return field.isNullable
          ? '$name?.toIso8601String()'
          : '$name.toIso8601String()';
    }
    if (field.dartType.startsWith('List<')) {
      final innerType = field.dartType.substring(5, field.dartType.length - 1);
      if (!['String', 'int', 'double', 'bool', 'dynamic'].contains(innerType)) {
        return field.isNullable
            ? '$name?.map((e) => e.toJson()).toList()'
            : '$name.map((e) => e.toJson()).toList()';
      }
    }
    if (!['String', 'int', 'double', 'bool', 'dynamic']
            .contains(field.dartType) &&
        !field.dartType.startsWith('List<')) {
      return field.isNullable ? '$name?.toJson()' : '$name.toJson()';
    }
    return name;
  }

  /// Checks if a string looks like an ISO 8601 date.
  bool _isIsoDate(String value) {
    return RegExp(r'^\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}:\d{2}').hasMatch(value);
  }

  /// Tries to infer class name from a JSON "type" field.
  String? _inferClassName(Map<String, dynamic> json) {
    final type = json['type'];
    if (type is String && type.isNotEmpty) {
      return _toPascalCase(type);
    }
    return null;
  }

  String _toCamelCase(String input) {
    final parts = input.split(RegExp(r'[_\-\s]+'));
    if (parts.isEmpty) return input;
    final first = parts.first.toLowerCase();
    final rest = parts.skip(1).map((p) {
      if (p.isEmpty) return p;
      return p[0].toUpperCase() + p.substring(1).toLowerCase();
    });
    return first + rest.join();
  }

  String _toPascalCase(String input) {
    final parts = input.split(RegExp(r'[_\-\s]+'));
    return parts.map((p) {
      if (p.isEmpty) return p;
      return p[0].toUpperCase() + p.substring(1).toLowerCase();
    }).join();
  }

  String _toSnakeCase(String input) {
    return input
        .replaceAllMapped(
            RegExp(r'[A-Z]'), (m) => '_${m.group(0)!.toLowerCase()}')
        .replaceAll(RegExp(r'^_'), '');
  }
}

class _FieldInfo {
  final String jsonKey;
  final String fieldName;
  final String dartType;
  final bool isNullable;

  const _FieldInfo({
    required this.jsonKey,
    required this.fieldName,
    required this.dartType,
    required this.isNullable,
  });
}
