import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

// ==========================================================
// ─── MODEL DEFINITIONS ────────────────────────────────────
// ==========================================================

class ServiceModel {
  final String icon;
  final String title;
  final String description;
  final List<String> tags;
  final Color accentColor;

  const ServiceModel({
    required this.icon,
    required this.title,
    required this.description,
    required this.tags,
    required this.accentColor,
  });
}

class ProjectModel {
  final String title;
  final String category;
  final String description;
  final List<Color> gradientColors;
  final String? githubUrl;
  final String? liveUrl;
  final String? playStoreUrl;
  final List<String> techTags;
  final bool isFeatured;
  final String? cost;
  final String? duration;

  const ProjectModel({
    required this.title,
    required this.category,
    required this.description,
    required this.gradientColors,
    required this.techTags,
    this.githubUrl,
    this.liveUrl,
    this.playStoreUrl,
    this.isFeatured = false,
    this.cost,
    this.duration,
  });
}

class SkillModel {
  final String name;
  final double percentage;
  const SkillModel({required this.name, required this.percentage});
}

class ReviewModel {
  final String review;
  final String name;
  final String country;
  final String countryFlag;
  final String initials;
  final List<Color> avatarGradient;
  final String duration;
  final bool isVerified;
  final String? platform;

  const ReviewModel({
    required this.review,
    required this.name,
    required this.country,
    required this.countryFlag,
    required this.initials,
    required this.avatarGradient,
    required this.duration,
    this.isVerified = true,
    this.platform,
  });
}

class GigModel {
  final String icon;
  final String title;
  final String description;
  final String price;
  final String slug;

  const GigModel({
    required this.icon,
    required this.title,
    required this.description,
    required this.price,
    required this.slug,
  });
}

class PlayStoreApp {
  final String emoji;
  final String name;
  final String shortDesc;
  final Color color;

  const PlayStoreApp({
    required this.emoji,
    required this.name,
    required this.shortDesc,
    required this.color,
  });
}


// ==========================================================
// ─── DATA INSTANCES ───────────────────────────────────────
// ==========================================================

// ─── Services ─────────────────────────────────────────────
final List<ServiceModel> services = [
  ServiceModel(
    icon: '📱',
    title: 'Cross-Platform Mobile App',
    description:
    'End-to-end Flutter & React Native development for Android and iOS. '
        'Clean architecture, smooth 60fps animations, and pixel-perfect UI from a single codebase.',
    tags: ['Flutter', 'React Native', 'iOS & Android'],
    accentColor: AppColors.serviceCyan,
  ),
  ServiceModel(
    icon: '🤖',
    title: 'AI-Powered Mobile Apps',
    description:
    'Integrate pre-trained AI/ML models into your Flutter or React Native app. '
        'Real-time inference, smart features, and seamless frontend-backend communication.',
    tags: ['AI/ML Integration', 'TensorFlow Lite', 'Python API'],
    accentColor: AppColors.accentPurple,
  ),
  ServiceModel(
    icon: '🌐',
    title: 'Flutter Web Apps',
    description:
    'Responsive web apps built with Flutter Web — PWA-ready, deployed to '
        'Firebase Hosting or GitHub Pages with full cross-device compatibility.',
    tags: ['Flutter Web', 'PWA', 'Firebase Hosting'],
    accentColor: AppColors.serviceGreen,
  ),
  ServiceModel(
    icon: '🎨',
    title: 'Figma to Flutter / React Native',
    description:
    'Convert your Figma, Adobe XD, or Sketch designs into pixel-perfect Flutter '
        'or React Native code with precise animations and proper theming.',
    tags: ['Figma to Code', 'Pixel Perfect', 'Animations'],
    accentColor: AppColors.servicePink,
  ),
  ServiceModel(
    icon: '🔥',
    title: 'Firebase & Backend Integration',
    description:
    'Full Firebase setup — Firestore, Auth, Cloud Functions, Push Notifications, '
        'Cloud Storage, and Crashlytics. REST & GraphQL API integration with Dio/http.',
    tags: ['Firebase', 'REST APIs', 'GraphQL'],
    accentColor: AppColors.serviceAmber,
  ),
  ServiceModel(
    icon: '🛠️',
    title: 'Code Review & Bug Fixing',
    description:
    'Audit your Flutter or React Native codebase, fix crashes, resolve performance '
        'bottlenecks, and refactor to industry-standard clean architecture patterns.',
    tags: ['Performance', 'Clean Code', 'Debugging'],
    accentColor: AppColors.serviceTeal,
  ),
];

