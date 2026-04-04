import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 60,
        vertical: 36,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _Logo(),
                const SizedBox(height: 16),
                const Text(
                  AppStrings.footerCopy,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 20),
                _SocialRow(),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Logo(),
                const Text(
                  AppStrings.footerCopy,
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                _SocialRow(),
              ],
            ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.syne(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        children: const [
          TextSpan(text: 'Farooq'),
          TextSpan(text: '.', style: TextStyle(color: AppColors.accent)),
        ],
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  final _links = const [
    {'icon': '🐙', 'url': AppStrings.githubUrl,   'tip': 'GitHub'},
    {'icon': '💼', 'url': AppStrings.fiverrUrl,   'tip': 'Fiverr'},
    {'icon': '🔗', 'url': AppStrings.linkedinUrl, 'tip': 'LinkedIn'},
    {'icon': '📧', 'url': 'mailto:${AppStrings.email}', 'tip': 'Email'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _links
          .map((l) => _SocialIcon(
                icon: l['icon']!,
                url: l['url']!,
                tooltip: l['tip']!,
              ))
          .toList(),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final String icon;
  final String url;
  final String tooltip;

  const _SocialIcon({
    required this.icon,
    required this.url,
    required this.tooltip,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit:  (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => launchUrl(Uri.parse(widget.url)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(left: 10),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _hovered ? AppColors.accent : AppColors.border,
              ),
              color: AppColors.surface,
            ),
            child: Center(
              child: Text(widget.icon, style: const TextStyle(fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }
}
