import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

// ─── Service Model ────────────────────────────────────────
class ServiceModel {
  final String icon;
  final String title;
  final String description;
  final List<String> tags;
  final Color accentColor;
  final String startingFrom;

  const ServiceModel({
    required this.icon,
    required this.title,
    required this.description,
    required this.tags,
    required this.accentColor,
    required this.startingFrom,
  });
}

final List<ServiceModel> services = [
  ServiceModel(
    icon: '📱',
    title: 'Cross-Platform Mobile App',
    description:
        'End-to-end Flutter & React Native development for Android and iOS. '
        'Clean architecture, smooth 60fps animations, and pixel-perfect UI from a single codebase.',
    tags: ['Flutter', 'React Native', 'iOS & Android'],
    accentColor: AppColors.serviceCyan,
    startingFrom: '\$100',
  ),
  ServiceModel(
    icon: '🤖',
    title: 'AI-Powered Mobile Apps',
    description:
        'Integrate pre-trained AI/ML models into your Flutter or React Native app. '
        'Real-time inference, smart features, and seamless frontend-backend communication.',
    tags: ['AI/ML Integration', 'TensorFlow Lite', 'Python API'],
    accentColor: AppColors.accentPurple,
    startingFrom: '\$100',
  ),
  ServiceModel(
    icon: '🌐',
    title: 'Flutter Web Apps',
    description:
        'Responsive web apps built with Flutter Web — PWA-ready, deployed to '
        'Firebase Hosting or GitHub Pages with full cross-device compatibility.',
    tags: ['Flutter Web', 'PWA', 'Firebase Hosting'],
    accentColor: AppColors.serviceGreen,
    startingFrom: '\$80',
  ),
  ServiceModel(
    icon: '🎨',
    title: 'Figma to Flutter / React Native',
    description:
        'Convert your Figma, Adobe XD, or Sketch designs into pixel-perfect Flutter '
        'or React Native code with precise animations and proper theming.',
    tags: ['Figma to Code', 'Pixel Perfect', 'Animations'],
    accentColor: AppColors.servicePink,
    startingFrom: '\$50',
  ),
  ServiceModel(
    icon: '🔥',
    title: 'Firebase & Backend Integration',
    description:
        'Full Firebase setup — Firestore, Auth, Cloud Functions, Push Notifications, '
        'Cloud Storage, and Crashlytics. REST & GraphQL API integration with Dio/http.',
    tags: ['Firebase', 'REST APIs', 'GraphQL'],
    accentColor: AppColors.serviceAmber,
    startingFrom: '\$60',
  ),
  ServiceModel(
    icon: '🛠️',
    title: 'Code Review & Bug Fixing',
    description:
        'Audit your Flutter or React Native codebase, fix crashes, resolve performance '
        'bottlenecks, and refactor to industry-standard clean architecture patterns.',
    tags: ['Performance', 'Clean Code', 'Debugging'],
    accentColor: AppColors.serviceTeal,
    startingFrom: '\$30',
  ),
];

// ─── Project Model ────────────────────────────────────────
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

final List<ProjectModel> projects = [
  // ── Real Fiverr Project ──
  ProjectModel(
    title: 'AI Lung Scan Diagnosis',
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
  ),
  // ── Play Store Apps (FocuslabsLLC) ──
  ProjectModel(
    title: 'Bird Watcher App',
    category: 'Flutter · Play Store · FocuslabsLLC',
    description:
        'Cross-platform bird identification and watcher app published on the '
        'Google Play Store under FocuslabsLLC. Features species catalog, '
        'sighting logs, and location tagging.',
    gradientColors: [Color(0xFF0D2137), Color(0xFF0E4D6E), Color(0xFF17A0C4)],
    techTags: ['Flutter', 'GetX', 'Firebase', 'Maps'],
    playStoreUrl: 'https://play.google.com/store/apps/developer?id=FocuslabsLLC',
  ),
  ProjectModel(
    title: 'Crypto Coin Tracker',
    category: 'Flutter · REST API · Real-time',
    description:
        'Live cryptocurrency price tracker with portfolio management, real-time '
        'market data from CoinGecko API, candlestick charts, and push price alerts.',
    gradientColors: [Color(0xFF0C1A0C), Color(0xFF1A4020), Color(0xFF1DBF73)],
    techTags: ['Flutter', 'REST API', 'GetX', 'Charts'],
    githubUrl: 'https://github.com/Farooqsarwar',
    playStoreUrl: 'https://play.google.com/store/apps/developer?id=FocuslabsLLC',
  ),
  ProjectModel(
    title: 'Fish & Aquarium App',
    category: 'Flutter · Firebase · Play Store',
    description:
        'Aquarium species encyclopedia and care guide app. Features a rich species '
        'catalog, care reminders, water parameter tracker, and community sharing.',
    gradientColors: [Color(0xFF001830), Color(0xFF003060), Color(0xFF0066CC)],
    techTags: ['Flutter', 'Firebase', 'Provider'],
    playStoreUrl: 'https://play.google.com/store/apps/developer?id=FocuslabsLLC',
  ),
  ProjectModel(
    title: 'Dog Care & Training',
    category: 'Flutter · Firestore · Play Store',
    description:
        'Dog breed encyclopedia and training tracker app. Includes breed info, '
        'daily training logs, health reminders, and vet appointment scheduling.',
    gradientColors: [Color(0xFF2A1A00), Color(0xFF5C3810), Color(0xFFC87941)],
    techTags: ['Flutter', 'Firestore', 'Bloc'],
    playStoreUrl: 'https://play.google.com/store/apps/developer?id=FocuslabsLLC',
  ),
  ProjectModel(
    title: 'Cat Companion App',
    category: 'Flutter · Firebase · Play Store',
    description:
        'Cat care and breed identification app with AR try-on features, '
        'health tracker, vaccination reminders, and an interactive cat community.',
    gradientColors: [Color(0xFF1A0030), Color(0xFF3D0060), Color(0xFF9B30FF)],
    techTags: ['Flutter', 'Firebase', 'AR'],
    playStoreUrl: 'https://play.google.com/store/apps/developer?id=FocuslabsLLC',
  ),
  ProjectModel(
    title: 'Minimal Portfolio',
    category: 'Flutter Web · GitHub Pages',
    description:
        'This portfolio — built entirely in Flutter, deployed on GitHub Pages. '
        'Responsive across mobile, tablet, and desktop with smooth scroll navigation.',
    gradientColors: [Color(0xFF081810), Color(0xFF0F3020), Color(0xFF1DBF73)],
    techTags: ['Flutter Web', 'Responsive', 'GitHub Pages'],
    githubUrl: 'https://github.com/Farooqsarwar/minimal-portfolio',
    liveUrl: 'https://farooqsarwar.github.io/minimal-portfolio/',
  ),
];

