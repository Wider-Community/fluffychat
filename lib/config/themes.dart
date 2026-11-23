// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

abstract class FluffyThemes {
  static const double columnWidth = 380.0;

  static const double maxTimelineWidth = columnWidth * 2;

  static const double navRailWidth = 80.0;

  static bool isColumnModeByWidth(double width) =>
      width > columnWidth * 2 + navRailWidth;

  static bool isColumnMode(BuildContext context) =>
      isColumnModeByWidth(MediaQuery.sizeOf(context).width);

  static bool isThreeColumnMode(BuildContext context) =>
      MediaQuery.sizeOf(context).width > FluffyThemes.columnWidth * 3.5;

  static LinearGradient backgroundGradient(BuildContext context, int alpha) {
    final colorScheme = Theme.of(context).colorScheme;
    return LinearGradient(
      begin: Alignment.topCenter,
      colors: [
        colorScheme.primaryContainer.withAlpha(alpha),
        colorScheme.secondaryContainer.withAlpha(alpha),
        colorScheme.tertiaryContainer.withAlpha(alpha),
        colorScheme.primaryContainer.withAlpha(alpha),
      ],
    );
  }

  static const Duration animationDuration = Duration(milliseconds: 250);
  static const Curve animationCurve = Curves.easeInOut;

