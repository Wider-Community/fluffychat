// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/client_chooser_button.dart';
import 'package:fluffychat/utils/sync_status_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

import '../../widgets/matrix.dart';

/// MUQAM: the "Chat" title row of the Wider chat. A bold title, a violet
/// round button that starts a new chat, and a menu for groups and settings.
class ChatListTitleBar extends StatelessWidget {
  final ChatListController controller;

  const ChatListTitleBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
      child: Container(
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                L10n.of(context).muqamChatTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton.filled(
              key: const Key('muqam_new_chat_button'),
              tooltip: L10n.of(context).newChat,
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                minimumSize: const Size.square(36),
                fixedSize: const Size.square(36),
                padding: EdgeInsets.zero,
              ),
              onPressed: () => context.go('/rooms/newprivatechat'),
              icon: const Icon(Icons.add, size: 22),
            ),
            const SizedBox(width: 4),
            ClientChooserButton(controller, icon: const Icon(Icons.more_horiz)),
          ],
        ),
      ),
    );
  }
}

class ChatListHeader extends StatelessWidget implements PreferredSizeWidget {
  final ChatListController controller;
  final bool globalSearch;

  const ChatListHeader({
    super.key,
    required this.controller,
    this.globalSearch = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final client = Matrix.of(context).client;
    final isColumnMode = FluffyThemes.isColumnMode(context);

    return SliverAppBar(
      floating: true,
      toolbarHeight: 72,
      pinned: isColumnMode,
      scrolledUnderElevation: 0,
      backgroundColor: theme.colorScheme.surface,
      automaticallyImplyLeading: false,
      title: StreamBuilder(
        stream: client.onSyncStatus.stream,
        builder: (context, snapshot) {
          final status =
              client.onSyncStatus.value ??
              const SyncStatusUpdate(SyncStatus.waitingForResponse);
          final hide =
              client.onSync.value != null &&
              status.status != SyncStatus.error &&
              client.prevBatch != null;
          return TextField(
            controller: controller.searchController,
            focusNode: controller.searchFocusNode,
            textInputAction: TextInputAction.search,
            onChanged: (text) =>
                controller.onSearchEnter(text, globalSearch: globalSearch),
            // MUQAM: an outlined pill search field, as in the Wider chat.
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.colorScheme.surface,
              hintText: hide
                  ? L10n.of(context).search
                  : status.calcLocalizedString(context),
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.normal,
              ),

              prefixIcon: hide
                  ? controller.isSearchMode
                        ? IconButton(
                            tooltip: L10n.of(context).cancel,
                            icon: const Icon(Icons.close_outlined),
                            onPressed: controller.cancelSearch,
                            color: theme.colorScheme.onSurfaceVariant,
                          )
                        : isColumnMode ||
                              (controller.spaces.isEmpty &&
                                  !AppSettings.displayNavigationRail.value)
                        ? IconButton(
                            tooltip: L10n.of(context).search,
                            onPressed: controller.startSearch,
                            icon: Icon(
                              Icons.search_outlined,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          )
                        : IconButton(
                            tooltip: L10n.of(context).displayNavigationRail,
                            onPressed: controller.openNavrail,
                            icon: Icon(
                              Icons.menu,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          )
                  : SizedBox(
                      width: 8,
                      height: 8,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                          value: status.progress,
                        ),
                      ),
                    ),
              suffixIcon: controller.isSearchMode && globalSearch
                  ? controller.isSearching
                        ? const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 12,
                            ),
                            child: SizedBox.square(
                              dimension: 24,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : TextButton.icon(
                            onPressed: controller.setServer,
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(99),
                              ),
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                            icon: const Icon(Icons.edit_outlined, size: 16),
                            label: Text(
                              controller.searchServer ??
                                  Matrix.of(context).client.homeserver!.host,
                              maxLines: 2,
                            ),
                          )
                  : null,
            ),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
