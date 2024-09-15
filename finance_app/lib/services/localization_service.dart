// lib/services/localization_service.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class LocalizationService {
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ru'),
  ];

  // Default locale
  static const Locale defaultLocale = Locale('en');

  // Method to change the locale
  void changeLocale(BuildContext context, Locale locale) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    // ignore: cascade_invocations
    themeProvider.setLocale(locale);
  }

  // Retrieve current locale
  Locale getCurrentLocale(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.locale;
  }
}
