/*
 *     Copyright (C) 2026 Valeri Gokadze
 *
 *     KRYPT AUDIO is a visual reskin of Musify, distributed under the
 *     GNU General Public License version 3. See the repository LICENSE.
 *     Upstream attribution: https://github.com/gokadzev/Musify
 */

import 'dart:ui';

import 'package:material_ui/material_ui.dart';

/// A lightweight Liquid Glass surface used throughout KRYPT AUDIO.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    required this.child,
    super.key,
    this.padding,
    this.margin,
    this.borderRadius = const BorderRadius.all(Radius.circular(22)),
    this.blur = 18,
    this.opacity = 0.72,
    this.borderColor,
    this.shadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius borderRadius;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final surface = scheme.surfaceContainerHigh;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.10),
                  blurRadius: 28,
                  spreadRadius: -10,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: surface.withValues(alpha: opacity),
              borderRadius: borderRadius,
              border: Border.all(
                color: borderColor ?? scheme.onSurface.withValues(alpha: 0.10),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
