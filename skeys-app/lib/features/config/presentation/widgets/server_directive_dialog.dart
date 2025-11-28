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

import '../../domain/sshd_directives.dart';

/// Dialog for editing an SSH server directive.
class ServerDirectiveDialog extends StatefulWidget {
  /// The directive key being edited.
  final String directiveKey;

  /// The current value of the directive.
  final String? currentValue;

  /// Callback when the directive is saved.
  final void Function(String value) onSave;

  /// Creates a ServerDirectiveDialog widget.
  const ServerDirectiveDialog({
    super.key,
    required this.directiveKey,
    this.currentValue,
    required this.onSave,
  });

  @override
  State<ServerDirectiveDialog> createState() => _ServerDirectiveDialogState();
}

class _ServerDirectiveDialogState extends State<ServerDirectiveDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _valueController;
  String? _selectedDropdownValue;

  final _valueFocusNode = FocusNode();

  SshdDirectiveDefinition? get _directive =>
      sshdDirectiveMap[widget.directiveKey];

  @override
  void initState() {
    super.initState();
    final initialValue = widget.currentValue ?? _directive?.defaultValue ?? '';
    _valueController = TextEditingController(text: initialValue);

    // Initialize dropdown value if this directive has constrained options
    if (_directive?.valueType == SshdValueType.selection ||
        _directive?.valueType == SshdValueType.boolean) {
      final options = _getValueOptions();
      if (options != null && options.contains(initialValue)) {
        _selectedDropdownValue = initialValue;
      }
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    _valueFocusNode.dispose();
    super.dispose();
  }

  List<String>? _getValueOptions() {
    if (_directive == null) return null;

    if (_directive!.valueType == SshdValueType.boolean) {
      return ['yes', 'no'];
    }
    if (_directive!.valueType == SshdValueType.selection) {
      return _directive!.allowedValues;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit ${widget.directiveKey}',
                          style: theme.textTheme.titleLarge,
                        ),
                        if (_directive != null)
                          Text(
                            _directive!.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Value field
                      _buildValueField(theme, colorScheme),
                      const SizedBox(height: 16),
                      // Default value info
                      if (_directive != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 18,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Default: ${_directive!.defaultValue}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                              if (_directive!.hint != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  _directive!.hint!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_directive != null)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _valueController.text = _directive!.defaultValue;
                          final options = _getValueOptions();
                          if (options != null &&
                              options.contains(_directive!.defaultValue)) {
                            _selectedDropdownValue = _directive!.defaultValue;
                          }
                        });
                      },
                      child: const Text('Reset to Default'),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(onPressed: _save, child: const Text('Save')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueField(ThemeData theme, ColorScheme colorScheme) {
    final options = _getValueOptions();

    // If directive has constrained options, show dropdown
    if (options != null) {
      return DropdownButtonFormField<String>(
        initialValue: _selectedDropdownValue,
        decoration: InputDecoration(
          labelText: 'Value',
          prefixIcon: const Icon(Icons.list),
          helperText: _directive?.hint,
        ),
        items: options.map((option) {
          return DropdownMenuItem<String>(value: option, child: Text(option));
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedDropdownValue = value;
            _valueController.text = value ?? '';
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a value';
          }
          return null;
        },
      );
    }

    // Otherwise show appropriate text field
    return TextFormField(
      controller: _valueController,
      focusNode: _valueFocusNode,
      decoration: InputDecoration(
        labelText: 'Value',
        prefixIcon: Icon(_getInputIcon()),
        hintText: _getInputHint(),
        helperText: _directive?.hint,
      ),
      keyboardType: _getKeyboardType(),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _save(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return _validateValue(value);
      },
    );
  }

  IconData _getInputIcon() {
    if (_directive == null) return Icons.text_fields;

    switch (_directive!.valueType) {
      case SshdValueType.integer:
      case SshdValueType.port:
        return Icons.numbers;
      case SshdValueType.path:
        return Icons.folder;
      case SshdValueType.address:
        return Icons.language;
      case SshdValueType.duration:
        return Icons.timer;
      case SshdValueType.list:
        return Icons.list_alt;
      default:
        return Icons.text_fields;
    }
  }

  String? _getInputHint() {
    if (_directive == null) return null;

    switch (_directive!.valueType) {
      case SshdValueType.integer:
        return 'Enter a number';
      case SshdValueType.port:
        return 'e.g., 22 or 2222';
      case SshdValueType.path:
        return 'e.g., /etc/ssh/...';
      case SshdValueType.address:
        return 'e.g., 0.0.0.0 or ::';
      case SshdValueType.duration:
        return 'e.g., 30, 5m, 1h';
      case SshdValueType.list:
        return 'Space or comma separated';
      default:
        return null;
    }
  }

  TextInputType _getKeyboardType() {
    if (_directive == null) return TextInputType.text;

    switch (_directive!.valueType) {
      case SshdValueType.integer:
      case SshdValueType.port:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  String? _validateValue(String value) {
    if (_directive == null) return null;

    switch (_directive!.valueType) {
      case SshdValueType.integer:
        if (int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        break;
      case SshdValueType.port:
        final port = int.tryParse(value);
        if (port == null || port < 1 || port > 65535) {
          return 'Please enter a valid port (1-65535)';
        }
        break;
      default:
        break;
    }
    return null;
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      // Use dropdown value if available, otherwise text controller
      final value = _getValueOptions() != null
          ? (_selectedDropdownValue ?? '')
          : _valueController.text.trim();
      widget.onSave(value);
      Navigator.of(context).pop();
    }
  }
}
