// SPDX-FileCopyrightText: 2026 Wider Community
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/muqam_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

/// MUQAM: create an account on the homeserver with a username, a password
/// and the invite code (a Matrix registration token) the server asks for.
class Register extends StatefulWidget {
  final Client client;
  const Register({required this.client, super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatController = TextEditingController();
  final inviteController = TextEditingController();
  String? usernameError, passwordError, repeatError, inviteError, error;
  bool loading = false;
  bool showPassword = false;

  static final _localpart = RegExp(r'^[a-z0-9._=\-/]+$');
  static const _registrationToken = 'm.login.registration_token';

  Future<void> register() async {
    final l10n = L10n.of(context);
    final username = usernameController.text.trim().toLowerCase();
    final password = passwordController.text;
    final invite = inviteController.text.trim();

    setState(() {
      error = null;
      usernameError = username.isEmpty
          ? l10n.pleaseEnterYourUsername
          : _localpart.hasMatch(username)
          ? null
          : l10n.muqamUsernameInvalid;
      passwordError = password.isEmpty ? l10n.pleaseEnterYourPassword : null;
      repeatError = repeatController.text != password
          ? l10n.passwordsDoNotMatch
          : null;
      inviteError = invite.isEmpty ? l10n.muqamPleaseEnterInviteCode : null;
    });
    if ([
      usernameError,
      passwordError,
      repeatError,
      inviteError,
    ].any((e) => e != null)) {
      return;
    }

    setState(() => loading = true);
    final client = await Matrix.of(context).getLoginClient();
    try {
      if (!await client.registrationTokenValidity(invite)) {
        setState(() => inviteError = l10n.muqamInviteCodeInvalid);
        return;
      }

      // The first request only asks the server which steps it wants.
      String? session;
      var stages = <String>[];
      try {
        await client.register(
          username: username,
          password: password,
          initialDeviceDisplayName: PlatformInfos.appDisplayName,
        );
      } on MatrixException catch (e) {
        if (e.session == null) rethrow;
        session = e.session;
        stages = e.authenticationFlows?.firstOrNull?.stages ?? [];
      }

      if (session != null) {
        final usesToken = stages.contains(_registrationToken);
        await client.register(
          username: username,
          password: password,
          initialDeviceDisplayName: PlatformInfos.appDisplayName,
          auth: AuthenticationData(
            type: usesToken ? _registrationToken : AuthenticationTypes.dummy,
            session: session,
            additionalFields: usesToken ? {'token': invite} : null,
          ),
        );
      }
      if (mounted) context.go('/backup');
    } on MatrixException catch (e) {
      setState(() {
        switch (e.errcode) {
          case 'M_USER_IN_USE':
            usernameError = l10n.muqamUsernameTaken;
          case 'M_INVALID_USERNAME' || 'M_EXCLUSIVE':
            usernameError = e.errorMessage;
          case 'M_WEAK_PASSWORD':
            passwordError = e.errorMessage;
          default:
            if (e.session != null) {
              inviteError = l10n.muqamInviteCodeInvalid;
            } else {
              error = e.errorMessage;
            }
        }
      });
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    repeatController.dispose();
    inviteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);
    final error = this.error;

    return LoginScaffold(
      appBar: AppBar(
        leading: loading ? null : const Center(child: BackButton()),
        automaticallyImplyLeading: !loading,
        backgroundColor: Colors.transparent,
      ),
      body: AutofillGroup(
        child: MuqamAuthBody(
          card: MuqamAuthCard(
            title: l10n.muqamCreateAccountTitle,
            subtitle: l10n.muqamSignUpSubtitle,
            footer: MuqamAuthSwitch(
              question: l10n.muqamHaveAccount,
              action: l10n.signIn,
              onPressed: loading
                  ? null
                  : () => muqamSwitchAuthPage(context, 'login', widget.client),
            ),
            children: [
              TextField(
                readOnly: loading,
                autocorrect: false,
                autofocus: true,
                controller: usernameController,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newUsername],
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  hintText: l10n.muqamUsername,
                  errorText: usernameError,
                  errorMaxLines: 3,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                readOnly: loading,
                autocorrect: false,
                controller: passwordController,
                obscureText: !showPassword,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outlined),
                  hintText: l10n.password,
                  errorText: passwordError,
                  errorMaxLines: 3,
                  suffixIcon: IconButton(
                    tooltip: l10n.password,
                    onPressed: () =>
                        setState(() => showPassword = !showPassword),
                    icon: Icon(
                      showPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                readOnly: loading,
                autocorrect: false,
                controller: repeatController,
                obscureText: !showPassword,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_reset_outlined),
                  hintText: l10n.repeatPassword,
                  errorText: repeatError,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                readOnly: loading,
                autocorrect: false,
                controller: inviteController,
                textInputAction: TextInputAction.go,
                onSubmitted: (_) => register(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.vpn_key_outlined),
                  hintText: l10n.muqamInviteCode,
                  helperText: l10n.muqamInviteCodeHelp,
                  helperMaxLines: 2,
                  errorText: inviteError,
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(error, style: TextStyle(color: theme.colorScheme.error)),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : register,
                child: loading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.muqamCreateAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
