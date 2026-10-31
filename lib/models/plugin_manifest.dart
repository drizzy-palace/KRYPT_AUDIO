/*
 *     Copyright (C) 2026 Valeri Gokadze
 *
 *     KRYPT AUDIO plugin support for the Musify upstream project.
 *     Distributed under the GNU General Public License version 3.
 */

class KryptPluginManifest {
  const KryptPluginManifest({
    required this.id,
    required this.name,
    required this.version,
    required this.description,
    required this.author,
    required this.minAppVersion,
    required this.entryScript,
    required this.stylesheet,
    required this.permissions,
    required this.downloadUrl,
    this.iconUrl,
    this.repositoryUrl,
  });

  factory KryptPluginManifest.fromJson(Map<String, dynamic> json) {
    String requiredString(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('Plugin manifest requires a non-empty $key');
      }
      return value.trim();
    }

    final id = requiredString('id');
    final idPattern = RegExp(r'^[a-z0-9][a-z0-9._-]{1,63}$');
    if (!idPattern.hasMatch(id)) {
      throw FormatException('Invalid plugin id: $id');
    }

    final permissions = (json['permissions'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .map((permission) => permission.trim())
        .where((permission) => permission.isNotEmpty)
        .toSet()
        .toList(growable: false);

    return KryptPluginManifest(
      id: id,
      name: requiredString('name'),
      version: requiredString('version'),
      description: requiredString('description'),
      author: requiredString('author'),
      minAppVersion: requiredString('minAppVersion'),
      entryScript: (json['entryScript'] as String? ?? 'plugin.js').trim(),
      stylesheet: (json['stylesheet'] as String? ?? 'theme.css').trim(),
      permissions: permissions,
      downloadUrl: requiredString('downloadUrl'),
      iconUrl: (json['iconUrl'] as String?)?.trim(),
      repositoryUrl: (json['repositoryUrl'] as String?)?.trim(),
    );
  }

  final String id;
  final String name;
  final String version;
  final String description;
  final String author;
  final String minAppVersion;
  final String entryScript;
  final String stylesheet;
  final List<String> permissions;
  final String downloadUrl;
  final String? iconUrl;
  final String? repositoryUrl;

  bool get requestsNetwork => permissions.contains('network');
  bool get requestsPlayer => permissions.contains('player');
  bool get requestsNavigation => permissions.contains('navigation');
}

class InstalledKryptPlugin {
  const InstalledKryptPlugin({
    required this.manifest,
    required this.directoryPath,
    required this.enabled,
  });

  final KryptPluginManifest manifest;
  final String directoryPath;
  final bool enabled;
}
