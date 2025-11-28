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

/// Domain entity for key metadata.
class KeyMetadataEntity {
  /// The path to the SSH key file.
  final String keyPath;

  /// The name of the service this key was verified with (e.g., GitHub).
  final String? verifiedService;

  /// The host this key was verified with.
  final String? verifiedHost;

  /// The port this key was verified with.
  final int? verifiedPort;

  /// The user this key was verified with.
  final String? verifiedUser;

  /// Creates a KeyMetadataEntity with the given parameters.
  KeyMetadataEntity({
    required this.keyPath,
    this.verifiedService,
    this.verifiedHost,
    this.verifiedPort,
    this.verifiedUser,
  });
}
