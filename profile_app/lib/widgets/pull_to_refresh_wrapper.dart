import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class PullToRefreshWrapper extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;
  final String refreshMessage;

  const PullToRefreshWrapper({
    super.key,
    required this.child,
    this.onRefresh,
    this.refreshMessage = 'Refreshing profile...',
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        return RefreshIndicator(
          onRefresh:
              onRefresh ??
              () async {
                await profileProvider.reloadProfile();
              },
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.surface,
          strokeWidth: 3.0,
          displacement: 80.0,
          child: child,
        );
      },
    );
  }
}

class RefreshableProfileScreen extends StatelessWidget {
  final Widget child;
  final bool showRefreshIndicator;

  const RefreshableProfileScreen({
    super.key,
    required this.child,
    this.showRefreshIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showRefreshIndicator) {
      return child;
    }

    return PullToRefreshWrapper(child: child);
  }
}
