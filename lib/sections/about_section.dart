import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/portfolio_data.dart';
import '../widgets/common_widgets.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final px = isMobile ? 24.0 : 60.0;

    return Container(
      width: double.infinity,
      color: AppColors.bgSecondary,
      padding: EdgeInsets.symmetric(horizontal: px, vertical: 100),
      child: isMobile
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildText(context, true)])
        : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(child: _buildVisual()),
            const SizedBox(width: 80),
            Expanded(child: _buildText(context, false)),
          ]),
    );
  }

  Widget _buildVisual() {
    return Center(child: SizedBox(width: 340, height: 420, child: Stack(clipBehavior: Clip.none, children: [
      // Gradient border card
      Positioned.fill(child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [AppColors.accent, AppColors.accentPurple, AppColors.accentAmber],
          ),
        ),
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(color: AppColors.bgTertiary, borderRadius: BorderRadius.circular(23)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // Top row
              Row(children: [
                Expanded(child: _TechBadge(icon: '📱', name: 'Flutter', sub: 'Primary Framework')),
                const SizedBox(width: 10),
                Expanded(child: _TechBadge(icon: '⚛️', name: 'React Native', sub: 'Cross Platform')),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _TechBadge(icon: '🔥', name: 'Firebase', sub: 'Backend')),
                const SizedBox(width: 10),
                Expanded(child: _TechBadge(icon: '🤖', name: 'AI/ML', sub: 'Integration')),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _TechBadge(icon: '🏪', name: 'Play Store', sub: '5 Apps Published')),
                const SizedBox(width: 10),
                Expanded(child: _TechBadge(icon: '🌐', name: 'Flutter Web', sub: 'PWA Ready')),
              ]),
            ]),
          ),
        ),
      )),
      // Floating cards
      Positioned(bottom: -20, left: -36,
        child: _FloatingCard(icon: '', title: '10+ Projects', subtitle: 'Delivered')),
    ])));
  }

  Widget _buildText(BuildContext context, bool isMobile) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 32, height: 1, color: AppColors.accent),
        const SizedBox(width: 12),
        const Text('ABOUT ME', style: AppTextStyles_sectionLabel),
      ]),
      const SizedBox(height: 16),
      RichText(
        text: TextSpan(
          style: isMobile ? GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -1, color: AppColors.textPrimary)
                          : GoogleFonts.syne(fontSize: 38, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -1.5, color: AppColors.textPrimary),
          children: const [
            TextSpan(text: 'Flutter & React Native\nDeveloper from '),
            TextSpan(text: 'Pakistan', style: TextStyle(color: AppColors.accent)),
          ],
        ),
      ),
      const SizedBox(height: 24),
      Text(AppStrings.aboutBody1, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300, height: 1.85, color: AppColors.textMuted)),
      const SizedBox(height: 14),
      Text(AppStrings.aboutBody2, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300, height: 1.85, color: AppColors.textMuted)),
      const SizedBox(height: 14),
      Text(AppStrings.aboutBody3, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300, height: 1.85, color: AppColors.textMuted)),
      const SizedBox(height: 28),
      // Language row
      Wrap(spacing: 10, runSpacing: 8, children: [
        _LangChip(flag: '🇵🇰', lang: 'Urdu'),
        _LangChip(flag: '🇬🇧', lang: 'English'),
        _LangChip(flag: '🏔️',  lang: 'Pashto'),
      ]),
      const SizedBox(height: 24),
      Wrap(spacing: 10, runSpacing: 10,
        children: skillTags.map((t) => SkillTagChip(label: t)).toList()),
    ]);
  }
}

const AppTextStyles_sectionLabel = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2.5, color: AppColors.accent);

class _LangChip extends StatelessWidget {
  final String flag, lang;
  const _LangChip({required this.flag, required this.lang});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.border),
      color: AppColors.surface,
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(flag, style: const TextStyle(fontSize: 14)),
      const SizedBox(width: 6),
      Text(lang, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _TechBadge extends StatelessWidget {
  final String icon, name, sub;
  const _TechBadge({required this.icon, required this.name, required this.sub});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(children: [
      Text(icon, style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 8),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        Text(sub,  style: const TextStyle(fontSize: 9,  fontWeight: FontWeight.w300, color: AppColors.textMuted)),
      ])),
    ]),
  );
}

class _FloatingCard extends StatefulWidget {
  final String icon, title, subtitle;
  const _FloatingCard({required this.icon, required this.title, required this.subtitle});
  @override State<_FloatingCard> createState() => _FloatingCardState();
}
class _FloatingCardState extends State<_FloatingCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, child) => Transform.translate(offset: Offset(0, -6 * _ctrl.value), child: child),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgTertiary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(widget.icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(widget.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text(widget.subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ]),
      ]),
    ),
  );
}
