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

import 'package:skeys_app/features/config/bloc/server_config_bloc.dart';
import 'package:skeys_app/features/config/repository/config_repository.dart';
import '../../../mocks/mocks.dart';
import '../../../mocks/test_helpers.dart';

void main() {
  late MockConfigRepository mockConfigRepository;

  setUpAll(() {
    // Register fallback values for any() matchers
    registerFallbackValue([
      const ServerConfigUpdate(key: 'Port', value: '22'),
    ]);
  });

  setUp(() {
    mockConfigRepository = MockConfigRepository();
  });

  group('ServerConfigBloc', () {
    blocTest<ServerConfigBloc, ServerConfigState>(
      'ServerConfigLoadRequested loads server config',
      setUp: () {
        final serverConfig = TestDataFactory.createServerConfig();
        when(() => mockConfigRepository.getServerConfig()).thenAnswer(
          (_) async => serverConfig,
        );
      },
      build: () => ServerConfigBloc(mockConfigRepository),
      act: (bloc) => bloc.add(const ServerConfigLoadRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ServerConfigStatus.success);
        expect(bloc.state.config, isNotNull);
        expect(bloc.state.config!.options.length, 2);
        verify(() => mockConfigRepository.getServerConfig()).called(1);
      },
    );

    blocTest<ServerConfigBloc, ServerConfigState>(
      'ServerConfigLoadRequested emits failure on error',
      setUp: () {
        when(() => mockConfigRepository.getServerConfig()).thenThrow(
          Exception('Permission denied'),
        );
      },
      build: () => ServerConfigBloc(mockConfigRepository),
      act: (bloc) => bloc.add(const ServerConfigLoadRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ServerConfigStatus.failure);
        expect(bloc.state.errorMessage, contains('Permission denied'));
      },
    );

    blocTest<ServerConfigBloc, ServerConfigState>(
      'ServerConfigUpdateOptionRequested updates option and sets pending restart',
      setUp: () {
        final serverConfig = TestDataFactory.createServerConfig();
        when(() => mockConfigRepository.updateServerConfig(any())).thenAnswer(
          (_) async {},
        );
        when(() => mockConfigRepository.getServerConfig()).thenAnswer(
          (_) async => serverConfig,
        );
      },
      build: () => ServerConfigBloc(mockConfigRepository),
      act: (bloc) => bloc.add(
        const ServerConfigUpdateOptionRequested(key: 'Port', value: '2222'),
      ),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ServerConfigStatus.success);
        expect(bloc.state.pendingRestart, true);
        verify(() => mockConfigRepository.updateServerConfig(any())).called(1);
      },
    );

    blocTest<ServerConfigBloc, ServerConfigState>(
      'ServerConfigRestartRequested restarts server and clears pending flag',
      setUp: () {
        when(() => mockConfigRepository.restartSSHServer()).thenAnswer(
          (_) async {},
        );
      },
      build: () => ServerConfigBloc(mockConfigRepository),
      seed: () => const ServerConfigState(
        status: ServerConfigStatus.success,
        pendingRestart: true,
      ),
      act: (bloc) => bloc.add(const ServerConfigRestartRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status, ServerConfigStatus.success);
        expect(bloc.state.pendingRestart, false);
        verify(() => mockConfigRepository.restartSSHServer()).called(1);
      },
    );

    blocTest<ServerConfigBloc, ServerConfigState>(
      'ServerConfigClearPendingRestart clears pending flag',
      build: () => ServerConfigBloc(mockConfigRepository),
      seed: () => const ServerConfigState(
        status: ServerConfigStatus.success,
        pendingRestart: true,
      ),
      act: (bloc) => bloc.add(const ServerConfigClearPendingRestart()),
      expect: () => [
        const ServerConfigState(
          status: ServerConfigStatus.success,
          pendingRestart: false,
        ),
      ],
    );
  });

  group('ServerConfigState', () {
    test('initial state has correct defaults', () {
      const state = ServerConfigState();

      expect(state.status, ServerConfigStatus.initial);
      expect(state.config, isNull);
      expect(state.pendingRestart, false);
      expect(state.errorMessage, isNull);
    });

    test('copyWith preserves existing values', () {
      final config = TestDataFactory.createServerConfig();
      final state = ServerConfigState(
        status: ServerConfigStatus.success,
        config: config,
      );

      final copied = state.copyWith(pendingRestart: true);

      expect(copied.status, ServerConfigStatus.success);
      expect(copied.config, config);
      expect(copied.pendingRestart, true);
    });
  });
}
