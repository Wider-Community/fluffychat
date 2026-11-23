// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:math';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class EmptyPage extends StatelessWidget {
  static const double _width = 400;

  /// MUQAM: when true, shows the Wider "Start Conversation" panel with a
  /// New chat button instead of the plain logo.
  final bool startConversation;

  const EmptyPage({this.startConversation = false, super.key});
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.sizeOf(context).width, EmptyPage._width) / 2;
    final theme = Theme.of(context);
    return Scaffold(
      // Add invisible appbar to make status bar on Android tablets bright.
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: startConversation
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withAlpha(18),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.mail_outline,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      L10n.of(context).startConversation,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 360),
                      child: Text(
                        L10n.of(context).startConversationDescription,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 230,
                      child: FilledButton(
                        onPressed: () => context.go('/rooms/newprivatechat'),
                        child: Text(L10n.of(context).newChat),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/logo/mini/logo_mono_mini.png',
                color: theme.colorScheme.surfaceContainerHigh,
                width: width,
                height: width,
                filterQuality: FilterQuality.medium,
              ),
            ),
    );
  }
}
