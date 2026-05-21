import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 28 : 34,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: isMobile
              ? Column(
            children: const [
              _LogoBlock(),
              SizedBox(height: 18),
              Text(
                AppStrings.footerCopy,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  color: AppColors.textMuted,
                ),
              ),
              SizedBox(height: 18),
              _SocialRow(),
            ],
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Expanded(child: _LogoBlock()),
              Expanded(
                child: Text(
                  AppStrings.footerCopy,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _SocialRow(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoBlock extends StatelessWidget {
  const _LogoBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: MediaQuery.of(context).size.width < 768
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.syne(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
            children: const [
              TextSpan(text: 'Farooq'),
              TextSpan(
                text: '.',
                style: TextStyle(color: AppColors.accent),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Flutter & React Native Developer',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textMuted.withOpacity(0.85),
          ),
        ),
      ],
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow();

  static const List<_SocialItem> _links = [
    _SocialItem(
      iconUrl: 'https://img.icons8.com/color/96/github--v1.png',
      url: AppStrings.githubUrl,
      tip: 'GitHub',
      fallback: Icons.code_rounded,
      color: Color(0xFF6E5494),
    ),
    _SocialItem(
      iconUrl: 'https://img.icons8.com/ios-filled/96/1dbf73/fiverr.png',
      url: AppStrings.fiverrUrl,
      tip: 'Fiverr',
      fallback: Icons.work_rounded,
      color: Color(0xFF1DBF73),
    ),
    _SocialItem(
      iconUrl: 'https://img.icons8.com/color/96/linkedin.png',
      url: AppStrings.linkedinUrl,
      tip: 'LinkedIn',
      fallback: Icons.business_center_rounded,
      color: Color(0xFF0A66C2),
    ),
    _SocialItem(
      iconUrl: 'https://img.icons8.com/color/96/gmail-new.png',
      url: 'mailto:${AppStrings.email}', // Uses the email from AppStrings
      tip: 'Email',
      fallback: Icons.email_rounded,
      color: Color(0xFFEA4335),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _links
          .map((item) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10), // simplified padding
        child: _SocialIcon(item: item),
      ))
          .toList(),
    );
  }
}

class _SocialItem {
  final String iconUrl;
  final String url;
  final String tip;
  final IconData fallback;
  final Color color;

  const _SocialItem({
    required this.iconUrl,
    required this.url,
    required this.tip,
    required this.fallback,
    required this.color,
  });
}

class _SocialIcon extends StatefulWidget {
  final _SocialItem item;
  const _SocialIcon({required this.item});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  void _setHover(bool val) {
    if (_hovered != val && mounted) setState(() => _hovered = val);
  }

  Future<void> _openLink() async {
    final uri = Uri.parse(widget.item.url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.item.tip,
      child: MouseRegion(
        onEnter: (_) => _setHover(true),
        onExit: (_) => _setHover(false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _openLink,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150), // Sped up slightly for snappier feel
            width: 42,
            height: 42,
            transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hovered
                    ? widget.item.color.withOpacity(0.45)
                    : AppColors.border,
              ),
              color: _hovered
                  ? widget.item.color.withOpacity(0.08)
                  : AppColors.surface,
              boxShadow: _hovered
                  ? [
                BoxShadow(
                  color: widget.item.color.withOpacity(0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ]
                  : [],
            ),
            child: Center(
              child: Image.network(
                widget.item.iconUrl,
                width: 18,
                height: 18,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  widget.item.fallback,
                  size: 18,
                  color: _hovered
                      ? widget.item.color
                      : AppColors.textMuted.withOpacity(0.8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}