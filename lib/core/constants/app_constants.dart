/// App-wide constants for JPAX Parser.
class AppConstants {
  AppConstants._();

  static const String appName = 'JSON API Parser JPAX';
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
}
