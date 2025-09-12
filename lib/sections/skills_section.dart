import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class SkillsSection extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final double screenWidth;

  SkillsSection({
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              buildSectionTitle('Skills & Technologies', isMobile, isTablet),
              SizedBox(height: 60),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);
                  double aspectRatio = isMobile ? 2.2 : (isTablet ? 2.5 : 1.8);

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: isMobile ? 15 : (isTablet ? 20 : 25),
                    mainAxisSpacing: isMobile ? 15 : (isTablet ? 20 : 25),
                    childAspectRatio: aspectRatio,
                    children: [
                      buildEnhancedSkillCard('Flutter', 0.92, Color(0xFF02569B), Icons.flutter_dash, isMobile, isTablet),
                      buildEnhancedSkillCard('React Native', 0.50, Color(0xFF61DAFB), Icons.phone_iphone, isMobile, isTablet),
                      buildEnhancedSkillCard('Web Development', 0.60, Color(0xFF2196F3), Icons.web, isMobile, isTablet),
                      buildEnhancedSkillCard('Problem Solving', 0.90, Color(0xFF4C77A5), Icons.lightbulb, isMobile, isTablet),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}