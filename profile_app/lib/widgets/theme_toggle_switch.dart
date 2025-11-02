import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

class ThemeToggleSwitch extends StatelessWidget {
  final bool showLabels;
  final bool isCompact;

  const ThemeToggleSwitch({
    super.key,
    this.showLabels = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        if (isCompact) {
          return _buildCompactSwitch(context, themeProvider);
        } else {
          return _buildFullSwitch(context, themeProvider);
        }
      },
    );
  }

  Widget _buildCompactSwitch(
    BuildContext context,
    ThemeProvider themeProvider,
  ) {
    return Switch(
      value: themeProvider.isDarkMode,
      onChanged: (value) => themeProvider.setTheme(value),
      thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
        if (states.contains(WidgetState.selected)) {
          return const Icon(Icons.dark_mode, color: Colors.white);
        }
        return const Icon(Icons.light_mode, color: Colors.amber);
      }),
    );
  }

  Widget _buildFullSwitch(BuildContext context, ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Light mode icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: !themeProvider.isDarkMode
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.light_mode,
              color: !themeProvider.isDarkMode
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // Switch
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.setTheme(value),
            thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
              return null; // No icon on thumb for cleaner look
            }),
          ),

          const SizedBox(width: 12),

          // Dark mode icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.dark_mode,
              color: themeProvider.isDarkMode
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),

          if (showLabels) ...[
            const SizedBox(width: 8),
            Text(
              themeProvider.isDarkMode ? 'Dark' : 'Light',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
    );
  }
}
