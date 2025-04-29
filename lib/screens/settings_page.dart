import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: DropdownButton<int>(
              hint: const Text('Select a Theme'),
              value: themeProvider.currentSelectedValue,
              onChanged: (int? value) {
                if (value != null) {
                  themeProvider.setTheme(
                    value == 1 ? defaultTheme :
                    value == 2 ? protaTheme :
                    value == 3 ? deuterTheme :
                    value == 4 ? tritaTheme : 
                    achromaTheme,
                    value,
                  );
                }
              },
              items: const [
                DropdownMenuItem(value: 1, child: Text('Default Theme')),
                DropdownMenuItem(value: 2, child: Text('Protanopia (Red Weakness)')),
                DropdownMenuItem(value: 3, child: Text('Deuteranopia (Green Weakness)')),
                DropdownMenuItem(value: 4, child: Text('Tritonopia (Blue Weakness)')),
                DropdownMenuItem(value: 5, child: Text('Achromatic (Greyscale Black and White)')),
              ],
              underline: SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Font Size: ${themeProvider.fontSize.toStringAsFixed(0)}',
            style: TextStyle(fontSize: themeProvider.fontSize),
          ),
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
        ],
      ),
    );
  }
}
