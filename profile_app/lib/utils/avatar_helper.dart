import 'package:flutter/material.dart';

class AvatarHelper {
  // Generate avatar based on name initials
  static Widget generateAvatar({
    required String name,
    required double size,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final initials = _getInitials(name);
    final bgColor = backgroundColor ?? _generateColorFromName(name);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bgColor, bgColor.withValues(alpha: 0.8)],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: textColor ?? _getContrastColor(bgColor),
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Get initials from name
  static String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return '${parts[0].substring(0, 1)}${parts[parts.length - 1].substring(0, 1)}'
        .toUpperCase();
  }

  // Generate color from name
  static Color _generateColorFromName(String name) {
    final colors = [
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF10B981), // Emerald
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEF4444), // Red
      const Color(0xFF3B82F6), // Blue
      const Color(0xFFEC4899), // Pink
    ];

    final hash = name.hashCode;
    return colors[hash.abs() % colors.length];
  }

  // Get contrast color for text
  static Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  // Create profile placeholder with icon fallback
  static Widget profilePlaceholder({
    required double size,
    IconData icon = Icons.person,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[300],
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor ?? Colors.grey[300]!,
            (backgroundColor ?? Colors.grey[300]!).withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Icon(icon, size: size * 0.5, color: iconColor ?? Colors.grey[600]),
    );
  }
}
