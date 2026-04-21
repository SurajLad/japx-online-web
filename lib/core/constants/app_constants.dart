/// App-wide constants for JAPX Parser.
class AppConstants {
  AppConstants._();

  static const String appName = 'JSON API Parser JAPX';
  static const String appVersion = 'v2.0';
  static const String appTagline = 'JSON:API Decoder/Encoder';
  static const String appDescription =
      'JSON API Parser online is a tool for converting complex '
      'JSON:API structure into simple JSON based on Flutter Japx.';

  static const String githubUrl = 'https://github.com/SurajLad/';
  static const String japxPackageUrl = 'https://pub.dev/packages/japx';
  static const String githubRepoUrl =
      'https://github.com/SurajLad/japx-online-web';

  // Debounce durations
  static const Duration validationDebounce = Duration(milliseconds: 300);

  // Editor defaults
  static const int defaultIndentSpaces = 2;
  static const String defaultFormat = 'JSON';

  static const String sampleJson = '''{
  "data": {
    "type": "articles",
    "id": "1",
    "attributes": {
      "title": "JSON:API paints my bikeshed!",
      "body": "The shortest article ever.",
      "created": "2015-05-22T14:56:29.000Z",
      "updated": "2015-05-22T14:56:28.000Z"
    },
    "relationships": {
      "author": {
        "data": {
          "id": "42",
          "type": "people"
        }
      }
    }
  },
  "included": [
    {
      "type": "people",
      "id": "42",
      "attributes": {
        "name": "John",
        "age": 80,
        "gender": "male"
      }
    }
  ]
}''';
}
