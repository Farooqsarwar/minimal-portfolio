import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  final bool isMobile;

  FooterSection({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              ' Farooq Sarwar. All rights reserved.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Built with Flutter & ❤️',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}