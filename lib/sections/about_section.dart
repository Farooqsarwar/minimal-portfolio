import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class AboutSection extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final double screenWidth;

  AboutSection({
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
              buildSectionTitle('About Me', isMobile, isTablet),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(isMobile ? 24 : (isTablet ? 32 : 40)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.03),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Aspiring Software Developer with hands-on experience in Flutter and a foundational understanding of web development. Eager to expand my expertise into areas such as Artificial Intelligence and full-stack web development. Passionate about learning new technologies and building innovative solutions.',
                      style: TextStyle(
                        fontSize: isMobile ? 15 : (isTablet ? 16 : 17),
                        color: Colors.white70,
                        height: 1.8,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (!isMobile) ...[
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem('2+', 'Years Experience', isMobile),
                          _buildStatItem('10+', 'Projects Completed', isMobile),
                          _buildStatItem('90%', 'Client Satisfaction', isMobile),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String number, String label, bool isMobile) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
          ).createShader(bounds),
          child: Text(
            number,
            style: TextStyle(
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 12 : 14,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }
}