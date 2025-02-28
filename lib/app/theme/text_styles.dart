import 'package:flutter/material.dart';


class AppTextStyles {
  AppTextStyles._();
  
  static const String _fontFamily = 'Gilroy';
  
  /// Large title text style (32px, semibold)
  static TextStyle get largeTitle => const TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 32,
    height: 39.2 / 32, // lineHeight / fontSize for Flutter's height parameter
    letterSpacing: 0,
  );
  
  /// Medium text style (16px, medium)
  static TextStyle get medium => const TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 19.41 / 16,
    letterSpacing: 0,
  );
  
  /// Semibold small text style (15px, semibold)
  static TextStyle get smallSemiBold => const TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 15,
    height: 18.38 / 15,
    letterSpacing: 0,
  );
  
  /// Extra small text style (12px, medium)
  static TextStyle get extraSmall => const TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 14.56 / 12,
    letterSpacing: 0,
  );
  
  /// Extra small centered text style (12px, medium, centered)
  static TextStyle get extraSmallCentered => extraSmall.copyWith(
  );
  
  /// Bold title text style (20px, bold)
  static TextStyle get boldTitle => const TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 24.76 / 20,
    letterSpacing: 0,
  );
  
  /// Extra small right-aligned text style (12px, medium, right-aligned)
  static TextStyle get extraSmallRight => extraSmall.copyWith(
  );
  
  /// Small text style (14px, medium)
  static TextStyle get small => const TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 16.98 / 14,
    letterSpacing: 0,
  );
}
