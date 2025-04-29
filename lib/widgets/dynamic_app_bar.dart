import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class DynamicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showHomeButton;
  final bool showHelpButton;
  final bool showSettingsButton;

  const DynamicAppBar({
    required this.title,
    this.showHomeButton = false,
    this.showSettingsButton = false,
    this.showHelpButton = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final scaffoldColor = themeProvider.themeData.scaffoldBackgroundColor;
    final appBarColor = darken(scaffoldColor, 0.1);


    return AppBar(
      centerTitle: true,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: appBarColor,
       leading: showHomeButton
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

  Color darken(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