  static ThemeData buildTheme(
    BuildContext context,
    Brightness brightness, [
    Color? seed,
  ]) {
    // MUQAM: without a color picked in settings, the app uses the Wider
    // palette exactly. A picked color still builds a scheme from that seed.
    final colorScheme = seed == null
        ? MuqamColors.scheme(brightness)
        : ColorScheme.fromSeed(
            brightness: brightness,
            seedColor: seed,
            dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
          );
    final isColumnMode = FluffyThemes.isColumnMode(context);
    final dividerColor = colorScheme.outlineVariant;
    const pill = StadiumBorder();
    final textTheme =
        Typography.material2021(platform: Theme.of(context).platform)
            .englishLike
            .merge(
              brightness == Brightness.dark
                  ? Typography.material2021().white
                  : Typography.material2021().black,
            )
            .apply(
              fontFamily: MuqamColors.fontFamily,
              fontFamilyFallback: MuqamColors.fontFamilyFallback,
              bodyColor: colorScheme.onSurface,
              displayColor: colorScheme.onSurface,
            );
    return ThemeData(
      visualDensity: VisualDensity.standard,
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: MuqamColors.fontFamily,
      fontFamilyFallback: MuqamColors.fontFamilyFallback,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      dividerColor: dividerColor,
      dividerTheme: DividerThemeData(color: dividerColor, space: 1),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          iconColor: colorScheme.onSurface,
          disabledIconColor: colorScheme.onSurface,
          selectedBackgroundColor: colorScheme.primary,
          selectedForegroundColor: colorScheme.onPrimary,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: colorScheme.primary.withAlpha(64),
        selectionHandleColor: colorScheme.primary,
      ),
      // Wider fields are pills with a thin outline that turns violet on focus.
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MuqamShell.pillRadius),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MuqamShell.pillRadius),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MuqamShell.pillRadius),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
      ),
      // Filter chips: outlined pills, solid violet when selected.
      chipTheme: ChipThemeData(
        showCheckmark: false,
        backgroundColor: colorScheme.surface,
        selectedColor: colorScheme.primary,
        secondarySelectedColor: colorScheme.primary,
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 15,
        ),
        secondaryLabelStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        side: WidgetStateBorderSide.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? BorderSide(color: colorScheme.primary)
              : BorderSide(color: colorScheme.outline),
        ),
        shape: pill,
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      appBarTheme: AppBarTheme(
        toolbarHeight: isColumnMode ? 80 : 60,
        surfaceTintColor: colorScheme.surface,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: MuqamColors.fontFamily,
          fontFamilyFallback: MuqamColors.fontFamilyFallback,
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        actionsPadding: isColumnMode
            ? const EdgeInsets.symmetric(horizontal: 16.0)
            : null,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: brightness.reversed,
          statusBarBrightness: brightness,
          systemNavigationBarIconBrightness: brightness.reversed,
          systemNavigationBarColor: colorScheme.surface,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: pill,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: pill,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(64, 44),
          padding: const EdgeInsets.symmetric(horizontal: 22),
          textStyle: const TextStyle(
            fontFamily: MuqamColors.fontFamily,
            fontFamilyFallback: MuqamColors.fontFamilyFallback,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: pill,
          foregroundColor: colorScheme.primary,
          textStyle: const TextStyle(
            fontFamily: MuqamColors.fontFamily,
            fontFamilyFallback: MuqamColors.fontFamilyFallback,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 1, color: colorScheme.outline),
          foregroundColor: colorScheme.onSurface,
          shape: pill,
          minimumSize: const Size(64, 44),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        strokeCap: StrokeCap.round,
        color: colorScheme.primary,
        refreshBackgroundColor: colorScheme.primaryContainer,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(
          fontFamily: MuqamColors.fontFamily,
          fontFamilyFallback: MuqamColors.fontFamilyFallback,
          color: colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: MuqamColors.fontFamily,
          fontFamilyFallback: MuqamColors.fontFamilyFallback,
          color: colorScheme.onSurfaceVariant,
          fontSize: 15,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MuqamShell.cardRadius),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MuqamShell.cardRadius),
        ),
      ),
      snackBarTheme: isColumnMode
          ? const SnackBarThemeData(
              showCloseIcon: true,
              behavior: SnackBarBehavior.floating,
              width: FluffyThemes.columnWidth * 1.5,
            )
          : const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shape: pill,
          padding: const EdgeInsets.all(16),
          textStyle: const TextStyle(
            fontFamily: MuqamColors.fontFamily,
            fontFamilyFallback: MuqamColors.fontFamilyFallback,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// MUQAM colors and type, taken from the Wider platform tokens
/// (tokens.css of the Wider Platform design: --primary, --surface, --line...).
abstract class MuqamColors {
  static const String fontFamily = 'TitilliumWeb';
  static const List<String> fontFamilyFallback = ['Cairo'];

  static const Color violet = Color(0xFF4F00FF);

  static ColorScheme scheme(Brightness brightness) =>
      brightness == Brightness.dark ? _dark : _light;

  static const ColorScheme _light = ColorScheme(
    brightness: Brightness.light,
    primary: violet, // --primary
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFEFE8FF), // --primary-tint
    onPrimaryContainer: violet, // --primary-ink
    primaryFixed: Color(0xFFEFE8FF),
    secondary: Color(0xFF7233FF), // --primary-soft
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFEFE8FF),
    onSecondaryContainer: Color(0xFF2E2D38),
    tertiary: Color(0xFF1F55D6), // --info
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE6EEFF),
    onTertiaryContainer: Color(0xFF1F55D6),
    error: Color(0xFFC8282B), // --danger
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFDECEC),
    onErrorContainer: Color(0xFFC8282B),
    surface: Color(0xFFFFFFFF), // --bg / --card
    onSurface: Color(0xFF0E0D14), // --ink
    onSurfaceVariant: Color(0xFF6B6978), // --muted
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF9F9FF), // --surface (page wash)
    surfaceContainer: Color(0xFFF2F1FA), // --surface-2 (bubbles, chips)
    surfaceContainerHigh: Color(0xFFECEBF5),
    surfaceContainerHighest: Color(0xFFE4E3EC),
    outline: Color(0xFFC9C8D3), // --line-strong
    outlineVariant: Color(0xFFE4E3EC), // --line
    inverseSurface: Color(0xFF0E0D14),
    onInverseSurface: Color(0xFFF4F2FB),
    inversePrimary: Color(0xFFA88BFF),
    surfaceTint: violet,
    shadow: Color(0xFF140A3C),
    scrim: Color(0xC706040E),
  );

  static const ColorScheme _dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF6A2BFF),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF241A44),
    onPrimaryContainer: Color(0xFFA88BFF),
    primaryFixed: Color(0xFFEFE8FF),
    secondary: Color(0xFF7E4BFF),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFF241A44),
    onSecondaryContainer: Color(0xFFD3D0E2),
    tertiary: Color(0xFF7AA2FF),
    onTertiary: Color(0xFF0D0B14),
    tertiaryContainer: Color(0xFF15203D),
    onTertiaryContainer: Color(0xFF7AA2FF),
    error: Color(0xFFFF6B6E),
    onError: Color(0xFF0D0B14),
    errorContainer: Color(0xFF3A1517),
    onErrorContainer: Color(0xFFFF6B6E),
    surface: Color(0xFF17141F),
    onSurface: Color(0xFFF4F2FB),
    onSurfaceVariant: Color(0xFF9692AB),
    surfaceContainerLowest: Color(0xFF0D0B14),
    surfaceContainerLow: Color(0xFF0D0B14),
    surfaceContainer: Color(0xFF1D1930),
    surfaceContainerHigh: Color(0xFF241F38),
    surfaceContainerHighest: Color(0xFF2A2639),
    outline: Color(0xFF3C3752),
    outlineVariant: Color(0xFF2A2639),
    inverseSurface: Color(0xFFF4F2FB),
    onInverseSurface: Color(0xFF0E0D14),
    inversePrimary: violet,
    surfaceTint: Color(0xFF6A2BFF),
    shadow: Color(0xFF000000),
    scrim: Color(0xCC000000),
  );
}

/// MUQAM shell: sizes and the white rounded card used on wide screens.
abstract class MuqamShell {
  static const double gutter = 16;
  static const double cardRadius = 20; // --r-xl
  static const double pillRadius = 999;

  static Widget card(BuildContext context, Widget child, {bool end = true}) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: gutter,
        bottom: gutter,
        start: end ? 0 : gutter,
        end: gutter,
      ),
      child: Material(
        color: theme.colorScheme.surface,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(cardRadius),
        child: child,
      ),
    );
  }
}

extension on Brightness {
  Brightness get reversed =>
      this == Brightness.dark ? Brightness.light : Brightness.dark;
}

// MUQAM: own messages are solid violet with white text in both themes, as
// in the Wider chat. No gradient, so both bubble colors are the same.
extension BubbleColorTheme on ThemeData {
  Color get bubbleColor => colorScheme.primary;

  Color get onBubbleColor => colorScheme.onPrimary;

  Color get secondaryBubbleColor => colorScheme.primary;
}
