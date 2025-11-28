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

import 'package:mocktail/mocktail.dart';

import 'package:skeys_app/features/keys/repository/keys_repository.dart';
import 'package:skeys_app/features/hosts/repository/hosts_repository.dart';
import 'package:skeys_app/features/agent/repository/agent_repository.dart';
import 'package:skeys_app/features/config/repository/config_repository.dart';
import 'package:skeys_app/features/remote/repository/remote_repository.dart';
import 'package:skeys_app/features/metadata/repository/metadata_repository.dart';
import 'package:skeys_app/core/settings/settings_service.dart';

/// Mock implementation of KeysRepository for testing.
class MockKeysRepository extends Mock implements KeysRepository {}

/// Mock implementation of HostsRepository for testing.
class MockHostsRepository extends Mock implements HostsRepository {}

/// Mock implementation of AgentRepository for testing.
class MockAgentRepository extends Mock implements AgentRepository {}

/// Mock implementation of ConfigRepository for testing.
class MockConfigRepository extends Mock implements ConfigRepository {}

/// Mock implementation of RemoteRepository for testing.
class MockRemoteRepository extends Mock implements RemoteRepository {}

/// Mock implementation of MetadataRepository for testing.
class MockMetadataRepository extends Mock implements MetadataRepository {}

/// Mock implementation of SettingsService for testing.
class MockSettingsService extends Mock implements SettingsService {}
