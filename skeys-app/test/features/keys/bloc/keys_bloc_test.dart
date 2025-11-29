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

import 'package:skeys_app/core/backend/daemon_status_service.dart';
import 'package:skeys_app/core/di/injection.dart';
import 'package:skeys_app/features/agent/bloc/agent_bloc.dart';
import 'package:skeys_app/features/keys/bloc/keys_bloc.dart';
import '../../../mocks/mocks.dart';
import '../../../mocks/test_helpers.dart';

void main() {
  late MockKeysRepository mockKeysRepository;
  late MockRemoteRepository mockRemoteRepository;
  late MockDaemonStatusService mockDaemonStatusService;
  late MockAgentBloc mockAgentBloc;

  setUpAll(() {
    // Register fallback values for any() matchers
    registerFallbackValue(KeyType.ed25519);
  });

  setUp(() {
    mockKeysRepository = MockKeysRepository();
    mockRemoteRepository = MockRemoteRepository();
    mockDaemonStatusService = MockDaemonStatusService();
    mockAgentBloc = MockAgentBloc();

    // Register mock DaemonStatusService
    if (getIt.isRegistered<DaemonStatusService>()) {
      getIt.unregister<DaemonStatusService>();
    }
    getIt.registerSingleton<DaemonStatusService>(mockDaemonStatusService);

    // Register mock AgentBloc
    if (getIt.isRegistered<AgentBloc>()) {
      getIt.unregister<AgentBloc>();
    }
    getIt.registerSingleton<AgentBloc>(mockAgentBloc);

    // Default mock for watchKeys (used in constructor)
    when(() => mockKeysRepository.watchKeys()).thenAnswer(
      (_) => Stream.fromIterable([<KeyEntity>[]]),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<DaemonStatusService>()) {
      getIt.unregister<DaemonStatusService>();
    }
    if (getIt.isRegistered<AgentBloc>()) {
      getIt.unregister<AgentBloc>();
    }
  });

  group('KeysBloc', () {
    blocTest<KeysBloc, KeysState>(
      'auto-starts watching on creation and emits success',
      setUp: () {
        final keys = TestDataFactory.createKeyEntityList(count: 2);
        when(() => mockKeysRepository.watchKeys()).thenAnswer(
          (_) => Stream.fromIterable([keys]),
        );
      },
      build: () => KeysBloc(mockKeysRepository, mockRemoteRepository),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        // Final state should have keys and success status
        expect(bloc.state.keys.length, 2);
        expect(bloc.state.status, KeysStatus.success);
        verify(() => mockKeysRepository.watchKeys()).called(1);
      },
    );

    blocTest<KeysBloc, KeysState>(
      'emits failure when watchKeys throws error',
      setUp: () {
        when(() => mockKeysRepository.watchKeys()).thenAnswer(
          (_) => Stream.error(Exception('Network error')),
        );
      },
      build: () => KeysBloc(mockKeysRepository, mockRemoteRepository),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, KeysStatus.failure);
      },
    );

    blocTest<KeysBloc, KeysState>(
      'KeysGenerateRequested generates key and reloads list',
      setUp: () {
        final newKey = TestDataFactory.createKeyEntity(name: 'new_key');
        when(() => mockKeysRepository.watchKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockKeysRepository.generateKey(
              name: any(named: 'name'),
              type: any(named: 'type'),
              bits: any(named: 'bits'),
              comment: any(named: 'comment'),
              passphrase: any(named: 'passphrase'),
              addToAgent: any(named: 'addToAgent'),
            )).thenAnswer((_) async => newKey);
        when(() => mockKeysRepository.listKeys()).thenAnswer(
          (_) async => [newKey],
        );
      },
      build: () => KeysBloc(mockKeysRepository, mockRemoteRepository),
      act: (bloc) => bloc.add(
        const KeysGenerateRequested(name: 'new_key', type: KeyType.ed25519),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, KeysStatus.success);
        expect(bloc.state.keys.length, 1);
        verify(() => mockKeysRepository.generateKey(
              name: 'new_key',
              type: KeyType.ed25519,
              bits: null,
              comment: null,
              passphrase: null,
              addToAgent: false,
            )).called(1);
      },
    );

    blocTest<KeysBloc, KeysState>(
      'KeysDeleteRequested deletes key and reloads list',
      setUp: () {
        when(() => mockKeysRepository.watchKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockKeysRepository.deleteKey(any())).thenAnswer(
          (_) async {},
        );
        when(() => mockKeysRepository.listKeys()).thenAnswer(
          (_) async => [],
        );
      },
      build: () => KeysBloc(mockKeysRepository, mockRemoteRepository),
      act: (bloc) => bloc.add(
        const KeysDeleteRequested('/home/user/.ssh/id_ed25519'),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, KeysStatus.success);
        expect(bloc.state.keys.length, 0);
        verify(
          () => mockKeysRepository.deleteKey('/home/user/.ssh/id_ed25519'),
        ).called(1);
      },
    );

    blocTest<KeysBloc, KeysState>(
      'KeysChangePassphraseRequested changes passphrase',
      setUp: () {
        when(() => mockKeysRepository.watchKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockKeysRepository.changePassphrase(any(), any(), any()))
            .thenAnswer((_) async {});
      },
      build: () => KeysBloc(mockKeysRepository, mockRemoteRepository),
      act: (bloc) => bloc.add(
        const KeysChangePassphraseRequested(
          path: '/home/user/.ssh/id_ed25519',
          oldPassphrase: 'old',
          newPassphrase: 'new',
        ),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, KeysStatus.success);
        verify(() => mockKeysRepository.changePassphrase(
              '/home/user/.ssh/id_ed25519',
              'old',
              'new',
            )).called(1);
      },
    );

    blocTest<KeysBloc, KeysState>(
      'KeysCopyPublicKeyRequested retrieves public key',
      setUp: () {
        final key = TestDataFactory.createKeyEntity();
        when(() => mockKeysRepository.watchKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockKeysRepository.getKey(any())).thenAnswer(
          (_) async => key,
        );
      },
      build: () => KeysBloc(mockKeysRepository, mockRemoteRepository),
      act: (bloc) => bloc.add(
        const KeysCopyPublicKeyRequested('/home/user/.ssh/id_ed25519'),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, KeysStatus.success);
        expect(bloc.state.copiedPublicKey, isNotNull);
      },
    );

    blocTest<KeysBloc, KeysState>(
      'KeysTestConnectionRequested tests connection successfully',
      setUp: () {
        final result = TestDataFactory.createTestConnectionResult();
        when(() => mockKeysRepository.watchKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockRemoteRepository.testConnection(
              host: any(named: 'host'),
              port: any(named: 'port'),
              user: any(named: 'user'),
              identityFile: any(named: 'identityFile'),
              timeoutSeconds: any(named: 'timeoutSeconds'),
              passphrase: any(named: 'passphrase'),
              trustHostKey: any(named: 'trustHostKey'),
            )).thenAnswer((_) async => result);
      },
      build: () => KeysBloc(mockKeysRepository, mockRemoteRepository),
      act: (bloc) => bloc.add(
        const KeysTestConnectionRequested(
          keyPath: '/home/user/.ssh/id_ed25519',
          host: 'github.com',
          port: 22,
          user: 'git',
        ),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, KeysStatus.success);
        expect(bloc.state.testConnectionResult?.success, true);
      },
    );

    blocTest<KeysBloc, KeysState>(
      'KeysTestConnectionCleared clears test result',
      setUp: () {
        when(() => mockKeysRepository.watchKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
      },
      build: () => KeysBloc(mockKeysRepository, mockRemoteRepository),
      seed: () => KeysState(
        status: KeysStatus.success,
        testConnectionResult: const ConnectionTestResult(
          success: true,
          message: 'test',
          host: 'github.com',
        ),
      ),
      act: (bloc) => bloc.add(const KeysTestConnectionCleared()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.testConnectionResult, isNull);
      },
    );
  });

  group('KeyEntity', () {
    test('copyWith creates a new instance with replaced fields', () {
      final key = TestDataFactory.createKeyEntity();
      final copied = key.copyWith(name: 'new_name');

      expect(copied.name, 'new_name');
      expect(copied.path, key.path);
      expect(copied.type, key.type);
    });

    test('equality works correctly', () {
      final key1 = TestDataFactory.createKeyEntity();
      final key2 = TestDataFactory.createKeyEntity();
      final key3 = TestDataFactory.createKeyEntity(name: 'different');

      expect(key1, key2);
      expect(key1, isNot(key3));
    });
  });

  group('KeysState', () {
    test('initial state has correct defaults', () {
      const state = KeysState();

      expect(state.status, KeysStatus.initial);
      expect(state.keys, isEmpty);
      expect(state.errorMessage, isNull);
      expect(state.copiedPublicKey, isNull);
      expect(state.testConnectionResult, isNull);
    });

    test('copyWith preserves existing values', () {
      final keys = TestDataFactory.createKeyEntityList();
      final state = KeysState(status: KeysStatus.success, keys: keys);

      final copied = state.copyWith(errorMessage: 'error');

      expect(copied.status, KeysStatus.success);
      expect(copied.keys, keys);
      expect(copied.errorMessage, 'error');
    });

    test('clearTestResult clears test connection result', () {
      const result = ConnectionTestResult(
        success: true,
        message: 'test',
        host: 'github.com',
      );
      const state = KeysState(
        status: KeysStatus.success,
        testConnectionResult: result,
      );

      final copied = state.copyWith(clearTestResult: true);

      expect(copied.testConnectionResult, isNull);
    });
  });

  group('ConnectionTestResult', () {
    test('needsHostKeyApproval returns true for unknown hosts', () {
      const result = ConnectionTestResult(
        success: false,
        message: 'Unknown host',
        host: 'example.com',
        hostKeyStatus: HostKeyVerificationStatus.unknown,
      );

      expect(result.needsHostKeyApproval, isTrue);
      expect(result.hasHostKeyMismatch, isFalse);
    });

    test('hasHostKeyMismatch returns true for mismatched hosts', () {
      const result = ConnectionTestResult(
        success: false,
        message: 'Host key mismatch',
        host: 'example.com',
        hostKeyStatus: HostKeyVerificationStatus.mismatch,
      );

      expect(result.needsHostKeyApproval, isFalse);
      expect(result.hasHostKeyMismatch, isTrue);
    });
  });
}
