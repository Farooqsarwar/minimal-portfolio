import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class EducationSection extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final double screenWidth;

  EducationSection({
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
              buildSectionTitle('Education & Experience', isMobile, isTablet),
              SizedBox(height: 60),
              Container(
                padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 30 : 40)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
// Replace the Row section in your education section with this updated code:

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFF00D4FF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF00D4FF).withOpacity(0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.school,
                            color: Color(0xFF00D4FF),
                            size: isMobile ? 28 : 32,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(  // Add this Expanded widget
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BS in Computer Science',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 18 : (isTablet ? 20 : 24),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4), // Add some spacing
                              Text(
                                'Iqra university Islamabad campus • 2021-2025',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: isMobile ? 14 : 16,
                                ),
                                overflow: TextOverflow.ellipsis, // Handle overflow
                                maxLines: isMobile ? 2 : 1, // Allow 2 lines on mobile
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),                    SizedBox(height: 30),
                    buildEducationItem('Key Courses:', 'Data Structures & Algorithms, Object-Oriented Programming, Database Systems, Artificial Intelligence, Web Development, Mobile App Development', isMobile, isTablet),
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                    buildEducationItem('Final Year Project:', 'Designed and developed an AI-powered auction platform featuring dynamic pricing predictions, real-time bid optimization, and AR-based item visualization for an immersive and efficient bidding experience.', isMobile, isTablet),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}