// ─── Projects ─────────────────────────────────────────────
final List<ProjectModel> projects = [
  // ── Featured: Real Fiverr Project ──
  ProjectModel(
    title: 'Lung Scan AI',
    category: 'AI · Flutter · REST API',
    description:
    'Integrated a pre-trained AI model into a mobile app allowing users to upload '
        'lung scan images for real-time AI diagnosis. Seamless frontend-backend '
        'communication for instant inference and result display.',
    gradientColors: [Color(0xFF0A0A1A), Color(0xFF1A1040), Color(0xFF3B1FA8)],
    techTags: ['Flutter', 'AI/ML', 'Python API', 'Firebase'],
    isFeatured: true,
    cost: '\$400–\$600',
    duration: '7–30 days',
    githubUrl: 'https://github.com/Farooqsarwar/lung-scan-Ai',
  ),

  // ── GitHub Projects ──
  ProjectModel(
    title: 'Auction App',
    category: 'Flutter · Firebase · Bidding System',
    description:
    'Full-featured auction platform where users can list items, place bids, '
        'track auctions in real-time, and manage their auction history. Built with '
        'Flutter and Firebase for seamless bidding experience.',
    gradientColors: [Color(0xFF1A0A2A), Color(0xFF3D2A5A), Color(0xFF7C3AED)],
    techTags: ['Flutter', 'Firebase', 'Real-time DB', 'Dart'],
    githubUrl: 'https://github.com/Farooqsarwar/fyp',
  ),
  ProjectModel(
    title: 'Minimal Social Media Web App',
    category: 'Flutter Web · Social Platform',
    description:
    'Responsive social media web application built with Flutter Web. Features user profiles, '
        'post creation, real-time updates, and social interactions. Fully responsive design.',
    gradientColors: [Color(0xFF0F1A2A), Color(0xFF1A3A4A), Color(0xFF00D4FF)],
    techTags: ['Flutter Web', 'Firebase', 'Responsive', 'Dart'],
    githubUrl: 'https://github.com/Farooqsarwar/minimal-social-maedia-web-app-Flutter-',
  ),
  ProjectModel(
    title: 'Tic Tac Toe',
    category: 'React Native · Firebase · Multiplayer',
    description:
    'Interactive multiplayer Tic Tac Toe game built with React Native. Features real-time '
        'gameplay, score tracking, Firebase backend for player data, and smooth animations.',
    gradientColors: [Color(0xFF1A0020), Color(0xFF4A0080), Color(0xFFFF006E)],
    techTags: ['React Native', 'Firebase', 'JavaScript', 'Multiplayer'],
    githubUrl: 'https://github.com/Farooqsarwar/tictactoe-reactnative-firebase',
  ),
  ProjectModel(
    title: 'V Chat',
    category: 'Flutter · Firebase · Real-time Messaging',
    description:
    'Real-time messaging application with user authentication, instant notifications, '
        'message history, and user presence detection. Built with Flutter and Firebase.',
    gradientColors: [Color(0xFF0A1A2A), Color(0xFF1A3A5A), Color(0xFF00B4DB)],
    techTags: ['Flutter', 'Firebase', 'Authentication', 'Real-time'],
    githubUrl: 'https://github.com/Farooqsarwar/V-chat',
  ),
  ProjectModel(
    title: 'Steganography App',
    category: 'Flutter · Flask API · Security',
    description:
    'Advanced steganography application to securely hide images inside images '
        'and embed secret text within images. Supports encoding and decoding with '
        'a clean user interface and a powerful Flask backend for secure processing.',
    gradientColors: [Color(0xFF0C1A0C), Color(0xFF1A4020), Color(0xFF1DBF73)],
    techTags: ['Flutter', 'Cryptography', 'Dart', 'Security'],
    githubUrl: 'https://github.com/Farooqsarwar/cryptology_app_in_flutter',
  ),
  ProjectModel(
    title: 'Music Player',
    category: 'Flutter · Audio · Media Player',
    description:
    'Feature-rich music player app with playlist management, audio visualization, '
        'shuffle and repeat modes, and beautiful UI. Supports multiple audio formats.',
    gradientColors: [Color(0xFF1A0A1A), Color(0xFF3A1A2A), Color(0xFFDA70D6)],
    techTags: ['Flutter', 'Audio Plugin', 'UI/UX', 'Media Management'],
    githubUrl: 'https://github.com/Farooqsarwar/Music-player-in-flutter',
  ),
];

// ─── Skills & Tools ───────────────────────────────────────
final List<SkillModel> skills = [
  SkillModel(name: 'Flutter / Dart',                        percentage: 0.95),
  SkillModel(name: 'React Native',                          percentage: 0.85),
  SkillModel(name: 'Firebase (Auth, Firestore, Functions)', percentage: 0.90),
  SkillModel(name: 'State Management (Bloc/GetX/Riverpod)', percentage: 0.88),
  SkillModel(name: 'REST API & GraphQL Integration',        percentage: 0.92),
  SkillModel(name: 'AI/ML Model Integration',               percentage: 0.78),
  SkillModel(name: 'UI/UX — Figma to Code',                 percentage: 0.90),
  SkillModel(name: 'CI/CD, Git & App Store Deployment',     percentage: 0.82),
];

