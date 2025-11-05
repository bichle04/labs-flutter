import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';
import '../models/photo.dart';
import 'fullscreen_photo_screen.dart';

/// Home screen displaying the photo gallery in a grid layout
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSelectionMode = false;
  final Set<String> _selectedPhotoIds = {};

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isSelectionMode) {
          setState(() {
            _isSelectionMode = false;
            _selectedPhotoIds.clear();
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Stack(children: [_buildBody(), _buildFloatingActionButtons()]),
      ),
    );
  }

  /// Build the app bar with dynamic title based on selection mode
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: _isSelectionMode
          ? Text('${_selectedPhotoIds.length} selected')
          : const Text('Photo Gallery'),
      elevation: 4,
      actions: _isSelectionMode
          ? _buildSelectionActions()
          : _buildDefaultActions(),
    );
  }

  /// Build app bar actions in selection mode
  List<Widget> _buildSelectionActions() {
    return [
      if (_selectedPhotoIds.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Delete selected',
          onPressed: _deleteSelectedPhotos,
        ),
      IconButton(
        icon: const Icon(Icons.close),
        tooltip: 'Cancel selection',
        onPressed: () {
          setState(() {
            _isSelectionMode = false;
            _selectedPhotoIds.clear();
          });
        },
      ),
    ];
  }

  /// Build default app bar actions
  List<Widget> _buildDefaultActions() {
    return [
      Consumer<PhotoProvider>(
        builder: (context, photoProvider, _) {
          return IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More options',
            onPressed: () => _showOptionsMenu(context),
          );
        },
      ),
    ];
  }

  /// Build the main body with grid or empty state
  Widget _buildBody() {
    return Consumer<PhotoProvider>(
      builder: (context, photoProvider, _) {
        if (photoProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (photoProvider.photos.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.photo_library_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your Gallery Awaits',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Start capturing memories by taking photos or selecting from your gallery',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (photoProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
                const SizedBox(height: 16),
                Text('Error', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    photoProvider.errorMessage ?? 'Unknown error',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    photoProvider.clearError();
                    photoProvider.loadPhotos();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            16.0,
            8.0,
            16.0,
            100.0,
          ), // Bottom padding for buttons
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Changed from 3 to 2 for larger images
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0, // Square aspect ratio
            ),
            itemCount: photoProvider.photos.length,
            itemBuilder: (context, index) {
              return _buildPhotoGridItem(context, photoProvider.photos[index]);
            },
          ),
        );
      },
    );
  }

  /// Build individual photo grid item
  Widget _buildPhotoGridItem(BuildContext context, Photo photo) {
    final isSelected = _selectedPhotoIds.contains(photo.id);

    return GestureDetector(
      onLongPress: () {
        setState(() {
          _isSelectionMode = true;
          if (isSelected) {
            _selectedPhotoIds.remove(photo.id);
          } else {
            _selectedPhotoIds.add(photo.id);
          }
        });
      },
      onTap: () {
        if (_isSelectionMode) {
          setState(() {
            if (isSelected) {
              _selectedPhotoIds.remove(photo.id);
              if (_selectedPhotoIds.isEmpty) {
                _isSelectionMode = false;
              }
            } else {
              _selectedPhotoIds.add(photo.id);
            }
          });
        } else {
          _navigateToFullscreen(context, photo);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // More rounded corners
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 4,
                )
              : Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.1),
                  width: 1,
                ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Photo image with new styling
              Hero(
                tag: photo.id,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Theme.of(context).colorScheme.surface,
                  child: Image.file(
                    photo.getFile(),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.5),
                            size: 48,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Selection indicator overlay with new design
              if (isSelected)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              // Date overlay in bottom-right corner
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatDate(photo.capturedDate),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Navigate to fullscreen photo view with Hero animation
  void _navigateToFullscreen(BuildContext context, Photo photo) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FullscreenPhotoScreen(photo: photo);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final photoDate = DateTime(date.year, date.month, date.day);

    if (photoDate == today) {
      return 'Today';
    } else if (photoDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Build floating action buttons with new horizontal layout
  Widget _buildFloatingActionButtons() {
    if (_isSelectionMode) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 24,
      right: 16,
      left: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Gallery button with new design
          Container(
            height: 56,
            width: 140,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: () {
                  final photoProvider = context.read<PhotoProvider>();
                  photoProvider.pickMultipleFromGallery();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Gallery',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Camera button with new design
          Container(
            height: 56,
            width: 140,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: () {
                  final photoProvider = context.read<PhotoProvider>();
                  photoProvider.takePhoto();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Camera',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show options menu
  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final photoProvider = context.read<PhotoProvider>();
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Refresh'),
                  onTap: () {
                    Navigator.pop(context);
                    photoProvider.loadPhotos();
                  },
                ),
                if (photoProvider.photos.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.select_all),
                    title: const Text('Select all'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _isSelectionMode = true;
                        _selectedPhotoIds.clear();
                        _selectedPhotoIds.addAll(
                          photoProvider.photos.map((p) => p.id),
                        );
                      });
                    },
                  ),
                if (photoProvider.photos.isNotEmpty)
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Delete all',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteAllConfirmation(context);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Delete selected photos
  void _deleteSelectedPhotos() {
    if (_selectedPhotoIds.isEmpty) return;

    final count = _selectedPhotoIds.length;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete photos?'),
          content: Text(
            'Are you sure you want to delete $count photo${count > 1 ? 's' : ''}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                final photoProvider = context.read<PhotoProvider>();
                photoProvider.deleteMultiplePhotos(_selectedPhotoIds.toList());
                setState(() {
                  _isSelectionMode = false;
                  _selectedPhotoIds.clear();
                });
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// Show delete all confirmation
  void _showDeleteAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete all photos?'),
          content: const Text(
            'Are you sure you want to delete all photos? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                final photoProvider = context.read<PhotoProvider>();
                photoProvider.clearAllPhotos();
              },
              child: const Text(
                'Delete all',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
