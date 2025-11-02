import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../utils/responsive_helper.dart';
import 'responsive_wrapper.dart';

class SocialLinksCard extends StatelessWidget {
  final List<SocialLink> socialLinks;
  final Function(SocialLink)? onLinkTap;

  const SocialLinksCard({super.key, required this.socialLinks, this.onLinkTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        _buildSectionHeader(context),

        const SizedBox(height: 16),

        // Social Links Grid/List
        _buildSocialLinksContainer(context),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.link,
            color: Theme.of(context).colorScheme.tertiary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Connect With Me',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${socialLinks.length}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLinksContainer(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(
                context,
              ).colorScheme.tertiaryContainer.withValues(alpha: 0.3),
              Theme.of(
                context,
              ).colorScheme.surfaceContainer.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Column(
          children: [
            // Main social links (first 2 as featured)
            if (socialLinks.isNotEmpty) _buildFeaturedLinks(context),

            // Remaining links as compact list
            if (socialLinks.length > 2) _buildCompactLinks(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedLinks(BuildContext context) {
    final featuredLinks = socialLinks.take(2).toList();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Primary Contacts',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: 16),

          // Featured social link cards
          ResponsiveHelper.isMobile(context)
              ? Column(
                  children: featuredLinks
                      .map(
                        (link) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildFeaturedLinkCard(context, link),
                        ),
                      )
                      .toList(),
                )
              : ResponsiveGrid(
                  crossAxisCount: 2,
                  children: featuredLinks
                      .map((link) => _buildFeaturedLinkCard(context, link))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildFeaturedLinkCard(BuildContext context, SocialLink link) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _handleLinkTap(context, link),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon with background
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getLinkColor(link.icon).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconForSocialLink(link.icon),
                    color: _getLinkColor(link.icon),
                    size: 24,
                  ),
                ),

                const SizedBox(width: 16),

                // Link info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        link.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getDisplayUrl(link.url),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Action icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_outward,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactLinks(BuildContext context) {
    final compactLinks = socialLinks.skip(2).toList();

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'More Ways to Connect',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          // Compact list tiles
          ...compactLinks.map(
            (link) => ListTile(
              leading: CircleAvatar(
                backgroundColor: _getLinkColor(
                  link.icon,
                ).withValues(alpha: 0.1),
                radius: 20,
                child: Icon(
                  _getIconForSocialLink(link.icon),
                  color: _getLinkColor(link.icon),
                  size: 18,
                ),
              ),
              title: Text(
                link.name,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                _getDisplayUrl(link.url),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: Icon(
                Icons.open_in_new,
                color: Theme.of(context).colorScheme.outline,
                size: 18,
              ),
              onTap: () => _handleLinkTap(context, link),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 4,
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _handleLinkTap(BuildContext context, SocialLink link) {
    if (onLinkTap != null) {
      onLinkTap!(link);
    } else {
      // Default behavior
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                _getIconForSocialLink(link.icon),
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text('Opening ${link.name}...'),
            ],
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Color _getLinkColor(String iconName) {
    switch (iconName.toLowerCase()) {
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
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'youtube':
        return const Color(0xFFFF0000);
      default:
        return const Color(0xFF6750A4);
    }
  }

  IconData _getIconForSocialLink(String iconName) {
    switch (iconName.toLowerCase()) {
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
      case 'instagram':
        return Icons.camera_alt;
      case 'youtube':
        return Icons.play_circle_outline;
      case 'telegram':
        return Icons.send;
      case 'discord':
        return Icons.chat;
      default:
        return Icons.link;
    }
  }

  String _getDisplayUrl(String url) {
    if (url.startsWith('mailto:')) {
      return url.substring(7); // Remove "mailto:"
    } else if (url.startsWith('tel:')) {
      return url.substring(4); // Remove "tel:"
    } else if (url.startsWith('http')) {
      // Extract domain from URL
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
