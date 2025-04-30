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

    return Scaffold(
      appBar: DynamicAppBar(
        title: 'Settings',
        showHelpButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          const _SectionHeader(icon: Icons.color_lens, title: 'Theme Selection'),
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Choose a Theme',
              contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0), // Makes it taller
            ),
            isExpanded: true, // Ensures full-width usage
            value: themeProvider.currentSelectedValue,
            onChanged: (int? value) {
              if (value != null) {
                themeProvider.setTheme(
                  value == 1
                    ? defaultTheme
                    : value == 2
                      ? protaTheme
                      : value == 3
                        ? deuterTheme
                        : value == 4
                          ? tritaTheme
                          : achromaTheme,
                  value,
                );
              }
            },
            items: const [
              DropdownMenuItem(value: 1, child: Text('Default')),
              DropdownMenuItem(value: 2, child: Text('Protanopia (Red Weakness)')),
              DropdownMenuItem(value: 3, child: Text('Deuteranopia (Green Weakness)')),
              DropdownMenuItem(value: 4, child: Text('Tritanopia (Blue Weakness)')),
              DropdownMenuItem(value: 5, child: Text('Achromatic (Greyscale)')),
            ],
          ),


          const SizedBox(height: 32),
          const _SectionHeader(icon: Icons.text_fields, title: 'Font Size'),
          Slider(
            min: 16.0,
            max: 24.0,
            divisions: 4,
            value: themeProvider.fontSize,
            label: themeProvider.fontSize.toStringAsFixed(0),
            onChanged: (newSize) {
              themeProvider.setFontSize(newSize);
            },
          ),
          Center(
            child: Text(
              'Current font size: ${themeProvider.fontSize.toStringAsFixed(0)}',
              style: TextStyle(fontSize: themeProvider.fontSize),
            ),
          ),

          const SizedBox(height: 32),
          const _SectionHeader(icon: Icons.visibility, title: 'Meal Plan Display'),
          SwitchListTile(
            title: const Text('Show Calories'),
            subtitle: const Text('Turn off to reduce anxiety or stress around food.'),
            value: context.watch<SettingsProvider>().showCalories,
            onChanged: (bool value) {
              context.read<SettingsProvider>().toggleShowCalories(value);
            },
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
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
