/*
 *     Copyright (C) 2026 Valeri Gokadze
 *
 *     KRYPT AUDIO plugin guide for the Musify upstream project.
 *     Distributed under the GNU General Public License version 3.
 */

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:musify/widgets/mini_player_bottom_space.dart';

class PluginGuidePage extends StatelessWidget {
  const PluginGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin guide')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          _hero(context),
          _heading(text, '1. What is a .kryptplugin file?'),
          const Text(
            'A .kryptplugin is a ZIP package with a custom extension. It keeps the manifest, JavaScript hooks, CSS theme and optional assets together so KRYPT can validate and install it as one unit.',
          ),
          _heading(text, '2. Required package layout'),
          _code(
            'my-theme.kryptplugin\n├── manifest.json\n├── plugin.js\n├── theme.css\n└── assets/',
          ),
          _heading(text, '3. Write manifest.json'),
          _code('''{
  "id": "my-theme",
  "name": "My Theme",
  "version": "1.0.0",
  "description": "A violet glass theme",
  "author": "Your name",
  "minAppVersion": "1.0.1",
  "entryScript": "plugin.js",
  "stylesheet": "theme.css",
  "permissions": [],
  "downloadUrl": "https://.../my-theme.kryptplugin"
}'''),
          _heading(text, '4. Style the app with CSS'),
          const Text(
            'Use the supported KRYPT tokens below. CSS is intentionally limited to theme values in V1.0.1 so a downloaded theme cannot alter files or native playback.',
          ),
          _code(''':root {
  --krypt-primary: #9b7cff;
  --krypt-secondary: #36c8ff;
  --krypt-background: #080611;
  --krypt-surface: #17132a;
  --krypt-radius: 24px;
}'''),
          _heading(text, '5. Add JavaScript hooks'),
          const Text(
            'plugin.js is the JavaScript entry point for future KRYPT hooks. Keep it event-driven and request only the permissions you need. V1.0.1 stores and validates the script but does not grant unrestricted native access to downloaded code.',
          ),
          _code('''export function onActivate(krypt) {
  krypt.ui.toast("Theme active");
}

export function onSongChanged(song) {
  // React to a playback event when the hook is available.
}'''),
          _heading(text, '6. Publish to the marketplace'),
          const Text(
            'Publish the .kryptplugin file in a GitHub repository, add its manifest to the marketplace branch index.json, and use a HTTPS downloadUrl. Users can then refresh the marketplace in KRYPT AUDIO.',
          ),
          Card(
            child: const ListTile(
              leading: Icon(FluentIcons.shield_checkmark_24_filled),
              title: Text('Safety rule'),
              subtitle: Text(
                'Never request permissions you do not need. Only install packages from authors you trust.',
              ),
            ),
          ),
          const MiniPlayerBottomSpace(),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.secondaryContainer,
      child: const Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(FluentIcons.code_24_filled),
            SizedBox(height: 10),
            Text(
              'Build your own KRYPT layer',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'Themes are CSS-first. Plugins are packaged, reviewable and permission-aware.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _heading(TextTheme text, String value) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(value, style: text.titleMedium),
  );

  Widget _code(String value) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 4),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.22),
      borderRadius: BorderRadius.circular(14),
    ),
    child: SelectableText(
      value,
      style: const TextStyle(fontFamily: 'monospace', fontSize: 12.5),
    ),
  );
}