final List<Map<String, String>> tools = [
  {'icon': '📱', 'name': 'Flutter'},
  {'icon': '⚛️',  'name': 'React Native'},
  {'icon': '🎯', 'name': 'Dart'},
  {'icon': '🔥', 'name': 'Firebase'},
  {'icon': '🗄️', 'name': 'SQLite'},
  {'icon': '🐝', 'name': 'Hive DB'},
  {'icon': '🐙', 'name': 'GitHub'},
  {'icon': '🎨', 'name': 'Figma'},
  {'icon': '☁️', 'name': 'Cloud Fn'},
  {'icon': '🤖', 'name': 'TF Lite'},
  {'icon': '⚙️', 'name': 'VS Code'},
  {'icon': '🚀', 'name': 'CI/CD'},
];

final List<String> skillTags = [
  'Flutter', 'Dart', 'React Native', 'Firebase', 'GetX', 'Bloc/Cubit',
  'REST APIs', 'GraphQL', 'AI/ML', 'SQLite', 'Hive',
  'Git', 'Figma', 'CI/CD', 'App Store', 'Play Store',
];

// ─── Reviews ──────────────────────────────────────────────
final List<ReviewModel> reviews = [
  ReviewModel(
    review:
    '"Good work on app — delivered exactly what I needed, clean code and responsive UI. '
        'Will definitely work with Farooq again on future projects."',
    name: 'nfts_artdesign',
    country: 'United States',
    countryFlag: '🇺🇸',
    initials: 'NA',
    avatarGradient: [Color(0xFF7C3AED), Color(0xFF00E5FF)],
    duration: '4 months',
  ),
  ReviewModel(
    review:
    '"I had a great experience working with Farooq! It was my first task with him, '
        'and I didn\'t expect such fast and quality delivery. '
        'Soon will have more to coordinate. Definitely recommend him!"',
    name: 'naqeeb511',
    country: 'Australia',
    countryFlag: '🇦🇺',
    initials: 'NQ',
    avatarGradient: [Color(0xFF059669), Color(0xFF06B6D4)],
    duration: '2 days',
    platform: 'Fiverr',
  ),
  ReviewModel(
    review:
    '"Farooq integrated our AI model seamlessly into the Flutter app. '
        'The lung scan prediction feature works flawlessly in real-time. '
        'Communication was excellent and he delivered ahead of schedule. Highly recommended!"',
    name: 'Ilyas',
    country: 'Pakistan',
    countryFlag: '🇵🇰',
    initials: 'IL',
    avatarGradient: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    duration: '3 weeks',
  ),
  ReviewModel(
    review:
    '"Zain worked with me on a cryptology Flutter app and the results were outstanding. '
        'Clean architecture, real-time API integration, and a beautiful UI. '
        'The charts and live price tracking work perfectly. Would hire again!"',
    name: 'Zain',
    country: 'Pakistan',
    countryFlag: '🇵🇰',
    initials: 'ZN',
    avatarGradient: [Color(0xFF1DBF73), Color(0xFF059669)],
    duration: '2 weeks',
  ),
];

// ─── Fiverr Gigs ──────────────────────────────────────────
final List<GigModel> fiverrGigs = [
  GigModel(
    icon: '📱',
    title: 'Cross-Platform Mobile App',
    description:
    'Android & iOS app using Flutter or React Native with clean architecture',
    price: 'From \$100',
    slug: 'i-will-develop-mobile-app-for-android-and-ios',
  ),
  GigModel(
    icon: '🤖',
    title: 'AI-Powered Flutter App',
    description:
    'Design & develop AI-powered Flutter and React Native mobile apps',
    price: 'From \$100',
    slug: 'i-will-design-and-develop-ai-powered-flutter-app',
  ),
  GigModel(
    icon: '🎨',
    title: 'Figma to Flutter / RN',
    description:
    'Convert your Figma designs to pixel-perfect Flutter or React Native',
    price: 'From \$50',
    slug: 'i-will-convert-figma-to-flutter',
  ),
];

// ─── Play Store Apps ──────────────────────────────────────
final List<PlayStoreApp> playStoreApps = [
  PlayStoreApp(emoji: '🐦', name: 'Bird Watcher',  shortDesc: 'Species ID & Sighting Logs', color: Color(0xFF17A0C4)),
  PlayStoreApp(emoji: '🪙', name: 'Coin Tracker',  shortDesc: 'Crypto Portfolio Manager',   color: Color(0xFFF59E0B)),
  PlayStoreApp(emoji: '🐟', name: 'Fish Guide',    shortDesc: 'Aquarium Care Encyclopedia', color: Color(0xFF0066CC)),
  PlayStoreApp(emoji: '🐕', name: 'Dog Trainer',   shortDesc: 'Training & Health Tracker',  color: Color(0xFFC87941)),
  PlayStoreApp(emoji: '🐱', name: 'Cat Companion', shortDesc: 'Breed ID & Care Reminders',  color: Color(0xFF9B30FF)),
];