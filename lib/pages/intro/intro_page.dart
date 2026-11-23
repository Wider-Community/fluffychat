// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/intro/flows/restore_backup_flow.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/muqam_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class IntroPage extends StatelessWidget {
  final bool isLoading, hasPresetHomeserver;
  final String? loggingInToHomeserver, welcomeText;
  final VoidCallback login, signUp;

  const IntroPage({
    required this.isLoading,
    required this.loggingInToHomeserver,
    super.key,
    required this.hasPresetHomeserver,
    required this.welcomeText,
    required this.login,
    required this.signUp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addMultiAccount = Matrix.of(
      context,
    ).widget.clients.any((client) => client.isLogged());
    final loggingInToHomeserver = this.loggingInToHomeserver;

    return LoginScaffold(
      appBar: AppBar(
        centerTitle: true,
        // MUQAM: the lockup below names the app, so the bar stays empty.
        title: addMultiAccount ? Text(L10n.of(context).addAccount) : null,
        actions: [
          PopupMenuButton(
            useRootNavigator: true,
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: isLoading ? null : () => restoreBackupFlow(context),
                child: Row(
                  mainAxisSize: .min,
                  spacing: 12,
                  children: [
                    const Icon(Icons.import_export_outlined),
                    Expanded(
                      child: Text(
                        L10n.of(context).hydrate,
                        maxLines: 1,
                        overflow: .ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => launchUrlString(AppSettings.privacyPolicy.value),
                child: Row(
                  mainAxisSize: .min,
                  spacing: 12,
                  children: [
                    const Icon(Icons.privacy_tip_outlined),
                    Text(L10n.of(context).privacy),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => PlatformInfos.showDialog(context),
                child: Row(
                  mainAxisSize: .min,
                  spacing: 12,
                  children: [
                    const Icon(Icons.info_outlined),
                    Text(L10n.of(context).about),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  CircularProgressIndicator.adaptive(),
                  if (loggingInToHomeserver != null)
                    Text(L10n.of(context).logInTo(loggingInToHomeserver)),
                ],
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // MUQAM: the Within mark and wordmark, no circle,
                          // then the promise in two beats (brand voice).
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 56, 32, 40),
                            child: Hero(tag: 'info-logo', child: MuqamLockup()),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              children: [
                                Text(
                                  L10n.of(context).appSubtitle,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 40,
                                    height: 1.1,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  L10n.of(context).muqamPromiseSecond,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    height: 1.2,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 420,
                                  ),
                                  child: Text(
                                    welcomeText ??
                                        L10n.of(context).appDescription,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1.5,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisSize: .min,
                              crossAxisAlignment: .stretch,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        theme.colorScheme.secondary,
                                    foregroundColor:
                                        theme.colorScheme.onSecondary,
                                  ),
                                  onPressed: signUp,
                                  child: Text(
                                    L10n.of(context).createNewAccount,
                                  ),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: login,
                                  child: Text(L10n.of(context).signIn),
                                ),

                                if (!hasPresetHomeserver)
                                  TextButton(
                                    onPressed: () async {
                                      final client = await Matrix.of(
                                        context,
                                      ).getLoginClient();
                                      if (!context.mounted) return;
                                      context.go(
                                        '${GoRouterState.of(context).uri.path}/login',
                                        extra: client,
                                      );
                                    },
                                    child: Text(
                                      L10n.of(context).loginWithMatrixId,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 36),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
