import 'package:flutter/material.dart';
import '../models/profile.dart';

class AnimatedSocialLink extends StatefulWidget {
  final SocialLink socialLink;
  final VoidCallback? onTap;
  final bool isCompact;

  const AnimatedSocialLink({
    super.key,
    required this.socialLink,
    this.onTap,
    this.isCompact = false,
  });

  @override
  State<AnimatedSocialLink> createState() => _AnimatedSocialLinkState();
}

class _AnimatedSocialLinkState extends State<AnimatedSocialLink>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: widget.isCompact ? _buildCompactLink() : _buildFullLink(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompactLink() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getLinkColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getLinkColor().withValues(alpha: 0.2)),
      ),
      child: Icon(_getIcon(), color: _getLinkColor(), size: 24),
    );
  }

  Widget _buildFullLink() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: _getLinkColor().withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getLinkColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_getIcon(), color: _getLinkColor(), size: 24),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.socialLink.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getDisplayText(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          Icon(
            Icons.arrow_outward,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ],
      ),
    );
  }

  Color _getLinkColor() {
    switch (widget.socialLink.icon.toLowerCase()) {
      case 'github':
        return const Color(0xFF333333);
      case 'linkedin':
        return const Color(0xFF0077B5);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'email':
        return const Color(0xFFEA4335);
      case 'phone':
        return const Color(0xFF34A853);
      case 'website':
        return const Color(0xFF4285F4);
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData _getIcon() {
    switch (widget.socialLink.icon.toLowerCase()) {
      case 'github':
        return Icons.code;
      case 'linkedin':
        return Icons.work;
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'twitter':
        return Icons.alternate_email;
      case 'website':
        return Icons.language;
      default:
        return Icons.link;
    }
  }

  String _getDisplayText() {
    final url = widget.socialLink.url;
    if (url.startsWith('mailto:')) {
      return url.substring(7);
    } else if (url.startsWith('tel:')) {
      return url.substring(4);
    } else if (url.startsWith('http')) {
      try {
        final uri = Uri.parse(url);
        return uri.host.replaceFirst('www.', '');
      } catch (e) {
        return url;
      }
    }
    return url;
  }
}
