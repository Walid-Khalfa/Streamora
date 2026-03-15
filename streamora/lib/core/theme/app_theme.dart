import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surfaceDark,
          background: AppColors.backgroundDark,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.textPrimaryDark,
          onBackground: AppColors.textPrimaryDark,
          onError: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.backgroundDark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
        ),
        cardTheme: CardTheme(
          color: AppColors.cardDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          hintStyle: TextStyle(
            color: AppColors.textTertiaryDark,
            fontSize: 14.sp,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            textStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimaryDark,
            side: const BorderSide(color: AppColors.gray700),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
          headlineLarge: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 16.sp,
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
          bodySmall: TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 12.sp,
            fontWeight: FontWeight.normal,
          ),
          labelLarge: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          labelMedium: TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          labelSmall: TextStyle(
            color: AppColors.textTertiaryDark,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceDark,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 12.sp,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.surfaceDark,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiaryDark,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500),
          unselectedLabelStyle: TextStyle(fontSize: 11.sp),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondaryDark,
          indicatorColor: AppColors.primary,
          labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 14.sp),
        ),
        dividerTheme: DividerThemeData(
          color: AppColors.gray800,
          thickness: 1,
          space: 1,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surfaceDark,
          contentTextStyle: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 14.sp,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

  static ThemeData get lightTheme => darkTheme.copyWith(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surfaceLight,
          background: AppColors.backgroundLight,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.textPrimaryLight,
          onBackground: AppColors.textPrimaryLight,
          onError: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
        ),
        cardTheme: CardTheme(
          color: AppColors.cardLight,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.gray100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          hintStyle: TextStyle(
            color: AppColors.textTertiaryLight,
            fontSize: 14.sp,
          ),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
          headlineLarge: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 16.sp,
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
          bodySmall: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: 12.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.gray100,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 12.sp,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiaryLight,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500),
          unselectedLabelStyle: TextStyle(fontSize: 11.sp),
        ),
        dividerTheme: DividerThemeData(
          color: AppColors.gray200,
          thickness: 1,
          space: 1,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.gray900,
          contentTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
}
