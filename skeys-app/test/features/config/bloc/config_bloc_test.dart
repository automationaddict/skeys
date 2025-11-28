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

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:skeys_app/features/config/bloc/config_bloc.dart';
import '../../../mocks/mocks.dart';
import '../../../mocks/test_helpers.dart';

void main() {
  late MockConfigRepository mockConfigRepository;

  setUpAll(() {
    // Register fallback values for any() matchers
    registerFallbackValue(TestDataFactory.createSSHConfigEntry());
    registerFallbackValue(TestDataFactory.createConfigHostEntry());
  });

  setUp(() {
    mockConfigRepository = MockConfigRepository();

    // Default mock for auto-watch on construction
    when(() => mockConfigRepository.watchSSHConfigEntries()).thenAnswer(
      (_) => Stream.fromIterable([<SSHConfigEntry>[]]),
    );
  });

  group('ConfigBloc', () {
    blocTest<ConfigBloc, ConfigState>(
      'auto-starts watching on creation',
      setUp: () {
        final entries = [
          TestDataFactory.createSSHConfigEntry(id: 'entry-1'),
          TestDataFactory.createSSHConfigEntry(id: 'entry-2'),
        ];
        when(() => mockConfigRepository.watchSSHConfigEntries()).thenAnswer(
          (_) => Stream.fromIterable([entries]),
        );
      },
      build: () => ConfigBloc(mockConfigRepository),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ConfigStatus.success);
        verify(() => mockConfigRepository.watchSSHConfigEntries()).called(1);
      },
    );

    blocTest<ConfigBloc, ConfigState>(
      'emits failure when watchSSHConfigEntries throws error',
      setUp: () {
        when(() => mockConfigRepository.watchSSHConfigEntries()).thenAnswer(
          (_) => Stream.error(Exception('File not found')),
        );
      },
      build: () => ConfigBloc(mockConfigRepository),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ConfigStatus.failure);
      },
    );

    blocTest<ConfigBloc, ConfigState>(
      'ConfigLoadSSHEntriesRequested loads entries',
      setUp: () {
        final entries = [
          TestDataFactory.createSSHConfigEntry(patterns: ['github.com']),
        ];
        when(() => mockConfigRepository.watchSSHConfigEntries()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockConfigRepository.listSSHConfigEntries()).thenAnswer(
          (_) async => entries,
        );
      },
      build: () => ConfigBloc(mockConfigRepository),
      act: (bloc) => bloc.add(ConfigLoadSSHEntriesRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ConfigStatus.success);
        expect(bloc.state.sshEntries.length, 1);
        verify(() => mockConfigRepository.listSSHConfigEntries()).called(1);
      },
    );

    blocTest<ConfigBloc, ConfigState>(
      'ConfigCreateSSHEntryRequested creates entry and reloads',
      setUp: () {
        final entry = TestDataFactory.createSSHConfigEntry(
          patterns: ['new-host.com'],
        );
        when(() => mockConfigRepository.watchSSHConfigEntries()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockConfigRepository.createSSHConfigEntry(
          any(),
          insertPosition: any(named: 'insertPosition'),
        )).thenAnswer((_) async => entry);
        when(() => mockConfigRepository.listSSHConfigEntries()).thenAnswer(
          (_) async => [entry],
        );
      },
      build: () => ConfigBloc(mockConfigRepository),
      act: (bloc) => bloc.add(
        ConfigCreateSSHEntryRequested(
          TestDataFactory.createSSHConfigEntry(patterns: ['new-host.com']),
        ),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ConfigStatus.success);
        expect(bloc.state.sshEntries.length, 1);
        verify(() => mockConfigRepository.createSSHConfigEntry(
          any(),
          insertPosition: null,
        )).called(1);
      },
    );

    blocTest<ConfigBloc, ConfigState>(
      'ConfigUpdateSSHEntryRequested updates entry and reloads',
      setUp: () {
        final updatedEntry = TestDataFactory.createSSHConfigEntry(
          id: 'entry-1',
          patterns: ['updated-host.com'],
        );
        when(() => mockConfigRepository.watchSSHConfigEntries()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockConfigRepository.updateSSHConfigEntry(
          any(),
          any(),
        )).thenAnswer((_) async => updatedEntry);
        when(() => mockConfigRepository.listSSHConfigEntries()).thenAnswer(
          (_) async => [updatedEntry],
        );
      },
      build: () => ConfigBloc(mockConfigRepository),
      act: (bloc) => bloc.add(
        ConfigUpdateSSHEntryRequested(
          id: 'entry-1',
          entry: TestDataFactory.createSSHConfigEntry(patterns: ['updated-host.com']),
        ),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ConfigStatus.success);
        verify(() => mockConfigRepository.updateSSHConfigEntry(
          'entry-1',
          any(),
        )).called(1);
      },
    );

    blocTest<ConfigBloc, ConfigState>(
      'ConfigDeleteSSHEntryRequested deletes entry and reloads',
      setUp: () {
        when(() => mockConfigRepository.watchSSHConfigEntries()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockConfigRepository.deleteSSHConfigEntry(any())).thenAnswer(
          (_) async {},
        );
        when(() => mockConfigRepository.listSSHConfigEntries()).thenAnswer(
          (_) async => [],
        );
      },
      build: () => ConfigBloc(mockConfigRepository),
      act: (bloc) => bloc.add(const ConfigDeleteSSHEntryRequested('entry-1')),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ConfigStatus.success);
        expect(bloc.state.sshEntries, isEmpty);
        verify(() => mockConfigRepository.deleteSSHConfigEntry('entry-1'))
            .called(1);
      },
    );

    blocTest<ConfigBloc, ConfigState>(
      'ConfigReorderSSHEntriesRequested reorders entries',
      setUp: () {
        final reorderedEntries = [
          TestDataFactory.createSSHConfigEntry(id: 'entry-2', position: 0),
          TestDataFactory.createSSHConfigEntry(id: 'entry-1', position: 1),
        ];
        when(() => mockConfigRepository.watchSSHConfigEntries()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockConfigRepository.reorderSSHConfigEntries(any()))
            .thenAnswer((_) async => reorderedEntries);
      },
      build: () => ConfigBloc(mockConfigRepository),
      act: (bloc) => bloc.add(
        const ConfigReorderSSHEntriesRequested(['entry-2', 'entry-1']),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ConfigStatus.success);
        expect(bloc.state.sshEntries.length, 2);
        verify(() => mockConfigRepository.reorderSSHConfigEntries(
          ['entry-2', 'entry-1'],
        )).called(1);
      },
    );

    blocTest<ConfigBloc, ConfigState>(
      'ConfigLoadGlobalDirectivesRequested loads global directives',
      setUp: () {
        final directives = [
          TestDataFactory.createGlobalDirective(key: 'AddKeysToAgent'),
          TestDataFactory.createGlobalDirective(key: 'IdentitiesOnly'),
        ];
        when(() => mockConfigRepository.watchSSHConfigEntries()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockConfigRepository.listGlobalDirectives()).thenAnswer(
          (_) async => directives,
        );
      },
      build: () => ConfigBloc(mockConfigRepository),
      act: (bloc) => bloc.add(ConfigLoadGlobalDirectivesRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ConfigStatus.success);
        expect(bloc.state.globalDirectives.length, 2);
        verify(() => mockConfigRepository.listGlobalDirectives()).called(1);
      },
    );

    blocTest<ConfigBloc, ConfigState>(
      'ConfigSetGlobalDirectiveRequested sets directive and reloads',
      setUp: () {
        final directive = TestDataFactory.createGlobalDirective(
          key: 'AddKeysToAgent',
          value: 'no',
        );
        final directives = [directive];
        when(() => mockConfigRepository.watchSSHConfigEntries()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockConfigRepository.setGlobalDirective(any(), any()))
            .thenAnswer((_) async => directive);
        when(() => mockConfigRepository.listGlobalDirectives()).thenAnswer(
          (_) async => directives,
        );
      },
      build: () => ConfigBloc(mockConfigRepository),
      act: (bloc) => bloc.add(
        const ConfigSetGlobalDirectiveRequested(
          key: 'AddKeysToAgent',
          value: 'no',
        ),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ConfigStatus.success);
        verify(() => mockConfigRepository.setGlobalDirective(
          'AddKeysToAgent',
          'no',
        )).called(1);
      },
    );

    blocTest<ConfigBloc, ConfigState>(
      'ConfigDeleteGlobalDirectiveRequested deletes directive and reloads',
      setUp: () {
        when(() => mockConfigRepository.watchSSHConfigEntries()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockConfigRepository.deleteGlobalDirective(any()))
            .thenAnswer((_) async {});
        when(() => mockConfigRepository.listGlobalDirectives()).thenAnswer(
          (_) async => [],
        );
      },
      build: () => ConfigBloc(mockConfigRepository),
      act: (bloc) => bloc.add(
        const ConfigDeleteGlobalDirectiveRequested('AddKeysToAgent'),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ConfigStatus.success);
        expect(bloc.state.globalDirectives, isEmpty);
        verify(() => mockConfigRepository.deleteGlobalDirective('AddKeysToAgent'))
            .called(1);
      },
    );

    blocTest<ConfigBloc, ConfigState>(
      'ConfigLoadClientHostsRequested loads client hosts',
      setUp: () {
        final hosts = [
          TestDataFactory.createConfigHostEntry(host: 'github'),
          TestDataFactory.createConfigHostEntry(host: 'gitlab'),
        ];
        when(() => mockConfigRepository.watchSSHConfigEntries()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockConfigRepository.listHostConfigs()).thenAnswer(
          (_) async => hosts,
        );
      },
      build: () => ConfigBloc(mockConfigRepository),
      act: (bloc) => bloc.add(ConfigLoadClientHostsRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ConfigStatus.success);
        expect(bloc.state.clientHosts.length, 2);
        verify(() => mockConfigRepository.listHostConfigs()).called(1);
      },
    );

    blocTest<ConfigBloc, ConfigState>(
      'ConfigLoadServerConfigRequested loads server config',
      setUp: () {
        final serverConfig = TestDataFactory.createServerConfig();
        when(() => mockConfigRepository.watchSSHConfigEntries()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockConfigRepository.getServerConfig()).thenAnswer(
          (_) async => serverConfig,
        );
      },
      build: () => ConfigBloc(mockConfigRepository),
      act: (bloc) => bloc.add(ConfigLoadServerConfigRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ConfigStatus.success);
        expect(bloc.state.serverConfig, isNotNull);
        expect(bloc.state.serverConfig!.options.length, 2);
        verify(() => mockConfigRepository.getServerConfig()).called(1);
      },
    );

    blocTest<ConfigBloc, ConfigState>(
      'ConfigRestartSSHServerRequested restarts server and clears pending flag',
      setUp: () {
        when(() => mockConfigRepository.watchSSHConfigEntries()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockConfigRepository.restartSSHServer()).thenAnswer(
          (_) async {},
        );
      },
      build: () => ConfigBloc(mockConfigRepository),
      seed: () => const ConfigState(
        status: ConfigStatus.success,
        serverConfigPendingRestart: true,
      ),
      act: (bloc) => bloc.add(ConfigRestartSSHServerRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ConfigStatus.success);
        expect(bloc.state.serverConfigPendingRestart, false);
        verify(() => mockConfigRepository.restartSSHServer()).called(1);
      },
    );
  });

  group('ConfigState', () {
    test('initial state has correct defaults', () {
      const state = ConfigState();

      expect(state.status, ConfigStatus.initial);
      expect(state.sshEntries, isEmpty);
      expect(state.globalDirectives, isEmpty);
      expect(state.clientHosts, isEmpty);
      expect(state.serverConfig, isNull);
      expect(state.serverConfigPendingRestart, false);
      expect(state.errorMessage, isNull);
    });

    test('copyWith preserves existing values', () {
      final entries = [TestDataFactory.createSSHConfigEntry()];
      final state = ConfigState(
        status: ConfigStatus.success,
        sshEntries: entries,
      );

      final copied = state.copyWith(errorMessage: 'error');

      expect(copied.status, ConfigStatus.success);
      expect(copied.sshEntries, entries);
      expect(copied.errorMessage, 'error');
    });
  });

  group('SSHConfigEntry', () {
    test('equality works correctly', () {
      final entry1 = TestDataFactory.createSSHConfigEntry();
      final entry2 = TestDataFactory.createSSHConfigEntry();
      final entry3 = TestDataFactory.createSSHConfigEntry(id: 'different');

      expect(entry1, entry2);
      expect(entry1, isNot(entry3));
    });

    test('displayName returns joined patterns', () {
      final entry = TestDataFactory.createSSHConfigEntry(
        patterns: ['github.com', '*.github.com'],
      );

      expect(entry.displayName, 'github.com, *.github.com');
    });

    test('isWildcard returns true for patterns with * or ?', () {
      final wildcard = TestDataFactory.createSSHConfigEntry(
        patterns: ['*.example.com'],
      );
      final specific = TestDataFactory.createSSHConfigEntry(
        patterns: ['example.com'],
      );

      expect(wildcard.isWildcard, true);
      expect(specific.isWildcard, false);
    });

    test('isCatchAll returns true for Host *', () {
      final catchAll = TestDataFactory.createSSHConfigEntry(patterns: ['*']);
      final notCatchAll = TestDataFactory.createSSHConfigEntry(
        patterns: ['*', 'example.com'],
      );

      expect(catchAll.isCatchAll, true);
      expect(notCatchAll.isCatchAll, false);
    });
  });

  group('SSHOptions', () {
    test('isEmpty returns true when no options are set', () {
      const options = SSHOptions();
      expect(options.isEmpty, true);
    });

    test('isEmpty returns false when options are set', () {
      const options = SSHOptions(hostname: 'example.com');
      expect(options.isEmpty, false);
    });

    test('primaryIdentityFile returns first identity file', () {
      const options = SSHOptions(
        identityFiles: ['~/.ssh/id_ed25519', '~/.ssh/id_rsa'],
      );
      expect(options.primaryIdentityFile, '~/.ssh/id_ed25519');
    });

    test('additionalIdentityFiles returns all except first', () {
      const options = SSHOptions(
        identityFiles: ['~/.ssh/id_ed25519', '~/.ssh/id_rsa', '~/.ssh/id_ecdsa'],
      );
      expect(
        options.additionalIdentityFiles,
        ['~/.ssh/id_rsa', '~/.ssh/id_ecdsa'],
      );
    });
  });
}
