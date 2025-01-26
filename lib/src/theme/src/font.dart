part of '../theme.dart';

/// [ThemedFontHandler] is a helper class to generate a [TextTheme] with the
/// [AppFont] of the app.
///
/// Also provides a preloader for the fonts that comes from the network, and checker for the
/// font family.
class ThemedFontHandler {
  /// [preloadFont] is a helper function to preload a [AppFont] from the network.
  static Future<void> preloadFont(AppFont font) async {
    if (font.source == FontSource.local) return;
    debugPrint("layrz_theme/ThemedFontHandler.preloadFont(): Preloading font ${font.name}");

    if (font.source == FontSource.uri && font.uri != null) {
      final response = await Dio().get(font.uri!, options: Options(responseType: ResponseType.bytes));
      if (response.statusCode == 200) {
        final loader = FontLoader(font.name);
        loader.addFont(Future.value(response.data.buffer.asByteData()));
        await loader.load();
        return;
      }
    }

    TextStyle google;
    try {
      google = GoogleFonts.getFont(font.name);
    } catch (_) {
      google = GoogleFonts.ubuntu();
    }

    await GoogleFonts.pendingFonts([google]);
  }

  /// [generateFont] is a helper function to generate a [TextTheme] with the
  /// [AppFont] of the app.
  static TextTheme generateFont({
    /// [titleFont] is the font family of the title text.
    required AppFont? titleFont,

    /// [bodyFont] is the font family of the text.
    required AppFont? bodyFont,

    /// [titleTextColor] is the color of the title text.
    required Color titleTextColor,

    /// [isDark] is a boolean to indicate if the theme is dark.
    bool isDark = false,
  }) {
    final defaultTextTheme = (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;

    String titleFontName = titleFont?.name ?? 'Ubuntu';
    if (titleFont?.source == FontSource.google) {
      try {
        titleFontName = GoogleFonts.getFont(titleFontName).fontFamily!;
      } catch (e) {
        titleFontName = 'Ubuntu';
      }
    }

    String bodyFontName = bodyFont?.name ?? 'Ubuntu';
    if (bodyFont?.source == FontSource.google) {
      try {
        bodyFontName = GoogleFonts.getFont(bodyFontName).fontFamily!;
      } catch (e) {
        bodyFontName = 'Ubuntu';
      }
    }

    return TextTheme(
      displayLarge: defaultTextTheme.displayLarge?.copyWith(
        color: isDark ? Colors.white : titleTextColor,
        fontFamily: titleFontName,
        fontFamilyFallback: [
          GoogleFonts.ubuntu().fontFamily!,
          'Roboto',
        ],
        overflow: TextOverflow.visible,
      ),
      displayMedium: defaultTextTheme.displayMedium?.copyWith(
        color: isDark ? Colors.white : titleTextColor,
        fontFamily: titleFontName,
        fontFamilyFallback: [
          GoogleFonts.ubuntu().fontFamily!,
          'Roboto',
        ],
        overflow: TextOverflow.visible,
      ),
      displaySmall: defaultTextTheme.displaySmall?.copyWith(
        color: isDark ? Colors.white : titleTextColor,
        fontFamily: titleFontName,
        fontFamilyFallback: [
          GoogleFonts.ubuntu().fontFamily!,
          'Roboto',
        ],
        overflow: TextOverflow.visible,
      ),
      headlineLarge: defaultTextTheme.headlineLarge?.copyWith(
        color: isDark ? Colors.white : titleTextColor,
        fontFamily: titleFontName,
        fontFamilyFallback: [
          GoogleFonts.ubuntu().fontFamily!,
          'Roboto',
        ],
        overflow: TextOverflow.visible,
      ),
      headlineMedium: defaultTextTheme.headlineMedium?.copyWith(
        color: isDark ? Colors.white : titleTextColor,
        fontFamily: titleFontName,
        fontFamilyFallback: [
          GoogleFonts.ubuntu().fontFamily!,
          'Roboto',
        ],
        overflow: TextOverflow.visible,
      ),
      headlineSmall: defaultTextTheme.headlineSmall?.copyWith(
        color: isDark ? Colors.white : titleTextColor,
        fontFamily: titleFontName,
        fontFamilyFallback: [
          GoogleFonts.ubuntu().fontFamily!,
          'Roboto',
        ],
        overflow: TextOverflow.visible,
      ),
      titleLarge: defaultTextTheme.titleLarge?.copyWith(
        fontFamily: titleFontName,
        fontFamilyFallback: [
          GoogleFonts.ubuntu().fontFamily!,
          'Roboto',
        ],
        overflow: TextOverflow.visible,
      ),
      titleMedium: defaultTextTheme.titleMedium?.copyWith(
        fontFamily: titleFontName,
        fontFamilyFallback: [
          GoogleFonts.ubuntu().fontFamily!,
          'Roboto',
        ],
        overflow: TextOverflow.visible,
      ),
      titleSmall: defaultTextTheme.titleSmall?.copyWith(
        fontFamily: titleFontName,
        fontFamilyFallback: [
          GoogleFonts.ubuntu().fontFamily!,
          'Roboto',
        ],
        overflow: TextOverflow.visible,
      ),
      bodyLarge: defaultTextTheme.bodyLarge?.copyWith(
        fontFamily: bodyFontName,
        fontFamilyFallback: [
          GoogleFonts.ubuntu().fontFamily!,
          'Roboto',
        ],
        overflow: TextOverflow.visible,
      ),
      bodyMedium: defaultTextTheme.bodyMedium?.copyWith(
        fontFamily: bodyFontName,
        fontFamilyFallback: [
          GoogleFonts.ubuntu().fontFamily!,
          'Roboto',
        ],
        overflow: TextOverflow.visible,
      ),
      bodySmall: defaultTextTheme.bodySmall?.copyWith(
        fontFamily: bodyFontName,
        fontFamilyFallback: [
          GoogleFonts.ubuntu().fontFamily!,
          'Roboto',
        ],
        overflow: TextOverflow.visible,
      ),
      labelLarge: defaultTextTheme.bodySmall?.copyWith(
        fontFamily: bodyFontName,
        fontFamilyFallback: [
          GoogleFonts.ubuntu().fontFamily!,
          'Roboto',
        ],
        overflow: TextOverflow.visible,
      ),
      labelMedium: defaultTextTheme.bodySmall?.copyWith(
        fontFamily: bodyFontName,
        fontFamilyFallback: [
          GoogleFonts.ubuntu().fontFamily!,
          'Roboto',
        ],
        overflow: TextOverflow.visible,
      ),
      labelSmall: defaultTextTheme.bodySmall?.copyWith(
        fontFamily: bodyFontName,
        fontFamilyFallback: [
          GoogleFonts.ubuntu().fontFamily!,
          'Roboto',
        ],
        overflow: TextOverflow.visible,
      ),
    );
  }
}