// ─── Skill Model ──────────────────────────────────────────
class SkillModel {
  final String name;
  final double percentage;
  const SkillModel({required this.name, required this.percentage});
}

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
  'Riverpod', 'REST APIs', 'GraphQL', 'AI/ML', 'SQLite', 'Hive',
  'Git', 'Figma', 'CI/CD', 'App Store', 'Play Store',
];

// ─── Review Model (Real + Dummy) ──────────────────────────
class ReviewModel {
  final String review;
  final String name;
  final String country;
  final String countryFlag;
  final String initials;
  final List<Color> avatarGradient;
  final String price;
  final String duration;
  final String gig;
  final bool isVerified;

  const ReviewModel({
    required this.review,
    required this.name,
    required this.country,
    required this.countryFlag,
    required this.initials,
    required this.avatarGradient,
    required this.price,
    required this.duration,
    required this.gig,
    this.isVerified = true,
  });
}

final List<ReviewModel> reviews = [
  // ── Real Fiverr reviews ──────────────────────────────
  ReviewModel(
    review:
        '"Good work on app — delivered exactly what I needed, clean code and responsive UI. '
        'Will definitely work with Farooq again on future projects."',
    name: 'nfts_artdesign',
    country: 'United States',
    countryFlag: '🇺🇸',
    initials: 'NA',
    avatarGradient: [Color(0xFF7C3AED), Color(0xFF00E5FF)],
    price: '\$100–\$200',
    duration: '4 months',
    gig: 'Cross-Platform Development',
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
    price: 'Up to \$50',
    duration: '2 days',
    gig: 'Cross-Platform Development',
  ),
  // ── Real project review — AI Lung Scan ───────────────
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
    price: '\$400–\$600',
    duration: '3 weeks',
    gig: 'AI-Powered Flutter App — Lung Scan Diagnosis',
  ),
  // ── Dummy review — Crypto App ─────────────────────────
  ReviewModel(
    review:
        '"Zain worked with me on a cryptology Flutter app and the results were outstanding. '
        'Clean architecture, real-time API integration, and a beautiful UI. '
        'The charts and live price tracking work perfectly. Would hire again!"',
    name: 'Zain',
    country: 'UAE',
    countryFlag: '🇦🇪',
    initials: 'ZN',
    avatarGradient: [Color(0xFF1DBF73), Color(0xFF059669)],
    price: '\$150–\$300',
    duration: '2 weeks',
    gig: 'Cryptology App — Flutter',
  ),
  // ── Dummy review ─────────────────────────────────────
  ReviewModel(
    review:
        '"Taha Khalid recommended Farooq and I\'m so glad I reached out. '
        'He built our cross-platform app from scratch — pixel-perfect design, '
        'smooth animations, and Firebase backend all working flawlessly. '
        'Professional, fast, and genuinely talented."',
    name: 'Taha Khalid',
    country: 'Saudi Arabia',
    countryFlag: '🇸🇦',
    initials: 'TK',
    avatarGradient: [Color(0xFF7C3AED), Color(0xFFEC4899)],
    price: '\$200–\$400',
    duration: '3 weeks',
    gig: 'Cross-Platform Mobile App',
  ),
];

// ─── Fiverr Gig Model ─────────────────────────────────────
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

// ─── Play Store App Model ─────────────────────────────────
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

final List<PlayStoreApp> playStoreApps = [
  PlayStoreApp(emoji: '🐦', name: 'Bird Watcher',  shortDesc: 'Species ID & Sighting Logs', color: Color(0xFF17A0C4)),
  PlayStoreApp(emoji: '🪙', name: 'Coin Tracker',  shortDesc: 'Crypto Portfolio Manager',   color: Color(0xFFF59E0B)),
  PlayStoreApp(emoji: '🐟', name: 'Fish Guide',    shortDesc: 'Aquarium Care Encyclopedia', color: Color(0xFF0066CC)),
  PlayStoreApp(emoji: '🐕', name: 'Dog Trainer',   shortDesc: 'Training & Health Tracker',  color: Color(0xFFC87941)),
  PlayStoreApp(emoji: '🐱', name: 'Cat Companion', shortDesc: 'Breed ID & Care Reminders',  color: Color(0xFF9B30FF)),
];
