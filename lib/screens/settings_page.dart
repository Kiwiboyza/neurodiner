import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/themes.dart';
import '../widgets/dynamic_app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontSize = themeProvider.fontSize;

    return Scaffold(
      appBar: const DynamicAppBar(
        title: 'Settings',
        showHelpButton: true,
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          const _SectionHeader(
            icon: Icons.color_lens,
            title: 'Theme Selection',
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: fontSize * 2.5,
              maxHeight: fontSize * 3.5,
            ),
            child: Tooltip(
              message: 'Change the app theme for colour accessibility.',
              child: DropdownButtonFormField<int>(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Choose a Theme',
                  labelStyle: const TextStyle(color: Colors.black),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: fontSize * 0.75,
                    horizontal: 12.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
                isExpanded: true,
                style: TextStyle(fontSize: fontSize, color: Colors.black),
                value: themeProvider.currentSelectedValue,
                onChanged: (int? value) {
                  if (value != null) {
                    final theme = switch (value) {
                      1 => defaultTheme,
                      2 => protaTheme,
                      3 => deuterTheme,
                      4 => tritaTheme,
                      _ => achromaTheme,
                    };
                    themeProvider.setTheme(theme, value);
                  }
                },
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Default')),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('Protanopia (Red Weakness)'),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('Deuteranopia (Green Weakness)'),
                  ),
                  DropdownMenuItem(
                    value: 4,
                    child: Text('Tritanopia (Blue Weakness)'),
                  ),
                  DropdownMenuItem(
                    value: 5,
                    child: Text('Achromatic (Greyscale)'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          const _SectionHeader(icon: Icons.text_fields, title: 'Font Size'),
          Tooltip(
            message: 'Adjust text size for readability.',
            child: Slider(
              min: 16.0,
              max: 24.0,
              divisions: 4,
              value: fontSize,
              label: fontSize.toStringAsFixed(0),
              onChanged: themeProvider.setFontSize,
            ),
          ),
          Center(
            child: Text(
              'Current font size: ${fontSize.toStringAsFixed(0)}',
              style: TextStyle(fontSize: fontSize),
            ),
          ),
          const SizedBox(height: 32),
          const _SectionHeader(
            icon: Icons.visibility,
            title: 'Meal Plan Display',
          ),
          Tooltip(
            message: 'Toggles visibility of calorie info in the meal plan.',
            child: SwitchListTile(
              title: const Text('Show Calories'),
              subtitle: const Text(
                'Turn off to reduce anxiety or stress around food. (Default: On)',
              ),
              value: context.watch<SettingsProvider>().showCalories,
              onChanged: context.read<SettingsProvider>().toggleShowCalories,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
