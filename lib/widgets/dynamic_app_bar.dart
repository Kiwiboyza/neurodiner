import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../functions/functions.dart';

class DynamicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showHomeButton;
  final bool showHelpButton;
  final bool showSettingsButton;
  final bool automaticallyImplyLeading;

  const DynamicAppBar({
    required this.title,
    this.showHomeButton = false,
    this.showSettingsButton = false,
    this.showHelpButton = false,
    this.automaticallyImplyLeading = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final scaffoldColor = themeProvider.themeData.scaffoldBackgroundColor;
    final appBarColor = darkenColor(scaffoldColor);

    return AppBar(
      centerTitle: true,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: appBarColor,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading:
          showHomeButton
              ? Tooltip(
                message: 'Go to Home', // Tooltip message
                child: IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
              )
              : null,
      actions: [
        // Show Help Button if needed
        if (showHelpButton)
          Tooltip(
            message: 'How to Use NeuroDiner',
            child: IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                Navigator.pushNamed(context, '/help');
              },
            ),
          ),
        // Show Settings Button if needed
        if (showSettingsButton)
          Tooltip(
            message: 'Settings',
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
