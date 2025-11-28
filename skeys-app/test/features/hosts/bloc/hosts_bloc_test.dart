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
import 'package:skeys_app/features/hosts/bloc/hosts_bloc.dart';
import '../../../mocks/mocks.dart';
import '../../../mocks/test_helpers.dart';

void main() {
  late MockHostsRepository mockHostsRepository;
  late MockDaemonStatusService mockDaemonStatusService;

  setUp(() {
    mockHostsRepository = MockHostsRepository();
    mockDaemonStatusService = MockDaemonStatusService();

    // Register mock DaemonStatusService
    if (getIt.isRegistered<DaemonStatusService>()) {
      getIt.unregister<DaemonStatusService>();
    }
    getIt.registerSingleton<DaemonStatusService>(mockDaemonStatusService);

    // Default mocks for auto-watch on construction
    when(() => mockHostsRepository.watchKnownHosts()).thenAnswer(
      (_) => Stream.fromIterable([<KnownHostEntry>[]]),
    );
    when(() => mockHostsRepository.watchAuthorizedKeys()).thenAnswer(
      (_) => Stream.fromIterable([<AuthorizedKeyEntry>[]]),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<DaemonStatusService>()) {
      getIt.unregister<DaemonStatusService>();
    }
  });

  group('HostsBloc', () {
    blocTest<HostsBloc, HostsState>(
      'auto-starts watching on creation',
      setUp: () {
        final hosts = [
          TestDataFactory.createKnownHostEntry(host: 'github.com'),
          TestDataFactory.createKnownHostEntry(host: 'gitlab.com'),
        ];
        final keys = [
          TestDataFactory.createAuthorizedKeyEntry(comment: 'user@home'),
        ];
        when(() => mockHostsRepository.watchKnownHosts()).thenAnswer(
          (_) => Stream.fromIterable([hosts]),
        );
        when(() => mockHostsRepository.watchAuthorizedKeys()).thenAnswer(
          (_) => Stream.fromIterable([keys]),
        );
      },
      build: () => HostsBloc(mockHostsRepository),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, HostsStatus.success);
        verify(() => mockHostsRepository.watchKnownHosts()).called(1);
        verify(() => mockHostsRepository.watchAuthorizedKeys()).called(1);
      },
    );

    blocTest<HostsBloc, HostsState>(
      'HostsLoadKnownHostsRequested emits failure on error',
      setUp: () {
        when(() => mockHostsRepository.watchKnownHosts()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.watchAuthorizedKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.listKnownHosts())
            .thenThrow(Exception('Network error'));
      },
      build: () => HostsBloc(mockHostsRepository),
      act: (bloc) => bloc.add(HostsLoadKnownHostsRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, HostsStatus.failure);
        expect(bloc.state.errorMessage, contains('Network error'));
      },
    );

    blocTest<HostsBloc, HostsState>(
      'HostsLoadKnownHostsRequested loads known hosts',
      setUp: () {
        final hosts = [
          TestDataFactory.createKnownHostEntry(host: 'example.com'),
        ];
        when(() => mockHostsRepository.watchKnownHosts()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.watchAuthorizedKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.listKnownHosts()).thenAnswer(
          (_) async => hosts,
        );
      },
      build: () => HostsBloc(mockHostsRepository),
      act: (bloc) => bloc.add(HostsLoadKnownHostsRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, HostsStatus.success);
        expect(bloc.state.knownHosts.length, 1);
        verify(() => mockHostsRepository.listKnownHosts()).called(1);
      },
    );

    blocTest<HostsBloc, HostsState>(
      'HostsRemoveKnownHostRequested removes host and reloads',
      setUp: () {
        when(() => mockHostsRepository.watchKnownHosts()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.watchAuthorizedKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.removeKnownHost(any())).thenAnswer(
          (_) async {},
        );
        when(() => mockHostsRepository.listKnownHosts()).thenAnswer(
          (_) async => [],
        );
      },
      build: () => HostsBloc(mockHostsRepository),
      act: (bloc) => bloc.add(const HostsRemoveKnownHostRequested('github.com')),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, HostsStatus.success);
        verify(() => mockHostsRepository.removeKnownHost('github.com')).called(1);
      },
    );

    blocTest<HostsBloc, HostsState>(
      'HostsHashKnownHostsRequested hashes all hosts',
      setUp: () {
        final hashedHosts = [
          TestDataFactory.createKnownHostEntry(isHashed: true),
        ];
        when(() => mockHostsRepository.watchKnownHosts()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.watchAuthorizedKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.hashKnownHosts()).thenAnswer(
          (_) async {},
        );
        when(() => mockHostsRepository.listKnownHosts()).thenAnswer(
          (_) async => hashedHosts,
        );
      },
      build: () => HostsBloc(mockHostsRepository),
      act: (bloc) => bloc.add(HostsHashKnownHostsRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, HostsStatus.success);
        expect(bloc.state.knownHosts.first.isHashed, true);
        verify(() => mockHostsRepository.hashKnownHosts()).called(1);
      },
    );

    blocTest<HostsBloc, HostsState>(
      'HostsLoadAuthorizedKeysRequested loads authorized keys',
      setUp: () {
        final keys = [
          TestDataFactory.createAuthorizedKeyEntry(comment: 'user@work'),
          TestDataFactory.createAuthorizedKeyEntry(comment: 'user@home'),
        ];
        when(() => mockHostsRepository.watchKnownHosts()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.watchAuthorizedKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.listAuthorizedKeys()).thenAnswer(
          (_) async => keys,
        );
      },
      build: () => HostsBloc(mockHostsRepository),
      act: (bloc) => bloc.add(HostsLoadAuthorizedKeysRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, HostsStatus.success);
        expect(bloc.state.authorizedKeys.length, 2);
        verify(() => mockHostsRepository.listAuthorizedKeys()).called(1);
      },
    );

    blocTest<HostsBloc, HostsState>(
      'HostsAddAuthorizedKeyRequested adds key and reloads',
      setUp: () {
        final keys = [
          TestDataFactory.createAuthorizedKeyEntry(comment: 'new@key'),
        ];
        when(() => mockHostsRepository.watchKnownHosts()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.watchAuthorizedKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.addAuthorizedKey(any())).thenAnswer(
          (_) async {},
        );
        when(() => mockHostsRepository.listAuthorizedKeys()).thenAnswer(
          (_) async => keys,
        );
      },
      build: () => HostsBloc(mockHostsRepository),
      act: (bloc) => bloc.add(
        const HostsAddAuthorizedKeyRequested('ssh-ed25519 AAAA... new@key'),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, HostsStatus.success);
        expect(bloc.state.authorizedKeys.length, 1);
        verify(() => mockHostsRepository.addAuthorizedKey(
          'ssh-ed25519 AAAA... new@key',
        )).called(1);
      },
    );

    blocTest<HostsBloc, HostsState>(
      'HostsRemoveAuthorizedKeyRequested removes key and reloads',
      setUp: () {
        when(() => mockHostsRepository.watchKnownHosts()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.watchAuthorizedKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.removeAuthorizedKey(any())).thenAnswer(
          (_) async {},
        );
        when(() => mockHostsRepository.listAuthorizedKeys()).thenAnswer(
          (_) async => [],
        );
      },
      build: () => HostsBloc(mockHostsRepository),
      act: (bloc) => bloc.add(
        const HostsRemoveAuthorizedKeyRequested('ssh-ed25519 AAAA...'),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, HostsStatus.success);
        expect(bloc.state.authorizedKeys, isEmpty);
        verify(() => mockHostsRepository.removeAuthorizedKey(
          'ssh-ed25519 AAAA...',
        )).called(1);
      },
    );

    blocTest<HostsBloc, HostsState>(
      'HostsScanHostKeysRequested scans host keys',
      setUp: () {
        final scannedKeys = [
          TestDataFactory.createScannedHostKey(hostname: 'new-server.com'),
        ];
        when(() => mockHostsRepository.watchKnownHosts()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.watchAuthorizedKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.scanHostKeys(
          any(),
          port: any(named: 'port'),
          timeout: any(named: 'timeout'),
        )).thenAnswer((_) async => scannedKeys);
      },
      build: () => HostsBloc(mockHostsRepository),
      act: (bloc) => bloc.add(
        const HostsScanHostKeysRequested('new-server.com'),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, HostsStatus.success);
        expect(bloc.state.scannedKeys.length, 1);
        expect(bloc.state.scannedKeys.first.hostname, 'new-server.com');
        verify(() => mockHostsRepository.scanHostKeys(
          'new-server.com',
          port: 22,
          timeout: 10,
        )).called(1);
      },
    );

    blocTest<HostsBloc, HostsState>(
      'HostsAddKnownHostRequested adds known host and clears scanned',
      setUp: () {
        final hosts = [
          TestDataFactory.createKnownHostEntry(host: 'new-server.com'),
        ];
        final newHost = TestDataFactory.createKnownHostEntry(host: 'new-server.com');
        when(() => mockHostsRepository.watchKnownHosts()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.watchAuthorizedKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.addKnownHost(
          any(),
          any(),
          any(),
          port: any(named: 'port'),
          hashHostname: any(named: 'hashHostname'),
        )).thenAnswer((_) async => newHost);
        when(() => mockHostsRepository.listKnownHosts()).thenAnswer(
          (_) async => hosts,
        );
      },
      build: () => HostsBloc(mockHostsRepository),
      act: (bloc) => bloc.add(
        const HostsAddKnownHostRequested(
          hostname: 'new-server.com',
          keyType: 'ssh-ed25519',
          publicKey: 'AAAA...',
        ),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, HostsStatus.success);
        expect(bloc.state.knownHosts.length, 1);
        expect(bloc.state.scannedKeys, isEmpty);
        verify(() => mockHostsRepository.addKnownHost(
          'new-server.com',
          'ssh-ed25519',
          'AAAA...',
          port: 22,
          hashHostname: false,
        )).called(1);
      },
    );

    blocTest<HostsBloc, HostsState>(
      'HostsClearScannedKeysRequested clears scanned keys',
      setUp: () {
        when(() => mockHostsRepository.watchKnownHosts()).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(() => mockHostsRepository.watchAuthorizedKeys()).thenAnswer(
          (_) => const Stream.empty(),
        );
      },
      build: () => HostsBloc(mockHostsRepository),
      seed: () => HostsState(
        status: HostsStatus.success,
        scannedKeys: [TestDataFactory.createScannedHostKey()],
      ),
      act: (bloc) => bloc.add(HostsClearScannedKeysRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.scannedKeys, isEmpty);
      },
    );
  });

  group('HostsState', () {
    test('initial state has correct defaults', () {
      const state = HostsState();

      expect(state.status, HostsStatus.initial);
      expect(state.knownHosts, isEmpty);
      expect(state.authorizedKeys, isEmpty);
      expect(state.scannedKeys, isEmpty);
      expect(state.errorMessage, isNull);
    });

    test('copyWith preserves existing values', () {
      final hosts = [TestDataFactory.createKnownHostEntry()];
      final state = HostsState(
        status: HostsStatus.success,
        knownHosts: hosts,
      );

      final copied = state.copyWith(errorMessage: 'error');

      expect(copied.status, HostsStatus.success);
      expect(copied.knownHosts, hosts);
      expect(copied.errorMessage, 'error');
    });
  });

  group('KnownHostEntry', () {
    test('equality works correctly', () {
      final host1 = TestDataFactory.createKnownHostEntry();
      final host2 = TestDataFactory.createKnownHostEntry();
      final host3 = TestDataFactory.createKnownHostEntry(host: 'different.com');

      expect(host1, host2);
      expect(host1, isNot(host3));
    });
  });

  group('AuthorizedKeyEntry', () {
    test('equality works correctly', () {
      final key1 = TestDataFactory.createAuthorizedKeyEntry();
      final key2 = TestDataFactory.createAuthorizedKeyEntry();
      final key3 = TestDataFactory.createAuthorizedKeyEntry(comment: 'different');

      expect(key1, key2);
      expect(key1, isNot(key3));
    });
  });
}
