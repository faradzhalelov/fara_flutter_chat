import 'dart:ui';

import 'package:fara_chat/app/theme/colors.dart';
import 'package:fara_chat/app/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

/// Enum to define the available theme modes
enum ThemeMode {
  light,
  dark,
  system,
}

@riverpod
class ThemeViewModel extends _$ThemeViewModel {
  @override
  ThemeMode build() => ThemeMode.system;

  /// Updates the theme mode
  set themeMode(ThemeMode mode) => state = mode;

  ThemeMode get themeMode => state;
}

/// Provider for the current ThemeData based on the selected theme mode
@riverpod
ThemeData currentTheme(Ref ref) {
  final themeMode = ref.watch(themeViewModelProvider);

  // If dark mode, return dark theme
  if (themeMode == ThemeMode.dark) {
    return AppTheme.theme;
  }

  // If system preference, check platform brightness
  if (themeMode == ThemeMode.system) {
    final platformBrightness = PlatformDispatcher.instance.platformBrightness;
    if (platformBrightness == Brightness.dark) {
      return AppTheme.theme;
    }
  }

  // Default to light theme
  return AppTheme.theme;
}

class AppTheme {
  AppTheme._();

  /// Creates the light theme for the application based on the Figma design.
  static ThemeData get theme => ThemeData(
        // Use Material 3 design
        useMaterial3: true,

        // Set the primary color
        primaryColor: AppColors.black,

        // Define the background color
        scaffoldBackgroundColor: AppColors.appBackground,

        // Define the app bar theme
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.headerBackground,
          foregroundColor: AppColors.whiteText,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          elevation: 0,
          titleTextStyle:
              AppTextStyles.boldTitle.copyWith(color: AppColors.whiteText),
          iconTheme: const IconThemeData(color: AppColors.backButton),
        ),

        // Define the text theme
        textTheme: TextTheme(
          // Display styles for large headers
          displayLarge:
              AppTextStyles.largeTitle.copyWith(color: AppColors.primaryText),

          // Title styles
          titleLarge:
              AppTextStyles.boldTitle.copyWith(color: AppColors.primaryText),
          titleMedium:
              AppTextStyles.medium.copyWith(color: AppColors.primaryText),

          // Body styles
          bodyLarge: AppTextStyles.small.copyWith(color: AppColors.primaryText),
          bodyMedium:
              AppTextStyles.extraSmall.copyWith(color: AppColors.secondaryText),

          // Label styles
          labelMedium:
              AppTextStyles.extraSmall.copyWith(color: AppColors.timeStampText),
        ),

        // Input decoration theme (for message input)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.messageInputBackground,
          hintStyle:
              AppTextStyles.small.copyWith(color: AppColors.secondaryText),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),

        // Divider theme
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 0.5,
          space: 0,
        ),

        // Define list tile theme for chat list items
        listTileTheme: ListTileThemeData(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          titleTextStyle:
              AppTextStyles.small.copyWith(fontWeight: FontWeight.w600),
          subtitleTextStyle:
              AppTextStyles.extraSmall.copyWith(color: AppColors.secondaryText),
        ),

        // Search bar theme
        searchBarTheme: SearchBarThemeData(
          backgroundColor:
              MaterialStateProperty.all(AppColors.searchBackground),
          textStyle: MaterialStateProperty.all(AppTextStyles.small),
          hintStyle: MaterialStateProperty.all(
              AppTextStyles.small.copyWith(color: AppColors.secondaryText),),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 16),),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        // Date chip theme for message date separators
        chipTheme: ChipThemeData(
          backgroundColor: Colors.transparent,
          labelStyle: AppTextStyles.extraSmall
              .copyWith(color: AppColors.dateSeparatorText),
          shape: StadiumBorder(
            side: BorderSide(color: AppColors.dateSeparator.withOpacity(0.2)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),

        // Color scheme
        colorScheme: const ColorScheme.light(
          primary: AppColors.black,
          onPrimary: AppColors.primaryText,
          secondary: AppColors.backButton,
          error: Colors.redAccent,
        ),
      );

  /// Custom theme extensions for specific UI elements

  // Message bubble theme
  static MessageBubbleThemeData get messageBubbleTheme =>
      const MessageBubbleThemeData(
        myMessageColor: AppColors.myMessageBubble,
        otherMessageColor: AppColors.otherMessageBubble,
        myMessageTextColor: AppColors.myMessageText,
        otherMessageTextColor: AppColors.otherMessageText,
        timeTextColor: AppColors.timeStampText,
        myBorderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(4),
        ),
        otherBorderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(16),
        ),
      );

  // Avatar theme
  static AvatarThemeData get avatarTheme => const AvatarThemeData(
        defaultBackgroundColors: [
          AppColors.avatarBackground1,
          AppColors.avatarBackground2,
          AppColors.avatarBackground3,
        ],
        textColor: AppColors.avatarText,
        size: 48,
        fontSize: 20,
      );
}

/// Custom theme data for message bubbles
class MessageBubbleThemeData {
  const MessageBubbleThemeData({
    required this.myMessageColor,
    required this.otherMessageColor,
    required this.myMessageTextColor,
    required this.otherMessageTextColor,
    required this.timeTextColor,
    required this.myBorderRadius,
    required this.otherBorderRadius,
  });
  final Color myMessageColor;
  final Color otherMessageColor;
  final Color myMessageTextColor;
  final Color otherMessageTextColor;
  final Color timeTextColor;
  final BorderRadius myBorderRadius;
  final BorderRadius otherBorderRadius;
}

/// Custom theme data for avatars
class AvatarThemeData {
  const AvatarThemeData({
    required this.defaultBackgroundColors,
    required this.textColor,
    required this.size,
    required this.fontSize,
  });
  final List<Color> defaultBackgroundColors;
  final Color textColor;
  final double size;
  final double fontSize;
}
