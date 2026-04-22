import 'dart:convert';
import 'package:web/web.dart' as web;
import 'dart:js_interop';

/// Utility code to trigger a file download in the browser.
class FileDownloader {
  /// Triggers download of [content] as a file with the given [fileName].
  static void download({
    required String content,
    required String fileName,
  }) {
    final bytes = utf8.encode(content);
    final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: 'text/plain'));
    final url = web.URL.createObjectURL(blob);
    
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = url
      ..download = fileName
      ..style.display = 'none';
      
    web.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    web.URL.revokeObjectURL(url);
  }
}
