import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          const Flexible(child: ThemeToggleButton()),
          const EnhancedReloadButton(),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final profile = profileProvider.profile;

          // Show error message if any
          if (profileProvider.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showErrorSnackBar(context, profileProvider);
            });
          }

          return PullToRefreshWrapper(
            child: SingleChildScrollView(
              child: ResponsiveWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Header Section
                    ProfileHeaderCard(
                      profile: profile,
                      onAvatarTap: () {
                        // TODO: Implement avatar photo picker
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Avatar tap - coming soon!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Skills Section
                    SkillsCard(
                      skills: profile.skills,
                      onSkillTap: () {
                        // TODO: Implement skill detail view
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Skill details - coming soon!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Social Links Section
                    SocialLinksCard(
                      socialLinks: profile.socialLinks,
                      onLinkTap: (link) {
                        // TODO: Implement URL launcher
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
                                Text('Opening ${link.name}: ${link.url}'),
                              ],
                            ),
                            duration: const Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'Copy',
                              onPressed: () {
                                // TODO: Copy to clipboard
                              },
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Theme Settings Section
                    const ThemeSettingsCard(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showErrorSnackBar(
    BuildContext context,
    ProfileProvider profileProvider,
  ) {
    if (profileProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(profileProvider.errorMessage!)),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () {
              profileProvider.clearError();
              profileProvider.retryReload();
            },
          ),
        ),
      );
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
      default:
        return Icons.link;
    }
  }
}
