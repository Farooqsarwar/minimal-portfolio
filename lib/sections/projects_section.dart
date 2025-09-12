import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class ProjectsSection extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final double screenWidth;

  ProjectsSection({
    Key? key,
    required this.isMobile,
    required this.isTablet,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getHorizontalPadding(isMobile, isTablet),
        vertical: getVerticalPadding(isMobile, isTablet),
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              buildSectionTitle('Featured Projects', isMobile, isTablet),
              SizedBox(height: 60),
              Column(
                children: [
                  buildEnhancedProjectCard(
                    'AI-Driven Auction App',
                    'Designed and developed an AI-powered auction platform featuring dynamic pricing predictions, real-time bid optimization, and price prediction for an immersive and efficient bidding experience.',
                    ['Flutter', 'Dart', 'AI/ML'],
                    Color(0xFF6C63FF),
                    Icons.gavel,
                    isMobile,
                    isTablet,
                    0,
                    githubUrl: 'https://github.com/Farooqsarwar/fyp',
                  ),
                  SizedBox(height: 30),
                  buildEnhancedProjectCard(
                    'Image Encryption & Decryption App',
                    'Created a secure mobile app using Flutter for the frontend and a Python backend to perform advanced image steganography. The app enables users to hide text within images and even conceal one image inside another, ensuring data confidentiality and secure communication.',
                    ['Flutter', 'Python', 'Dart', 'Steganography'],
                    Color(0xFF26A69A),
                    Icons.lock,
                    isMobile,
                    isTablet,
                    1,
                    githubUrl: 'https://github.com/Farooqsarwar/cryptology_app_in_flutter',
                  ),
                  SizedBox(height: 30),
                  buildEnhancedProjectCard(
                    'Weather App',
                    'Built a weather forecasting app allowing users to fetch real-time weather data based on location input.',
                    ['Flutter', 'Dart', 'API'],
                    Color(0xFFFF7043),
                    Icons.wb_sunny,
                    isMobile,
                    isTablet,
                    2,
                    githubUrl: 'https://github.com/Farooqsarwar/weather-app-in-flutter',
                  ),
                  SizedBox(height: 30),
                  buildEnhancedProjectCard(
                    'AI Lung Scan App',
                    'Integrated a pre-trained AI model into a mobile application. The app allows users to upload lung scan images, which are sent to the AI model for prediction and diagnosis. Ensured seamless communication between the frontend and backend for real-time inference and result display.',
                    ['Flutter', 'AI/ML', 'Dart'],
                    Color(0xFF0288D1),
                    Icons.medical_services,
                    isMobile,
                    isTablet,
                    3,
                    githubUrl: 'https://github.com/Farooqsarwar/weather-app-in-flutter',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}