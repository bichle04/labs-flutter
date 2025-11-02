import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../utils/responsive_helper.dart';
import '../utils/avatar_helper.dart';
import 'responsive_wrapper.dart';

class ProfileHeaderCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onAvatarTap;

  const ProfileHeaderCard({super.key, required this.profile, this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.3),
              Theme.of(
                context,
              ).colorScheme.secondaryContainer.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Avatar với animation
              _buildAvatar(context),

              const SizedBox(height: 20),

              // Name
              _buildName(context),

              const SizedBox(height: 8),

              // Title badge
              _buildTitle(context),

              const SizedBox(height: 16),

              // Bio
              _buildBio(context),

              const SizedBox(height: 16),

              // Stats
              _buildStats(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return GestureDetector(
      onTap: onAvatarTap,
      child: Hero(
        tag: 'profile_avatar',
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: ResponsiveHelper.getAvatarSize(context) / 2,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: profile.avatarPath.isEmpty
                ? AvatarHelper.generateAvatar(
                    name: profile.name,
                    size: ResponsiveHelper.getAvatarSize(context),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getAvatarSize(context) / 2,
                    ),
                    child: Image.asset(
                      profile.avatarPath,
                      width: ResponsiveHelper.getAvatarSize(context),
                      height: ResponsiveHelper.getAvatarSize(context),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return AvatarHelper.generateAvatar(
                          name: profile.name,
                          size: ResponsiveHelper.getAvatarSize(context),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildName(BuildContext context) {
    return Text(
      profile.name,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        profile.title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        profile.bio,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(height: 1.4, letterSpacing: 0.2),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return ResponsiveRow(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          context,
          'Skills',
          '${profile.skills.length}',
          Icons.code,
        ),
        _buildStatItem(
          context,
          'Links',
          '${profile.socialLinks.length}',
          Icons.link,
        ),
        _buildStatItem(context, 'Years', '2+', Icons.work_history),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
