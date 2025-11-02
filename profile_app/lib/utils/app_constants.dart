class AppConstants {
  // App Information
  static const String appName = 'Profile App';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A Flutter Personal Profile Application';

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration loadingAnimation = Duration(milliseconds: 800);

  // Spacing Constants
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Radius Constants
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusRound = 50.0;

  // Elevation Constants
  static const double elevationS = 1.0;
  static const double elevationM = 2.0;
  static const double elevationL = 4.0;
  static const double elevationXL = 8.0;

  // Icon Sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  // Avatar Sizes
  static const double avatarS = 32.0;
  static const double avatarM = 48.0;
  static const double avatarL = 64.0;
  static const double avatarXL = 96.0;
  static const double avatarXXL = 120.0;

  // Responsive Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  // Performance Constants
  static const int maxCacheSize = 100;
  static const Duration cacheTimeout = Duration(minutes: 30);
  static const double listCacheExtent = 250.0;

  // Network Constants
  static const Duration networkTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Error Messages
  static const String networkErrorMessage =
      'Network connection failed. Please check your internet connection.';
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String loadingMessage = 'Loading...';
  static const String noDataMessage = 'No data available.';

  // Success Messages
  static const String profileUpdatedMessage = 'Profile updated successfully!';
  static const String dataRefreshedMessage = 'Data refreshed successfully!';

  // Feature Flags
  static const bool enablePerformanceMonitoring = false;
  static const bool enableDebugInfo = false;
  static const bool enableAnimations = true;
  static const bool enableHapticFeedback = true;

  // Asset Paths
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';
  static const String avatarsPath = 'assets/images/avatars/';

  // Default Values
  static const String defaultAvatarPath = '';
  static const String defaultName = 'User';
  static const String defaultTitle = 'Developer';
  static const String defaultBio = 'Welcome to my profile!';
}

class AppColors {
  // Primary Colors
  static const int primaryColorValue = 0xFF6366F1;
  static const int secondaryColorValue = 0xFF8B5CF6;

  // Social Media Brand Colors
  static const int githubColor = 0xFF333333;
  static const int linkedinColor = 0xFF0077B5;
  static const int twitterColor = 0xFF1DA1F2;
  static const int instagramColor = 0xFFE4405F;
  static const int facebookColor = 0xFF1877F2;
  static const int youtubeColor = 0xFFFF0000;
  static const int tiktokColor = 0xFF000000;
  static const int discordColor = 0xFF5865F2;
}

class AppStrings {
  // Screen Titles
  static const String profileTitle = 'Profile';
  static const String settingsTitle = 'Settings';
  static const String aboutTitle = 'About';

  // Section Headers
  static const String skillsHeader = 'Skills';
  static const String coreSkillsHeader = 'Core Skills';
  static const String additionalSkillsHeader = 'Additional Skills';
  static const String socialLinksHeader = 'Social Links';
  static const String primaryContactsHeader = 'Primary Contacts';
  static const String themeSettingsHeader = 'Theme Settings';

  // Button Labels
  static const String reloadButton = 'Reload';
  static const String retryButton = 'Retry';
  static const String copyButton = 'Copy';
  static const String shareButton = 'Share';
  static const String editButton = 'Edit';
  static const String saveButton = 'Save';
  static const String cancelButton = 'Cancel';

  // Tooltips
  static const String reloadTooltip = 'Reload Profile';
  static const String themeToggleTooltip = 'Toggle Theme';
  static const String editProfileTooltip = 'Edit Profile';
  static const String shareProfileTooltip = 'Share Profile';

  // Placeholders
  static const String namePlaceholder = 'Enter your name';
  static const String titlePlaceholder = 'Enter your title';
  static const String bioPlaceholder = 'Tell us about yourself';
  static const String urlPlaceholder = 'Enter URL';

  // Validation Messages
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String invalidUrl = 'Please enter a valid URL';
  static const String tooShort = 'Too short';
  static const String tooLong = 'Too long';
}
