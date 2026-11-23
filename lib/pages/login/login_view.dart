// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/muqam_auth.dart';
import 'package:material_ui/material_ui.dart';

import 'login.dart';

class LoginView extends StatelessWidget {
  final LoginController controller;

  const LoginView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final homeserver = controller.widget.client.homeserver;

    // MUQAM: the lockup and slogan on top, a line, then the form in a card.
    return LoginScaffold(
      appBar: AppBar(
        leading: controller.loading ? null : const Center(child: BackButton()),
        automaticallyImplyLeading: !controller.loading,
        backgroundColor: Colors.transparent,
      ),
      body: AutofillGroup(
        child: MuqamAuthBody(
          card: MuqamAuthCard(
            title: l10n.muqamWelcomeBack,
            subtitle: l10n.muqamSignInSubtitle,
            footer: MuqamAuthSwitch(
              question: l10n.muqamNoAccount,
              action: l10n.createNewAccount,
              onPressed: controller.loading
                  ? null
                  : () => muqamSwitchAuthPage(
                      context,
                      'register',
                      controller.widget.client,
                    ),
            ),
            children: [
              TextField(
                readOnly: controller.loading,
                autocorrect: false,
                autofocus: true,
                onChanged: controller.checkWellKnownWithCoolDown,
                controller: controller.usernameController,
                textInputAction: TextInputAction.next,
                autofillHints: controller.loading
                    ? null
                    : [AutofillHints.username],
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  errorText: controller.usernameError,
                  hintText: l10n.muqamUsername,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                readOnly: controller.loading,
                autocorrect: false,
                autofillHints: controller.loading
                    ? null
                    : [AutofillHints.password],
                controller: controller.passwordController,
                textInputAction: TextInputAction.go,
                obscureText: !controller.showPassword,
                onSubmitted: (_) => controller.login(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outlined),
                  errorText: controller.passwordError,
                  errorMaxLines: 3,
                  suffixIcon: IconButton(
                    tooltip: l10n.password,
                    onPressed: controller.toggleShowPassword,
                    icon: Icon(
                      controller.showPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                  hintText: l10n.password,
                ),
              ),
              if (homeserver != null)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: controller.loading
                        ? null
                        : controller.passwordForgotten,
                    child: Text(l10n.passwordForgotten),
                  ),
                )
              else
                const SizedBox(height: 14),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: controller.loading ? null : controller.login,
                child: controller.loading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.signIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
