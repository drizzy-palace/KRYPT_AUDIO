/*
 *     Copyright (C) 2026 Valeri Gokadze
 *
 *     KRYPT AUDIO is a visual reskin of the Musify upstream project,
 *     distributed under the GNU General Public License version 3.
 */

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:musify/constants/app_constants.dart';
import 'package:musify/constants/brand_links.dart';
import 'package:musify/utilities/url_launcher.dart';
import 'package:musify/widgets/mini_player_bottom_space.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  static const amounts = [5, 10, 20, 50];
  int selectedAmount = 10;

  void _openPayPal() {
    final base = Uri.parse(paypalDonationUrl);
    final uri = base.host.endsWith('paypal.me')
        ? base.replace(path: '${base.path}/$selectedAmount')
        : base;
    launchURL(uri);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Support KRYPT AUDIO')),
      body: SingleChildScrollView(
        padding: commonSingleChildScrollViewPadding,
        child: Column(
          children: [
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors.primaryContainer,
                    colors.secondaryContainer.withValues(alpha: 0.72),
                  ],
                ),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: colors.outlineVariant),
              ),
              child: Column(
                children: [
                  Icon(
                    FluentIcons.heart_pulse_24_filled,
                    size: 42,
                    color: colors.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Keep the signal alive.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.onPrimaryContainer,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your support helps Synapse Labs maintain KRYPT AUDIO and keep building independent music tools.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.onPrimaryContainer.withValues(alpha: 0.78),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose an amount',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: amounts.map((amount) {
                final selected = amount == selectedAmount;
                return ChoiceChip(
                  label: Text('£$amount'),
                  selected: selected,
                  onSelected: (_) => setState(() => selectedAmount = amount),
                  selectedColor: colors.primary,
                  labelStyle: TextStyle(
                    color: selected ? colors.onPrimary : colors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _openPayPal,
                icon: const Icon(FluentIcons.payment_24_filled),
                label: Text('Continue with PayPal · £$selectedAmount'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You will complete the donation securely on PayPal. KRYPT AUDIO never collects or stores card details.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
            ),
            const MiniPlayerBottomSpace(),
          ],
        ),
      ),
    );
  }
}
