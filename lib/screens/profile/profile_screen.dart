import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The Scaffold is in main.dart, this widget only returns its content.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.person_rounded, size: 100, color: theme.dividerColor),
            const SizedBox(height: 20),
            Text('Раздел в разработке', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Здесь будут находиться настройки\nвашего профиля.',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
