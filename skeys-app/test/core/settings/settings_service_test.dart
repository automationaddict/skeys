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

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:skeys_app/core/settings/settings_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsService Display Settings', () {
    late SettingsService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      service = await SettingsService.init();
    });

    group('textScale', () {
      test('defaults to normal when no preference set', () {
        expect(service.textScale, TextScale.normal);
      });

      test('returns saved text scale from preferences', () async {
        SharedPreferences.setMockInitialValues({
          'text_scale': 'large',
        });
        service = await SettingsService.init();

        expect(service.textScale, TextScale.large);
      });

      test('returns normal for invalid saved value', () async {
        SharedPreferences.setMockInitialValues({
          'text_scale': 'invalid',
        });
        service = await SettingsService.init();

        expect(service.textScale, TextScale.normal);
      });

      test('setTextScale persists to SharedPreferences', () async {
        await service.setTextScale(TextScale.extraLarge);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('text_scale'), 'extraLarge');
      });

      test('setTextScale updates textScale getter', () async {
        await service.setTextScale(TextScale.small);

        expect(service.textScale, TextScale.small);
      });

      test('setTextScale notifies listeners', () async {
        var notified = false;
        service.addListener(() {
          notified = true;
        });

        await service.setTextScale(TextScale.large);

        expect(notified, isTrue);
      });

      test('setTextScale handles all enum values correctly', () async {
        for (final scale in TextScale.values) {
          await service.setTextScale(scale);
          expect(service.textScale, scale);
        }
      });
    });

    group('themeMode', () {
      test('defaults to system when no preference set', () {
        expect(service.themeMode, AppThemeMode.system);
      });

      test('returns saved theme mode from preferences', () async {
        SharedPreferences.setMockInitialValues({
          'theme_mode': 'dark',
        });
        service = await SettingsService.init();

        expect(service.themeMode, AppThemeMode.dark);
      });

      test('returns system for invalid saved value', () async {
        SharedPreferences.setMockInitialValues({
          'theme_mode': 'invalid',
        });
        service = await SettingsService.init();

        expect(service.themeMode, AppThemeMode.system);
      });

      test('setThemeMode persists to SharedPreferences', () async {
        await service.setThemeMode(AppThemeMode.light);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('theme_mode'), 'light');
      });

      test('setThemeMode updates themeMode getter', () async {
        await service.setThemeMode(AppThemeMode.dark);

        expect(service.themeMode, AppThemeMode.dark);
      });

      test('setThemeMode notifies listeners', () async {
        var notified = false;
        service.addListener(() {
          notified = true;
        });

        await service.setThemeMode(AppThemeMode.light);

        expect(notified, isTrue);
      });

      test('setThemeMode handles all enum values correctly', () async {
        for (final mode in AppThemeMode.values) {
          await service.setThemeMode(mode);
          expect(service.themeMode, mode);
        }
      });
    });

    group('listener notifications', () {
      test('notifies multiple listeners on textScale change', () async {
        var listener1Called = false;
        var listener2Called = false;

        service.addListener(() {
          listener1Called = true;
        });
        service.addListener(() {
          listener2Called = true;
        });

        await service.setTextScale(TextScale.large);

        expect(listener1Called, isTrue);
        expect(listener2Called, isTrue);
      });

      test('notifies multiple listeners on themeMode change', () async {
        var listener1Called = false;
        var listener2Called = false;

        service.addListener(() {
          listener1Called = true;
        });
        service.addListener(() {
          listener2Called = true;
        });

        await service.setThemeMode(AppThemeMode.dark);

        expect(listener1Called, isTrue);
        expect(listener2Called, isTrue);
      });

      test('removed listener is not notified', () async {
        var notified = false;
        void listener() {
          notified = true;
        }

        service.addListener(listener);
        service.removeListener(listener);

        await service.setTextScale(TextScale.large);

        expect(notified, isFalse);
      });
    });

    group('state persistence', () {
      test('textScale persists across service instances', () async {
        await service.setTextScale(TextScale.extraLarge);

        // Create new instance
        final newService = await SettingsService.init();

        expect(newService.textScale, TextScale.extraLarge);
      });

      test('themeMode persists across service instances', () async {
        await service.setThemeMode(AppThemeMode.light);

        // Create new instance
        final newService = await SettingsService.init();

        expect(newService.themeMode, AppThemeMode.light);
      });

      test('multiple settings persist independently', () async {
        await service.setTextScale(TextScale.small);
        await service.setThemeMode(AppThemeMode.dark);

        // Create new instance
        final newService = await SettingsService.init();

        expect(newService.textScale, TextScale.small);
        expect(newService.themeMode, AppThemeMode.dark);
      });
    });

    group('rapid changes', () {
      test('handles rapid textScale changes correctly', () async {
        // Simulate rapidly changing text scale
        for (var i = 0; i < 10; i++) {
          await service.setTextScale(
            TextScale.values[i % TextScale.values.length],
          );
        }

        // Final value should be persisted
        final expected = TextScale.values[9 % TextScale.values.length];
        expect(service.textScale, expected);

        // Verify persistence
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('text_scale'), expected.name);
      });

      test('handles rapid themeMode changes correctly', () async {
        // Simulate rapidly changing theme mode
        for (var i = 0; i < 10; i++) {
          await service.setThemeMode(
            AppThemeMode.values[i % AppThemeMode.values.length],
          );
        }

        // Final value should be persisted
        final expected = AppThemeMode.values[9 % AppThemeMode.values.length];
        expect(service.themeMode, expected);

        // Verify persistence
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('theme_mode'), expected.name);
      });
    });

    group('ChangeNotifier behavior', () {
      test('implements ChangeNotifier correctly', () {
        expect(service, isA<ChangeNotifier>());
      });

      test('can add and remove listeners without errors', () {
        void listener() {}

        expect(() => service.addListener(listener), returnsNormally);
        expect(() => service.removeListener(listener), returnsNormally);
      });
    });
  });

  group('TextScale enum', () {
    test('has correct scale values', () {
      expect(TextScale.small.scale, 0.85);
      expect(TextScale.normal.scale, 1.0);
      expect(TextScale.large.scale, 1.15);
      expect(TextScale.extraLarge.scale, 1.3);
    });

    test('has correct labels', () {
      expect(TextScale.small.label, 'Small');
      expect(TextScale.normal.label, 'Normal');
      expect(TextScale.large.label, 'Large');
      expect(TextScale.extraLarge.label, 'Extra Large');
    });

    test('all values have unique names', () {
      final names = TextScale.values.map((e) => e.name).toSet();
      expect(names.length, TextScale.values.length);
    });
  });

  group('AppThemeMode enum', () {
    test('has correct labels', () {
      expect(AppThemeMode.system.label, 'System');
      expect(AppThemeMode.light.label, 'Light');
      expect(AppThemeMode.dark.label, 'Dark');
    });

    test('has correct descriptions', () {
      expect(AppThemeMode.system.description, 'Follow system preference');
      expect(AppThemeMode.light.description, 'Always use light theme');
      expect(AppThemeMode.dark.description, 'Always use dark theme');
    });

    test('all values have unique names', () {
      final names = AppThemeMode.values.map((e) => e.name).toSet();
      expect(names.length, AppThemeMode.values.length);
    });
  });
}
