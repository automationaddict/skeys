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
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:skeys_app/core/backend/daemon_status_service.dart';
import 'package:skeys_app/features/agent/bloc/agent_bloc.dart';
import 'package:skeys_app/features/agent/repository/agent_repository.dart';
import 'package:skeys_app/core/settings/settings_service.dart';
import '../../../mocks/mocks.dart';
import '../../../mocks/test_helpers.dart';

void main() {
  late MockAgentRepository mockAgentRepository;
  late MockSettingsService mockSettingsService;
  late MockDaemonStatusService mockDaemonStatusService;
  final getIt = GetIt.instance;

  setUpAll(() {
    // Register fallback values
    registerFallbackValue(const Duration(minutes: 30));
  });

  setUp(() {
    mockAgentRepository = MockAgentRepository();
    mockSettingsService = MockSettingsService();
    mockDaemonStatusService = MockDaemonStatusService();

    // Register mock settings service in getIt
    if (getIt.isRegistered<SettingsService>()) {
      getIt.unregister<SettingsService>();
    }
    getIt.registerSingleton<SettingsService>(mockSettingsService);

    // Register mock DaemonStatusService
    if (getIt.isRegistered<DaemonStatusService>()) {
      getIt.unregister<DaemonStatusService>();
    }
    getIt.registerSingleton<DaemonStatusService>(mockDaemonStatusService);

    // Default mock for watchAgent (used in constructor)
    when(() => mockAgentRepository.watchAgent()).thenAnswer(
      (_) => Stream.fromIterable([
        AgentWatchState(
          status: TestDataFactory.createAgentStatus(),
          keys: [],
        ),
      ]),
    );

    // Default mock for settings
    when(() => mockSettingsService.agentKeyTimeoutMinutes).thenReturn(30);
  });

  tearDown(() {
    if (getIt.isRegistered<SettingsService>()) {
      getIt.unregister<SettingsService>();
    }
    if (getIt.isRegistered<DaemonStatusService>()) {
      getIt.unregister<DaemonStatusService>();
    }
  });

  group('AgentBloc', () {
    blocTest<AgentBloc, AgentState>(
      'auto-starts watching on creation and emits success',
      setUp: () {
        final agentStatus = TestDataFactory.createAgentStatus(keyCount: 2);
        final keys = [
          TestDataFactory.createAgentKeyEntry(fingerprint: 'fp1'),
          TestDataFactory.createAgentKeyEntry(fingerprint: 'fp2'),
        ];
        when(() => mockAgentRepository.watchAgent()).thenAnswer(
          (_) => Stream.fromIterable([
            AgentWatchState(status: agentStatus, keys: keys),
          ]),
        );
      },
      build: () => AgentBloc(mockAgentRepository),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, AgentBlocStatus.success);
        expect(bloc.state.loadedKeys.length, 2);
        expect(bloc.state.agentStatus?.isRunning, true);
        verify(() => mockAgentRepository.watchAgent()).called(1);
      },
    );

    blocTest<AgentBloc, AgentState>(
      'emits failure when watchAgent throws error',
      setUp: () {
        when(() => mockAgentRepository.watchAgent()).thenAnswer(
          (_) => Stream.error(Exception('Connection lost')),
        );
      },
      build: () => AgentBloc(mockAgentRepository),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, AgentBlocStatus.failure);
      },
    );

    blocTest<AgentBloc, AgentState>(
      'AgentLoadStatusRequested loads agent status',
      setUp: () {
        final agentStatus = TestDataFactory.createAgentStatus(keyCount: 3);
        when(() => mockAgentRepository.watchAgent()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockAgentRepository.getStatus()).thenAnswer(
          (_) async => agentStatus,
        );
      },
      build: () => AgentBloc(mockAgentRepository),
      act: (bloc) => bloc.add(const AgentLoadStatusRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, AgentBlocStatus.success);
        expect(bloc.state.agentStatus?.keyCount, 3);
        verify(() => mockAgentRepository.getStatus()).called(1);
      },
    );

    blocTest<AgentBloc, AgentState>(
      'AgentLoadKeysRequested loads agent keys',
      setUp: () {
        final keys = [
          TestDataFactory.createAgentKeyEntry(fingerprint: 'fp1'),
          TestDataFactory.createAgentKeyEntry(fingerprint: 'fp2'),
        ];
        when(() => mockAgentRepository.watchAgent()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockAgentRepository.listKeys()).thenAnswer(
          (_) async => keys,
        );
      },
      build: () => AgentBloc(mockAgentRepository),
      act: (bloc) => bloc.add(const AgentLoadKeysRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, AgentBlocStatus.success);
        expect(bloc.state.loadedKeys.length, 2);
        verify(() => mockAgentRepository.listKeys()).called(1);
      },
    );

    blocTest<AgentBloc, AgentState>(
      'AgentAddKeyRequested adds key and reloads',
      setUp: () {
        final key = TestDataFactory.createAgentKeyEntry();
        final agentStatus = TestDataFactory.createAgentStatus(keyCount: 1);
        when(() => mockAgentRepository.watchAgent()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockAgentRepository.addKey(
              any(),
              passphrase: any(named: 'passphrase'),
              lifetime: any(named: 'lifetime'),
              confirm: any(named: 'confirm'),
            )).thenAnswer((_) async {});
        when(() => mockAgentRepository.listKeys()).thenAnswer(
          (_) async => [key],
        );
        when(() => mockAgentRepository.getStatus()).thenAnswer(
          (_) async => agentStatus,
        );
      },
      build: () => AgentBloc(mockAgentRepository),
      act: (bloc) => bloc.add(
        const AgentAddKeyRequested(keyPath: '/home/user/.ssh/id_ed25519'),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, AgentBlocStatus.success);
        expect(bloc.state.loadedKeys.length, 1);
        verify(() => mockAgentRepository.addKey(
              '/home/user/.ssh/id_ed25519',
              passphrase: null,
              lifetime: const Duration(minutes: 30),
              confirm: false,
            )).called(1);
      },
    );

    blocTest<AgentBloc, AgentState>(
      'AgentRemoveKeyRequested removes key and reloads',
      setUp: () {
        final agentStatus = TestDataFactory.createAgentStatus(keyCount: 0);
        when(() => mockAgentRepository.watchAgent()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockAgentRepository.removeKey(any())).thenAnswer(
          (_) async {},
        );
        when(() => mockAgentRepository.listKeys()).thenAnswer(
          (_) async => [],
        );
        when(() => mockAgentRepository.getStatus()).thenAnswer(
          (_) async => agentStatus,
        );
      },
      build: () => AgentBloc(mockAgentRepository),
      act: (bloc) => bloc.add(
        const AgentRemoveKeyRequested('SHA256:abc123'),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, AgentBlocStatus.success);
        expect(bloc.state.loadedKeys.length, 0);
        verify(() => mockAgentRepository.removeKey('SHA256:abc123')).called(1);
      },
    );

    blocTest<AgentBloc, AgentState>(
      'AgentRemoveAllKeysRequested removes all keys',
      setUp: () {
        final agentStatus = TestDataFactory.createAgentStatus(keyCount: 0);
        when(() => mockAgentRepository.watchAgent()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockAgentRepository.removeAllKeys()).thenAnswer(
          (_) async {},
        );
        when(() => mockAgentRepository.getStatus()).thenAnswer(
          (_) async => agentStatus,
        );
      },
      build: () => AgentBloc(mockAgentRepository),
      act: (bloc) => bloc.add(const AgentRemoveAllKeysRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, AgentBlocStatus.success);
        expect(bloc.state.loadedKeys, isEmpty);
        verify(() => mockAgentRepository.removeAllKeys()).called(1);
      },
    );

    blocTest<AgentBloc, AgentState>(
      'AgentLockRequested locks the agent',
      setUp: () {
        final agentStatus = TestDataFactory.createAgentStatus(isLocked: true);
        when(() => mockAgentRepository.watchAgent()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockAgentRepository.lock(any())).thenAnswer(
          (_) async {},
        );
        when(() => mockAgentRepository.getStatus()).thenAnswer(
          (_) async => agentStatus,
        );
      },
      build: () => AgentBloc(mockAgentRepository),
      act: (bloc) => bloc.add(const AgentLockRequested('secret')),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, AgentBlocStatus.success);
        expect(bloc.state.agentStatus?.isLocked, true);
        verify(() => mockAgentRepository.lock('secret')).called(1);
      },
    );

    blocTest<AgentBloc, AgentState>(
      'AgentUnlockRequested unlocks the agent',
      setUp: () {
        final agentStatus = TestDataFactory.createAgentStatus(isLocked: false);
        when(() => mockAgentRepository.watchAgent()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockAgentRepository.unlock(any())).thenAnswer(
          (_) async {},
        );
        when(() => mockAgentRepository.getStatus()).thenAnswer(
          (_) async => agentStatus,
        );
      },
      build: () => AgentBloc(mockAgentRepository),
      act: (bloc) => bloc.add(const AgentUnlockRequested('secret')),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, AgentBlocStatus.success);
        expect(bloc.state.agentStatus?.isLocked, false);
        verify(() => mockAgentRepository.unlock('secret')).called(1);
      },
    );
  });

  group('AgentKeyEntry', () {
    test('equality works correctly', () {
      final key1 = TestDataFactory.createAgentKeyEntry();
      final key2 = TestDataFactory.createAgentKeyEntry();
      final key3 = TestDataFactory.createAgentKeyEntry(fingerprint: 'different');

      expect(key1, key2);
      expect(key1, isNot(key3));
    });
  });

  group('AgentStatus', () {
    test('equality works correctly', () {
      final status1 = TestDataFactory.createAgentStatus();
      final status2 = TestDataFactory.createAgentStatus();
      final status3 = TestDataFactory.createAgentStatus(isRunning: false);

      expect(status1, status2);
      expect(status1, isNot(status3));
    });
  });

  group('AgentState', () {
    test('initial state has correct defaults', () {
      const state = AgentState();

      expect(state.status, AgentBlocStatus.initial);
      expect(state.agentStatus, isNull);
      expect(state.loadedKeys, isEmpty);
      expect(state.errorMessage, isNull);
    });

    test('copyWith preserves existing values', () {
      final status = TestDataFactory.createAgentStatus();
      final state = AgentState(
        status: AgentBlocStatus.success,
        agentStatus: status,
      );

      final copied = state.copyWith(errorMessage: 'error');

      expect(copied.status, AgentBlocStatus.success);
      expect(copied.agentStatus, status);
      expect(copied.errorMessage, 'error');
    });
  });
}
