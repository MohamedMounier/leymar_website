class AppConstants {
  AppConstants._();

  static const String appName = 'Yelmar';
  static const String tagline = 'Engineering Flexibility. Weaving Excellence.';

  // Breakpoints
  static const double mobileBreakpoint = 767;
  static const double tabletBreakpoint = 1199;
  static const double desktopBreakpoint = 1200;

  // Thread animation
  static const int threadParticleCount = 60;
  static const double threadMaxDistance = 180;

  // Animation durations
  static const Duration fastDuration = Duration(milliseconds: 300);
  static const Duration normalDuration = Duration(milliseconds: 600);
  static const Duration slowDuration = Duration(milliseconds: 1000);
  static const Duration verySlowDuration = Duration(milliseconds: 1500);

  // Contact info
  static const String whatsApp = '+201148030847';
  static const String email = 'info@yelmar.com';
  static const String phone = '+20 114 80 30 847';
  static const String address = 'Egypt, Cairo';

  // Navigation items
  static const List<String> navItems = [
    'Home',
    'About',
    'Capabilities',
    'Products',
    'Industries',
    'Factory Tour',
    'Contact',
  ];
}
