// App-wide theme definitions (colors, typography, light/dark mode).
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────

class AppColors {
  AppColors._();

  // Brand / Primary
  static const Color primary = Color(0xFF4648D4);
  static const Color primaryLight = Color(0xFFF2F3FF);
  static const Color gradientStart = Color(0xFF4648D4);
  static const Color gradientEnd = Color(0xFFB90538);

  // Backgrounds
  static const Color white = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFEAEDFF);
  static const Color scaffoldBg = Color(0xFFF5F6FF);

  // Text
  static const Color textDark = Color(0xFF131B2E);
  static const Color textMedium = Color(0xFF464554);
  static const Color textMuted = Color(0xFF767586);

  // Semantic
  static const Color success = Color(0xFF00885D);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF59E0B);

  // Stat tile
  static const Color statValue = Color(0xFF4648D4);
  static const Color statTileBg = Color(0xFFF2F3FF);

  // Online badge
  static const Color onlineBadge = Color(0xFF00885D);
}

// ─────────────────────────────────────────────
// TYPOGRAPHY
// ─────────────────────────────────────────────

class AppFonts {
  AppFonts._();
  static const String primary = 'PlusJakartaSans';
}

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle displayLarge = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 40 / 32,
  );

  static const TextStyle headingLarge = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 32 / 24,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 28 / 20,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 24 / 16,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textMedium,
    height: 24 / 16,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMedium,
    height: 20 / 14,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 16 / 12,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textMedium,
    height: 20 / 14,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    height: 14 / 11,
  );

  static const TextStyle statValue = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.statValue,
    height: 24 / 18,
  );

  static const TextStyle statLabel = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    height: 14 / 11,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: AppFonts.primary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    letterSpacing: 0.4,
    height: 16 / 12,
  );
}

// ─────────────────────────────────────────────
// SPACING
// ─────────────────────────────────────────────

class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  // Component-specific
  static const double cardPadding = 24.0;
  static const double statGridGap = 12.0;
  static const double avatarBorderWidth = 4.0;
  static const double badgeBorderWidth = 2.0;
}

// ─────────────────────────────────────────────
// BORDER RADIUS
// ─────────────────────────────────────────────

class AppRadius {
  AppRadius._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0;

  // Component-specific
  static const double card = 16.0;
  static const double statTile = 12.0;
  static const double gradientBanner = 12.0;
  static const double avatar = 9999.0;
  static const double badge = 9999.0;
  static const double chip = 9999.0;
  static const double button = 12.0;
  static const double input = 12.0;
}

// ─────────────────────────────────────────────
// SHADOWS
// ─────────────────────────────────────────────

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 6,
      offset: Offset(0, 4),
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  static const List<BoxShadow> avatar = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 15,
      offset: Offset(0, 10),
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 6,
      offset: Offset(0, 4),
      spreadRadius: -4,
    ),
  ];

  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 20,
      offset: Offset(0, 8),
      spreadRadius: -4,
    ),
  ];
}

// ─────────────────────────────────────────────
// GRADIENTS
// ─────────────────────────────────────────────

class AppGradients {
  AppGradients._();

  static const LinearGradient heroBanner = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.gradientStart, AppColors.gradientEnd],
    stops: [0.0, 1.0],
  );

  static const LinearGradient primarySoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6466E9), Color(0xFF4648D4)],
  );
}

// ─────────────────────────────────────────────
// THEME DATA
// ─────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.primary,
      scaffoldBackgroundColor: AppColors.scaffoldBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.textDark,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headingSmall,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.primaryLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        hintStyle: AppTextStyles.bodyMedium,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}