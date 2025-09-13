import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/sections/resume_downloader.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/common_widgets.dart';

class HeroSection extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Animation<double> floatingAnimation;
  final bool isMobile;
  final bool isTablet;
  final double screenWidth;

  HeroSection({
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.floatingAnimation,
    required this.isMobile,
    required this.isTablet,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final heroHeight = isMobile ? 500.0 : (isTablet ? 550.0 : 650.0);
    final avatarSize = isMobile ? 50.0 : (isTablet ? 55.0 : 65.0);
    final titleSize = isMobile ? 28.0 : (isTablet ? 36.0 : 52.0);
    final subtitleSize = isMobile ? 14.0 : (isTablet ? 16.0 : 22.0);

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Container(
          height: heroHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF2D3561)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              ...List.generate(30, (index) => _buildEnhancedParticle(index)),
              ...List.generate(5, (index) => _buildFloatingShape(index)),
              Center(
                child: AnimatedBuilder(
                  animation: floatingAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, floatingAnimation.value),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'profile_avatar',
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF00D4FF),
                                    Color(0xFF0099CC),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF00D4FF).withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: avatarSize,
                                backgroundColor: Color(0xFF1A1F3A),
                                child: Icon(
                                  Icons.person,
                                  size: avatarSize * 0.8,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          ShaderMask(
                            shaderCallback:
                                (bounds) => LinearGradient(
                                  colors: [
                                    Color(0xFF00D4FF),
                                    Color(0xFF0099CC),
                                  ],
                                ).createShader(bounds),
                            child: Text(
                              'Farooq Sarwar',
                              style: TextStyle(
                                fontSize: titleSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Flutter & React Native Developer',
                            style: TextStyle(
                              fontSize: subtitleSize,
                              color: Colors.white70,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (!isMobile) ...[
                            SizedBox(height: 8),
                            Text(
                              'Crafting innovative solutions with cutting-edge technology',
                              style: TextStyle(
                                fontSize: subtitleSize * 0.7,
                                color: Colors.white54,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          SizedBox(height: 40),
// Fixed responsive button section
                          isMobile
                              ? Column(
                            children: [
                              // Mobile: Stack buttons vertically
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    HapticFeedback.mediumImpact();

                                    const githubUrl = 'https://github.com/farooqsarwar';

                                    try {
                                      if (await canLaunchUrl(Uri.parse(githubUrl))) {
                                        await launchUrl(
                                          Uri.parse(githubUrl),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      } else {
                                        throw Exception('Could not launch GitHub URL');
                                      }
                                    } catch (e) {
                                      print('Error opening GitHub: $e');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Unable to open GitHub. Please try again.'),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF00D4FF),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 8,
                                    shadowColor: Color(0xFF00D4FF).withOpacity(0.3),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'All Projects',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.open_in_new, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () => GoogleDriveResumeDownload.downloadResume(context),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: BorderSide(color: Colors.white30),
                                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.download, size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        'Resume',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                              : Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 16,
                            children: [
                              // Desktop/Tablet: Side by side with wrap
                              ElevatedButton(
                                onPressed: () async {
                                  HapticFeedback.mediumImpact();

                                  const githubUrl = 'https://github.com/farooqsarwar';

                                  try {
                                    if (await canLaunchUrl(Uri.parse(githubUrl))) {
                                      await launchUrl(
                                        Uri.parse(githubUrl),
                                        mode: LaunchMode.externalApplication,
                                      );
                                    } else {
                                      throw Exception('Could not launch GitHub URL');
                                    }
                                  } catch (e) {
                                    print('Error opening GitHub: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Unable to open GitHub. Please try again.'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF00D4FF),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 24 : 32,
                                    vertical: isTablet ? 12 : 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 8,
                                  shadowColor: Color(0xFF00D4FF).withOpacity(0.3),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'View All Projects',
                                      style: TextStyle(
                                        fontSize: isTablet ? 15 : 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.open_in_new,
                                      size: isTablet ? 18 : 20,
                                    ),
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () => GoogleDriveResumeDownload.downloadResume(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(color: Colors.white30),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 24 : 28,
                                    vertical: isTablet ? 12 : 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.download,
                                      size: isTablet ? 16 : 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Resume',
                                      style: TextStyle(
                                        fontSize: isTablet ? 15 : 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedParticle(int index) {
    final random = (index * 17) % 100;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 1500 + (index * 50)),
      builder: (context, value, child) {
        return Positioned(
          left:
              (random * screenWidth / 100) +
              (value * 30 * (index % 2 == 0 ? 1 : -1)),
          top: (index % 8) * 80.0 + (value * 40),
          child: Opacity(
            opacity: 0.1 + (value * 0.3),
            child: Container(
              width: 3 + (index % 3),
              height: 3 + (index % 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    [
                      Color(0xFF00D4FF),
                      Color(0xFF0099CC),
                      Color(0xFF6C63FF),
                    ][index % 3],
                    [
                      Color(0xFF00D4FF),
                      Color(0xFF0099CC),
                      Color(0xFF6C63FF),
                    ][index % 3].withOpacity(0.7),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: [
                      Color(0xFF00D4FF),
                      Color(0xFF0099CC),
                      Color(0xFF6C63FF),
                    ][index % 3].withOpacity(0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingShape(int index) {
    final shapes = [
      Icons.hexagon,
      Icons.circle,
      Icons.square,
      Icons.panorama_wide_angle_sharp,
      Icons.star,
    ];
    return AnimatedBuilder(
      animation: floatingAnimation,
      builder: (context, child) {
        return Positioned(
          left:
              (index * screenWidth / 6) +
              (floatingAnimation.value * (index % 2 == 0 ? 1 : -1)),
          top: 100.0 + (index * 100.0) + (floatingAnimation.value * 2),
          child: Opacity(
            opacity: 0.05,
            child: Icon(
              shapes[index % shapes.length],
              size: 40 + (index * 10),
              color: Color(0xFF00D4FF),
            ),
          ),
        );
      },
    );
  }
}
