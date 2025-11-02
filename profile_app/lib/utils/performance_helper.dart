import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PerformanceHelper {
  // Optimize app launch
  static Future<void> optimizeAppLaunch() async {
    // Pre-cache commonly used images
    await _precacheImages();

    // Optimize system UI
    _optimizeSystemUI();

    // Warm up animations
    _warmupAnimations();
  }

  // Pre-cache images to avoid loading delays
  static Future<void> _precacheImages() async {
    // In a real app, you would precache actual image assets here
    // For now, we'll just simulate the process
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // Optimize system UI settings
  static void _optimizeSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }

  // Warm up common animations
  static void _warmupAnimations() {
    // This helps with first-time animation performance
    // In practice, you might warm up specific animation controllers
  }

  // Memory optimization utilities
  static void optimizeMemory() {
    // Force garbage collection (use sparingly)
    // In production, let Dart handle GC automatically
  }

  // Widget optimization helpers
  static Widget optimizedBuilder({
    required Widget Function(BuildContext) builder,
    bool addRepaintBoundary = true,
  }) {
    return Builder(
      builder: (context) {
        final widget = builder(context);

        if (addRepaintBoundary) {
          return RepaintBoundary(child: widget);
        }

        return widget;
      },
    );
  }

  // Optimize list performance
  static Widget optimizedListView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return RepaintBoundary(child: itemBuilder(context, index));
      },
      shrinkWrap: shrinkWrap,
      physics: physics,
      // Add cacheExtent for better scrolling performance
      cacheExtent: 250.0,
    );
  }
}

class OptimizedImage extends StatelessWidget {
  final String? assetPath;
  final String? placeholder;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;

  const OptimizedImage({
    super.key,
    this.assetPath,
    this.placeholder,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (assetPath == null || assetPath!.isEmpty) {
      return errorWidget ??
          Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported),
          );
    }

    return Image.asset(
      assetPath!,
      width: width,
      height: height,
      fit: fit,
      // Enable caching
      cacheWidth: width?.round(),
      cacheHeight: height?.round(),
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image),
            );
      },
    );
  }
}

// Performance monitoring widget
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool showOverlay;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.showOverlay = false,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  int _frameCount = 0;
  DateTime _lastFrameTime = DateTime.now();
  double _fps = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.showOverlay) {
      _startMonitoring();
    }
  }

  void _startMonitoring() {
    WidgetsBinding.instance.addPostFrameCallback(_onFrame);
  }

  void _onFrame(Duration timestamp) {
    final now = DateTime.now();
    final elapsed = now.difference(_lastFrameTime).inMilliseconds;

    if (elapsed > 0) {
      _fps = 1000 / elapsed;
      _frameCount++;
    }

    _lastFrameTime = now;

    if (mounted) {
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback(_onFrame);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showOverlay)
          Positioned(
            top: 50,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'FPS: ${_fps.toStringAsFixed(1)}\nFrames: $_frameCount',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
