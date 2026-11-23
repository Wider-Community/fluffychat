// SPDX-FileCopyrightText: 2026 Wider Community
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

/// MUQAM: the Within mark beside the MUQAM wordmark, drawn with no circle.
class MuqamLockup extends StatelessWidget {
  final double markHeight;
  final double fontSize;

  const MuqamLockup({this.markHeight = 44, this.fontSize = 34, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    // The lockup reads left to right in every language.
    return Row(
      mainAxisSize: .min,
      textDirection: TextDirection.ltr,
      spacing: markHeight * 0.36,
      children: [
        Image.asset(
          dark
              ? './assets/logo/mini/muqam_mark_lapis.png'
              : './assets/logo/mini/muqam_mark_deep_lapis.png',
          height: markHeight,
          semanticLabel: 'MUQAM',
        ),
        Text(
          'MUQAM',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: fontSize * 0.18,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

/// MUQAM: the top of the sign in and sign up pages. The lockup and the
/// slogan, then a hairline that sets them apart from the form card.
class MuqamAuthHeader extends StatelessWidget {
  const MuqamAuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final line = theme.colorScheme.outlineVariant;
    return Column(
      mainAxisSize: .min,
      children: [
        const Hero(
          tag: 'info-logo',
          child: MuqamLockup(markHeight: 36, fontSize: 26),
        ),
        const SizedBox(height: 10),
        Text(
          L10n.of(context).appSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            height: 1.3,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 22),
        // Fades out at both ends so it reads as a divider, not a box edge.
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [line.withAlpha(0), line, line, line.withAlpha(0)],
              stops: const [0, 0.2, 0.8, 1],
            ),
          ),
        ),
      ],
    );
  }
}

/// MUQAM: the card that holds a form: a title, a short line under it, the
/// fields, and an optional footer (the switch between sign in and sign up).
class MuqamAuthCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? footer;

  const MuqamAuthCard({
    required this.title,
    required this.subtitle,
    required this.children,
    this.footer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        // A whisper of violet on white, with a soft lavender edge and shadow.
        color: Color.alphaBlend(scheme.primary.withAlpha(8), scheme.surface),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.primary.withAlpha(28)),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withAlpha(18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            ...children,
            if (footer != null) ...[const SizedBox(height: 8), footer!],
          ],
        ),
      ),
    );
  }
}

/// MUQAM: "New to MUQAM? Create account" and the other way round.
class MuqamAuthSwitch extends StatelessWidget {
  final String question;
  final String action;
  final VoidCallback? onPressed;

  const MuqamAuthSwitch({
    required this.question,
    required this.action,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          question,
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            action,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

/// MUQAM: the page around the header and the card. Scrolls when the window
/// is short, and keeps the content to a comfortable width.
class MuqamAuthBody extends StatelessWidget {
  final MuqamAuthCard card;

  const MuqamAuthBody({required this.card, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              const MuqamAuthHeader(),
              const SizedBox(height: 24),
              card,
            ],
          ),
        ),
      ),
    );
  }
}

/// MUQAM: swaps the current auth page (login or register) for the other one,
/// under the same parent page, keeping the login client.
void muqamSwitchAuthPage(BuildContext context, String page, Client client) {
  final segments = List.of(GoRouterState.of(context).uri.pathSegments);
  if (segments.isNotEmpty) segments.removeLast();
  segments.add(page);
  context.go('/${segments.join('/')}', extra: client);
}
