import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildSectionTitle(String title, bool isMobile, bool isTablet) {
  return Column(
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: isMobile ? 28 : (isTablet ? 34 : 40),
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 16),
      Container(
        width: 80,
        height: 4,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
          ),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      SizedBox(height: 8),
    ],
  );
}

Widget buildEnhancedSkillCard(String skill, double progress, Color color, IconData icon, bool isMobile, bool isTablet) {
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: progress),
    duration: Duration(milliseconds: 2000),
    curve: Curves.easeOutCubic,
    builder: (context, value, child) {
      return Container(
        padding: EdgeInsets.all(isMobile ? 16 : (isTablet ? 18 : 20)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.12),
              Colors.white.withOpacity(0.06),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: isMobile ? 20 : 24,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  skill,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 16 : (isTablet ? 17 : 18),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Proficiency',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: isMobile ? 12 : 13,
                      ),
                    ),
                    Text(
                      '${(value * 100).toInt()}%',
                      style: TextStyle(
                        color: color,
                        fontSize: isMobile ? 14 : 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color, color.withOpacity(0.7)],
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
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
  );
}

Widget buildEnhancedProjectCard(
    String title,
    String description,
    List<String> techStack,
    Color color,
    IconData icon,
    bool isMobile,
    bool isTablet,
    int index, {
      String? githubUrl,
    }) {
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: Duration(milliseconds: 800 + (index * 200)),
    curve: Curves.easeOutCubic,
    builder: (context, value, child) {
      return Transform.translate(
        offset: Offset(0, (1 - value) * 50),
        child: Opacity(
          opacity: value,
          child: Container(
            padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 25 : 30)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
            child: isMobile
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                SizedBox(height: 20),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 18 : (isTablet ? 20 : 22),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isMobile ? 14 : (isTablet ? 15 : 16),
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: techStack.map((tech) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Text(
                      tech,
                      style: TextStyle(
                        color: color,
                        fontSize: isMobile ? 11 : 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )).toList(),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.visibility, size: 18),
                            SizedBox(width: 8),
                            Text('View Demo'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: IconButton(
                        onPressed: githubUrl != null
                            ? () async {
                          final uri = Uri.parse(githubUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Could not launch GitHub URL')),
                            );
                          }
                          HapticFeedback.lightImpact();
                        }
                            : null,
                        icon: Icon(Icons.code, color: Colors.white70, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            )
                : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: color, size: 40),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 20 : 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isTablet ? 15 : 16,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: techStack.map((tech) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: color.withOpacity(0.3)),
                          ),
                          child: Text(
                            tech,
                            style: TextStyle(
                              color: color,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )).toList(),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.visibility, size: 18),
                                SizedBox(width: 8),
                                Text('View Live Demo'),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: githubUrl != null
                                ? () async {
                              final uri = Uri.parse(githubUrl);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Could not launch GitHub URL')),
                                );
                              }
                              HapticFeedback.lightImpact();
                            }
                                : null,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white70,
                              side: BorderSide(color: Colors.white30),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.code, size: 18),
                                SizedBox(width: 8),
                                Text('Code'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget buildEducationItem(String title, String content, bool isMobile, bool isTablet) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          color: Color(0xFF00D4FF),
          fontSize: isMobile ? 14 : (isTablet ? 15 : 16),
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 8),
      Text(
        content,
        style: TextStyle(
          color: Colors.white70,
          fontSize: isMobile ? 13 : (isTablet ? 14 : 15),
          height: 1.6,
        ),
      ),
    ],
  );
}

Widget buildContactField(String label, TextEditingController controller, bool isMobile, bool isTablet, {int maxLines = 1}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: isMobile ? 14 : (isTablet ? 15 : 16),
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.08),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF00D4FF)),
          ),
          hintText: 'Enter your $label',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        ),
      ),
    ],
  );
}

Widget buildSocialButton(IconData icon, Color color, String label, String url) {
  return Tooltip(
    message: label,
    child: Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: IconButton(
        onPressed: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            // Context might not be available here, so this is a fallback
            print('Could not launch $url');
          }
          HapticFeedback.lightImpact();
        },
        icon: Icon(icon, color: color, size: 20),
      ),
    ),
  );
}

Widget buildContactInfoItem(IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, color: Color(0xFF00D4FF), size: 18),
      SizedBox(width: 12),
      Text(
        text,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 15,
        ),
      ),
    ],
  );
}

double getHorizontalPadding(bool isMobile, bool isTablet) {
  return isMobile ? 16 : (isTablet ? 24 : 32);
}

double getVerticalPadding(bool isMobile, bool isTablet) {
  return isMobile ? 60 : (isTablet ? 80 : 100);
}