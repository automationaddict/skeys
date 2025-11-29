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

/// A custom AppBar with an integrated help button.
///
/// This widget extends the standard AppBar by automatically adding a help
/// button to the actions list. The help button is positioned on the right
/// side of the AppBar and triggers the provided callback when pressed.
class AppBarWithHelp extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the AppBar.
  final String title;

  /// The help route/topic associated with this page.
  /// This is used for context but not directly by this widget.
  final String helpRoute;

  /// Callback invoked when the help button is pressed.
  final VoidCallback onHelpPressed;

  /// Optional additional actions to display before the help button.
  final List<Widget>? actions;

  /// Optional bottom widget (typically a TabBar).
  final PreferredSizeWidget? bottom;

  /// Optional leading widget (typically a back button or menu icon).
  final Widget? leading;

  /// Creates an AppBar with an integrated help button.
  const AppBarWithHelp({
    super.key,
    required this.title,
    required this.helpRoute,
    required this.onHelpPressed,
    this.actions,
    this.bottom,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: Text(title),
      bottom: bottom,
      actions: [
        // Include any additional actions provided
        if (actions != null) ...actions!,
        // Always add the help button last
        IconButton(
          icon: const Icon(Icons.help_outline),
          tooltip: 'Help (F1)',
          onPressed: onHelpPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
