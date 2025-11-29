// Copyright (c) 2025 John Nelson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:skeys_app/core/settings/settings_service.dart';
import 'package:skeys_app/core/settings/settings_dialog.dart';
import '../../mocks/mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('_DisplayTab Widget Tests', () {
    late SettingsService settingsService;
    final getIt = GetIt.instance;

    setUp(() async {
      // Clear GetIt instance before each test
      await getIt.reset();

      // Initialize SharedPreferences with mock values
      SharedPreferences.setMockInitialValues({});
      settingsService = await SettingsService.init();

      // Register SettingsService in GetIt
      getIt.registerSingleton<SettingsService>(settingsService);
    });

    tearDown(() async {
      await getIt.reset();
    });

    Widget buildTestWidget() {
      return MaterialApp(
        home: Scaffold(
          // Open directly to Display tab to avoid interference from other tabs
          body: SettingsDialog(initialTab: SettingsDialog.tabDisplay),
        ),
      );
    }

    testWidgets('displays all theme mode options', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verify all theme mode options are displayed
      for (final mode in AppThemeMode.values) {
        expect(find.text(mode.label), findsWidgets);
      }

      // Verify theme mode icons are present
      expect(find.byIcon(Icons.brightness_auto), findsWidgets); // System
      expect(find.byIcon(Icons.light_mode), findsWidgets); // Light
      expect(find.byIcon(Icons.dark_mode), findsWidgets); // Dark
    });

    testWidgets('displays all text scale options', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify all text scale options are displayed
      for (final scale in TextScale.values) {
        expect(find.text(scale.label), findsOneWidget);
        expect(
          find.text('${(scale.scale * 100).round()}% of normal size'),
          findsOneWidget,
        );
      }
    });

    testWidgets('selecting theme mode updates UI and persists',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Initially should be system (default)
      expect(settingsService.themeMode, AppThemeMode.system);

      // Find and tap the Light theme option
      final lightThemeFinder = find.ancestor(
        of: find.text('Light'),
        matching: find.byType(InkWell),
      );
      await tester.tap(lightThemeFinder);
      await tester.pumpAndSettle();

      // Verify the setting was persisted
      expect(settingsService.themeMode, AppThemeMode.light);

      // Verify the UI shows the selection
      final lightContainer = tester.widget<Container>(
        find.ancestor(
          of: find.text('Light'),
          matching: find.byType(Container),
        ).first,
      );
      final lightDecoration = lightContainer.decoration as BoxDecoration;
      expect(lightDecoration.border, isNotNull);

      // Verify the description is updated
      expect(find.text('Always use light theme'), findsOneWidget);

      // Change to Dark mode
      final darkThemeFinder = find.ancestor(
        of: find.text('Dark'),
        matching: find.byType(InkWell),
      );
      await tester.tap(darkThemeFinder);
      await tester.pumpAndSettle();

      // Verify dark mode was persisted
      expect(settingsService.themeMode, AppThemeMode.dark);
      expect(find.text('Always use dark theme'), findsOneWidget);
    });

    testWidgets('selecting text scale updates UI and persists',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Initially should be normal (default)
      expect(settingsService.textScale, TextScale.normal);

      // Find and tap the Large text scale option
      final largeFinder = find.ancestor(
        of: find.text('Large'),
        matching: find.byType(InkWell),
      );
      await tester.ensureVisible(largeFinder.first);
      await tester.pumpAndSettle();
      await tester.tap(largeFinder.first);
      await tester.pumpAndSettle();

      // Verify the setting was persisted
      expect(settingsService.textScale, TextScale.large);

      // Verify the check icon appears for selected option
      final checkIcons = find.byIcon(Icons.check_circle);
      expect(checkIcons, findsWidgets);

      // Change to Small text scale
      final smallFinder = find.ancestor(
        of: find.text('Small'),
        matching: find.byType(InkWell),
      );
      await tester.ensureVisible(smallFinder.first);
      await tester.pumpAndSettle();
      await tester.tap(smallFinder.first);
      await tester.pumpAndSettle();

      // Verify small scale was persisted
      expect(settingsService.textScale, TextScale.small);
    });

    testWidgets('preview shows correct text scale', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify preview section exists
      expect(find.text('Preview'), findsOneWidget);
      expect(
        find.text('The quick brown fox jumps over the lazy dog.'),
        findsOneWidget,
      );

      // Initial preview should show normal scale
      expect(
        find.textContaining('Currently using normal text size (100%)'),
        findsOneWidget,
      );

      // Change to Large text scale
      final largeFinder = find.ancestor(
        of: find.text('Large'),
        matching: find.byType(InkWell),
      );
      await tester.ensureVisible(largeFinder.first);
      await tester.pumpAndSettle();
      await tester.tap(largeFinder.first);
      await tester.pumpAndSettle();

      // Verify preview updates to show large scale
      expect(
        find.textContaining('Currently using large text size (115%)'),
        findsOneWidget,
      );

      // Change to Extra Large text scale
      final extraLargeFinder = find.ancestor(
        of: find.text('Extra Large'),
        matching: find.byType(InkWell),
      );
      await tester.ensureVisible(extraLargeFinder.first);
      await tester.pumpAndSettle();
      await tester.tap(extraLargeFinder.first);
      await tester.pumpAndSettle();

      // Verify preview updates to show extra large scale
      expect(
        find.textContaining('Currently using extra large text size (130%)'),
        findsOneWidget,
      );
    });

    testWidgets('selected options are visually highlighted', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // System theme should be selected initially (default)
      final systemContainer = tester.widget<Container>(
        find.ancestor(
          of: find.text('System'),
          matching: find.byType(Container),
        ).first,
      );
      final systemDecoration = systemContainer.decoration as BoxDecoration;
      expect(systemDecoration.border, isNotNull);

      // Normal text scale should be selected initially (default)
      // Find the check icon which indicates selection
      final initialCheckIcons = find.byIcon(Icons.check_circle);
      expect(initialCheckIcons, findsWidgets);

      // Tap Light theme
      final lightThemeFinder = find.ancestor(
        of: find.text('Light'),
        matching: find.byType(InkWell),
      );
      await tester.tap(lightThemeFinder);
      await tester.pumpAndSettle();

      // Verify Light theme container is highlighted
      final lightContainer = tester.widget<Container>(
        find.ancestor(
          of: find.text('Light'),
          matching: find.byType(Container),
        ).first,
      );
      final lightDecoration = lightContainer.decoration as BoxDecoration;
      expect(lightDecoration.border, isNotNull);
      expect((lightDecoration.border as Border).top.width, 2.0);

      // Tap Large text scale
      final largeFinder = find.ancestor(
        of: find.text('Large'),
        matching: find.byType(InkWell),
      );
      await tester.ensureVisible(largeFinder.first);
      await tester.pumpAndSettle();
      await tester.tap(largeFinder.first);
      await tester.pumpAndSettle();

      // Verify check icon is shown for Large text scale
      final checkIcons = find.byIcon(Icons.check_circle);
      expect(checkIcons, findsWidgets);
    });

    testWidgets('all text scale cards have Aa preview icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Each text scale option should have an 'Aa' preview
      final aaTextFinders = find.text('Aa');
      expect(aaTextFinders, findsNWidgets(TextScale.values.length));
    });

    testWidgets('theme section has proper labels and descriptions',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify theme section header
      expect(find.text('Theme'), findsOneWidget);
      expect(
        find.text('Choose your preferred color theme.'),
        findsOneWidget,
      );

      // Default description for system theme
      expect(find.text('Follow system preference'), findsOneWidget);
    });

    testWidgets('text size section has proper labels', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify text size section header
      expect(find.text('Text Size'), findsOneWidget);
      expect(
        find.text(
          'Adjust the text size throughout the application for better readability.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('display tab is scrollable', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify SingleChildScrollView exists
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('multiple theme changes persist correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Cycle through all theme modes
      for (final mode in AppThemeMode.values) {
        final modeFinder = find.ancestor(
          of: find.text(mode.label),
          matching: find.byType(InkWell),
        );
        await tester.tap(modeFinder.first);
        await tester.pumpAndSettle();

        expect(settingsService.themeMode, mode);
        expect(find.text(mode.description), findsOneWidget);
      }
    });

    testWidgets('multiple text scale changes persist correctly',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Cycle through all text scales
      for (final scale in TextScale.values) {
        final scaleFinder = find.ancestor(
          of: find.text(scale.label),
          matching: find.byType(InkWell),
        );

        // Scroll to make the widget visible if needed
        await tester.ensureVisible(scaleFinder.first);
        await tester.pumpAndSettle();

        await tester.tap(scaleFinder.first);
        await tester.pumpAndSettle();

        expect(settingsService.textScale, scale);
      }
    });
  });
}
