// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/themes.dart';
import 'package:material_ui/material_ui.dart';

/// MUQAM: wide screens use the Wider shell. A soft lavender wash fills the
/// window and each column sits on it as a white rounded card.
class TwoColumnLayout extends StatelessWidget {
  final Widget mainView;
  final Widget sideView;
  final bool hasNavigationRail;

  const TwoColumnLayout({
    super.key,
    required this.mainView,
    required this.sideView,
    this.hasNavigationRail = true,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: theme.colorScheme.surfaceContainerLow,
        body: SafeArea(
          child: Row(
            children: [
              SizedBox(
                width:
                    FluffyThemes.columnWidth +
                    (hasNavigationRail ? FluffyThemes.navRailWidth : 0) +
                    MuqamShell.gutter,
                // The chat list draws its own card so that the MUQAM rail can
                // sit on the wash. Other main views get a card here.
                child: hasNavigationRail
                    ? mainView
                    : MuqamShell.card(context, mainView, end: false),
              ),
              Expanded(child: MuqamShell.card(context, sideView)),
            ],
          ),
        ),
      ),
    );
  }
}
