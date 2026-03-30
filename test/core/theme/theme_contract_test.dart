import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/theme/theme_contract.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeContract.fromJson', () {
    test('parses all fields', () {
      final t = ThemeContract.fromJson({
        'primaryColor': '#111111',
        'secondaryColor': '#222222',
        'backgroundColor': '#333333',
        'surfaceColor': '#444444',
        'errorColor': '#555555',
        'fontFamily': 'Roboto',
        'defaultFontSize': 18,
        'brightness': 'dark',
      });
      expect(t.primaryColor, '#111111');
      expect(t.secondaryColor, '#222222');
      expect(t.backgroundColor, '#333333');
      expect(t.surfaceColor, '#444444');
      expect(t.errorColor, '#555555');
      expect(t.fontFamily, 'Roboto');
      expect(t.defaultFontSize, 18);
      expect(t.brightness, 'dark');
    });

    test('empty json yields all nulls', () {
      final t = ThemeContract.fromJson({});
      expect(t.primaryColor, isNull);
      expect(t.secondaryColor, isNull);
      expect(t.backgroundColor, isNull);
      expect(t.surfaceColor, isNull);
      expect(t.errorColor, isNull);
      expect(t.fontFamily, isNull);
      expect(t.defaultFontSize, isNull);
      expect(t.brightness, isNull);
    });
  });

  group('ThemeContract.applyTo', () {
    test('light base gets primary color override', () {
      const contract = ThemeContract(primaryColor: '#FF0000');
      final base = ThemeData.light();
      final applied = contract.applyTo(base);
      expect(applied.colorScheme.primary, const Color(0xFFFF0000));
    });

    test('brightness dark selects dark color scheme branch', () {
      const contract = ThemeContract(
        brightness: 'dark',
        primaryColor: '#00FF00',
      );
      final base = ThemeData.light();
      final applied = contract.applyTo(base);
      expect(applied.brightness, Brightness.dark);
      expect(applied.colorScheme.primary, const Color(0xFF00FF00));
    });

    test('applies fontFamily to text theme', () {
      const contract = ThemeContract(fontFamily: 'CustomFont');
      final base = ThemeData.light();
      final applied = contract.applyTo(base);
      expect(applied.textTheme.bodyLarge?.fontFamily, 'CustomFont');
    });

    test('applies defaultFontSize via fontSize delta from 14', () {
      const contract = ThemeContract(defaultFontSize: 16);
      final base = ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 57),
          displayMedium: TextStyle(fontSize: 45),
          displaySmall: TextStyle(fontSize: 36),
          headlineLarge: TextStyle(fontSize: 32),
          headlineMedium: TextStyle(fontSize: 28),
          headlineSmall: TextStyle(fontSize: 24),
          titleLarge: TextStyle(fontSize: 22),
          titleMedium: TextStyle(fontSize: 16),
          titleSmall: TextStyle(fontSize: 14),
          bodyLarge: TextStyle(fontSize: 14),
          bodyMedium: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12),
          labelLarge: TextStyle(fontSize: 14),
          labelMedium: TextStyle(fontSize: 12),
          labelSmall: TextStyle(fontSize: 11),
        ),
      );
      final applied = contract.applyTo(base);
      expect(applied.textTheme.bodyLarge?.fontSize, 16);
    });
  });
}
