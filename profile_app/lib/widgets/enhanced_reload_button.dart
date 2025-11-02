import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class EnhancedReloadButton extends StatefulWidget {
  final VoidCallback? onReload;
  final String? tooltip;

  const EnhancedReloadButton({
    super.key,
    this.onReload,
    this.tooltip = 'Reload Profile',
  });

  @override
  State<EnhancedReloadButton> createState() => _EnhancedReloadButtonState();
}

class _EnhancedReloadButtonState extends State<EnhancedReloadButton>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Rotation animation for loading state
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Scale animation for tap feedback
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handleReload(ProfileProvider profileProvider) async {
    // Scale down animation
    await _scaleController.forward();
    await _scaleController.reverse();

    // Start rotation for loading
    _rotationController.repeat();

    // Call reload
    if (widget.onReload != null) {
      widget.onReload!();
    } else {
      await profileProvider.reloadProfile();
    }

    // Stop rotation after reload
    _rotationController.stop();
    _rotationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final isLoading = profileProvider.isLoading;

        // Auto-start rotation if loading
        if (isLoading && !_rotationController.isAnimating) {
          _rotationController.repeat();
        } else if (!isLoading && _rotationController.isAnimating) {
          _rotationController.stop();
          _rotationController.reset();
        }

        return ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isLoading
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: IconButton(
              onPressed: isLoading
                  ? null
                  : () => _handleReload(profileProvider),
              icon: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: isLoading
                        ? _rotationAnimation.value * 2 * 3.14159
                        : 0,
                    child: Icon(
                      isLoading ? Icons.sync : Icons.refresh,
                      color: isLoading
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).iconTheme.color,
                    ),
                  );
                },
              ),
              tooltip: widget.tooltip,
              splashRadius: 20,
            ),
          ),
        );
      },
    );
  }
}
