import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              colors: [
                Color(0xFF0A0E27),
                Color(0xFF1A1F3A),
                Color(0xFF2D3561),
              ],
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
                                  colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
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
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  HapticFeedback.mediumImpact();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF00D4FF),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 20 : 28,
                                    vertical: isMobile ? 12 : 14,
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
                                      'View Projects',
                                      style: TextStyle(
                                        fontSize: isMobile ? 14 : 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward, size: isMobile ? 16 : 20),
                                  ],
                                ),
                              ),
                              if (!isMobile) ...[
                                SizedBox(width: 16),
                                OutlinedButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: BorderSide(color: Colors.white30),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 28,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.download, size: 18),
                                      SizedBox(width: 8),
                                      Text('Resume'),
                                    ],
                                  ),
                                ),
                              ],
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
          left: (random * screenWidth / 100) + (value * 30 * (index % 2 == 0 ? 1 : -1)),
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
    final shapes = [Icons.hexagon, Icons.circle, Icons.square, Icons.panorama_wide_angle_sharp, Icons.star];
    return AnimatedBuilder(
      animation: floatingAnimation,
      builder: (context, child) {
        return Positioned(
          left: (index * screenWidth / 6) + (floatingAnimation.value * (index % 2 == 0 ? 1 : -1)),
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