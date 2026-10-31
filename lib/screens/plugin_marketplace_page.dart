/*
 *     Copyright (C) 2026 Valeri Gokadze
 *
 *     KRYPT AUDIO plugin marketplace for the Musify upstream project.
 *     Distributed under the GNU General Public License version 3.
 */

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:musify/models/plugin_manifest.dart';
import 'package:musify/services/plugin_service.dart';
import 'package:musify/widgets/mini_player_bottom_space.dart';

class PluginMarketplacePage extends StatefulWidget {
  const PluginMarketplacePage({super.key});

  @override
  State<PluginMarketplacePage> createState() => _PluginMarketplacePageState();
}

class _PluginMarketplacePageState extends State<PluginMarketplacePage> {
  late Future<List<KryptPluginManifest>> _marketplace;

  @override
  void initState() {
    super.initState();
    _marketplace = KryptPluginService.instance.fetchMarketplace();
  }

  void _refresh() => setState(() {
    _marketplace = KryptPluginService.instance.fetchMarketplace();
  });

  Future<void> _install(KryptPluginManifest plugin) async {
    try {
      await KryptPluginService.instance.install(plugin);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${plugin.name} installed')));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Plugin install failed: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = KryptPluginService.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('KRYPT Plugins'),
        actions: [
          IconButton(
            tooltip: 'Plugin guide',
            onPressed: () => context.push('/settings/plugins/guide'),
            icon: const Icon(FluentIcons.book_information_24_regular),
          ),
          IconButton(
            tooltip: 'Refresh marketplace',
            onPressed: _refresh,
            icon: const Icon(FluentIcons.arrow_sync_24_regular),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: service,
        builder: (context, _) => FutureBuilder<List<KryptPluginManifest>>(
          future: _marketplace,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final marketplace = snapshot.data ?? const <KryptPluginManifest>[];
            return RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 24),
                children: [
                  _introCard(context),
                  if (snapshot.hasError)
                    _errorCard(context, snapshot.error.toString()),
                  if (service.installed.isNotEmpty) ...[
                    _sectionTitle(context, 'Installed'),
                    ...service.installed.map(
                      (plugin) => _installedTile(plugin),
                    ),
                  ],
                  _sectionTitle(context, 'Marketplace'),
                  if (marketplace.isEmpty && !snapshot.hasError)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text('No compatible plugins published yet.'),
                      ),
                    ),
                  ...marketplace.map((plugin) => _marketplaceTile(plugin)),
                  const MiniPlayerBottomSpace(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _introCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.primaryContainer,
      child: ListTile(
        leading: Icon(FluentIcons.puzzle_cube_24_filled, color: colors.primary),
        title: const Text('Make KRYPT yours'),
        subtitle: const Text(
          'Install community-made themes and plugins. Review permissions before enabling anything.',
        ),
        trailing: IconButton(
          tooltip: 'Read the guide',
          onPressed: () => context.push('/settings/plugins/guide'),
          icon: const Icon(FluentIcons.chevron_right_24_regular),
        ),
      ),
    );
  }

  Widget _errorCard(BuildContext context, String message) => Card(
    child: ListTile(
      leading: const Icon(FluentIcons.warning_24_regular),
      title: const Text('Marketplace unavailable'),
      subtitle: Text(message),
    ),
  );

  Widget _sectionTitle(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );

  Widget _marketplaceTile(KryptPluginManifest plugin) {
    final installed = KryptPluginService.instance.installed.where(
      (item) => item.manifest.id == plugin.id,
    );
    return Card(
      child: ListTile(
        leading: const Icon(FluentIcons.puzzle_cube_24_regular),
        title: Text('${plugin.name} · ${plugin.version}'),
        subtitle: Text('${plugin.description}\nBy ${plugin.author}'),
        isThreeLine: true,
        trailing: installed.isEmpty
            ? FilledButton(
                onPressed: () => _install(plugin),
                child: const Text('Install'),
              )
            : const Icon(FluentIcons.checkmark_circle_24_filled),
      ),
    );
  }

  Widget _installedTile(InstalledKryptPlugin plugin) {
    final service = KryptPluginService.instance;
    return Card(
      child: ListTile(
        leading: const Icon(FluentIcons.puzzle_cube_24_filled),
        title: Text(plugin.manifest.name),
        subtitle: Text(
          'v${plugin.manifest.version} · ${plugin.manifest.author}',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) async {
            if (action == 'toggle') {
              await service.setEnabled(plugin.manifest.id, !plugin.enabled);
            } else if (action == 'remove') {
              await service.uninstall(plugin.manifest.id);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'toggle',
              child: Text(plugin.enabled ? 'Disable' : 'Enable'),
            ),
            const PopupMenuItem(value: 'remove', child: Text('Uninstall')),
          ],
        ),
      ),
    );
  }
}
