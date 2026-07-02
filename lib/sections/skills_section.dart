import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../models/portfolio_data.dart';
import '../widgets/common_widgets.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 900;
    final px = isMobile ? 20.0 : 60.0;

    return Container(
      width: double.infinity,
      color: AppColors.bgSecondary,
      padding: EdgeInsets.symmetric(horizontal: px, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(label: 'Expertise', title: 'Technical Skills'),
          if (isMobile) ...[
            _SkillCards(),
            const SizedBox(height: 48),
            _ToolsGrid(),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _SkillCards()),
                const SizedBox(width: 60),
                Expanded(child: _ToolsGrid()),
              ],
            ),
        ],
      ),
    );
  }
}

// ── Skill Cards ─────────────────────────────────────────────

class _SkillCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WHAT I WORK WITH',
          style: GoogleFonts.spaceMono(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.5,
              color: AppColors.textMuted),
        ),
        const SizedBox(height: 20),
        ...skills.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          // FIX: RepaintBoundary on each card — hover on one doesn't repaint others
          child: RepaintBoundary(child: _SkillCard(skill: s)),
        )),
      ],
    );
  }
}

class _SkillCard extends StatefulWidget {
  final SkillModel skill;
  const _SkillCard({required this.skill});
  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    final info = _skillInfo(widget.skill.name);

    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _h ? info.color.withOpacity(0.06) : AppColors.bgTertiary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _h ? info.color.withOpacity(0.3) : AppColors.border,
          ),
        ),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: info.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              // FIX: CachedNetworkImage for skill icons
              child: CachedNetworkImage(
                imageUrl: info.logoUrl,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorWidget: (_, __, ___) => Icon(
                  info.fallback,
                  size: 22,
                  color: info.color.withOpacity(0.7),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.skill.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    )),
                const SizedBox(height: 3),
                Text(
                  info.description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Tools Grid ──────────────────────────────────────────────

class _ToolsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'TOOLS & TECHNOLOGIES',
          style: GoogleFonts.spaceMono(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.5,
              color: AppColors.textMuted),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: tools
              .map((t) => RepaintBoundary(
            // FIX: RepaintBoundary on each tool card
            child: _ToolCard(
              name: t['name']!,
              logoUrl: _toolLogo(t['name']!),
              color: _toolColor(t['name']!),
            ),
          ))
              .toList(),
        ),
      ],
    );
  }
}

class _ToolCard extends StatefulWidget {
  final String name, logoUrl;
  final Color color;
  const _ToolCard(
      {required this.name, required this.logoUrl, required this.color});
  @override
  State<_ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<_ToolCard> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        padding:
        const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        transform: Matrix4.translationValues(0, _h ? -3 : 0, 0),
        decoration: BoxDecoration(
          color: _h
              ? widget.color.withOpacity(0.08)
              : AppColors.bgTertiary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _h
                ? widget.color.withOpacity(0.35)
                : AppColors.border,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // FIX: CachedNetworkImage for tool icons
            CachedNetworkImage(
              imageUrl: widget.logoUrl,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorWidget: (_, __, ___) => Icon(
                Icons.code,
                size: 28,
                color: widget.color.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.name,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Skill Info Helper ───────────────────────────────────────

class _SkillInfo {
  final String logoUrl, description;
  final Color color;
  final IconData fallback;
  const _SkillInfo(
      {required this.logoUrl,
        required this.description,
        required this.color,
        required this.fallback});
}

_SkillInfo _skillInfo(String name) {
  final n = name.toLowerCase();

  if (n.contains('flutter') || n.contains('dart')) {
    return const _SkillInfo(
      logoUrl: 'https://img.icons8.com/color/96/flutter.png',
      description: 'Primary framework for mobile & web',
      color: Color(0xFF54C5F8),
      fallback: Icons.phone_android,
    );
  }
  if (n.contains('react native')) {
    return const _SkillInfo(
      logoUrl: 'https://img.icons8.com/color/96/react-native.png',
      description: 'Cross-platform mobile development',
      color: Color(0xFF61DAFB),
      fallback: Icons.devices,
    );
  }
  if (n.contains('firebase')) {
    return const _SkillInfo(
      logoUrl: 'https://img.icons8.com/color/96/firebase.png',
      description: 'Auth, Firestore, Functions & more',
      color: Color(0xFFFFCA28),
      fallback: Icons.local_fire_department,
    );
  }
  if (n.contains('state') ||
      n.contains('bloc') ||
      n.contains('getx') ||
      n.contains('riverpod')) {
    return const _SkillInfo(
      logoUrl: 'https://img.icons8.com/color/96/process.png',
      description: 'Bloc, GetX, Riverpod patterns',
      color: Color(0xFFAB47BC),
      fallback: Icons.account_tree,
    );
  }
  if (n.contains('rest') || n.contains('api') || n.contains('graphql')) {
    return const _SkillInfo(
      logoUrl: 'https://img.icons8.com/color/96/api-settings.png',
      description: 'REST, GraphQL & Dio integration',
      color: Color(0xFF059669),
      fallback: Icons.api,
    );
  }
  if (n.contains('ai') || n.contains('ml')) {
    return const _SkillInfo(
      logoUrl: 'https://img.icons8.com/color/96/python--v1.png',
      description: 'TensorFlow Lite & Python APIs',
      color: Color(0xFFEF4444),
      fallback: Icons.psychology,
    );
  }
  if (n.contains('ui') || n.contains('ux') || n.contains('figma')) {
    return const _SkillInfo(
      logoUrl: 'https://img.icons8.com/color/96/figma--v1.png',
      description: 'Figma to pixel-perfect code',
      color: Color(0xFFF24E1E),
      fallback: Icons.palette,
    );
  }
  if (n.contains('ci') ||
      n.contains('cd') ||
      n.contains('git') ||
      n.contains('deploy')) {
    return const _SkillInfo(
      logoUrl: 'https://img.icons8.com/color/96/git.png',
      description: 'Git, CI/CD & store deployment',
      color: Color(0xFFF05032),
      fallback: Icons.rocket_launch,
    );
  }

  return const _SkillInfo(
    logoUrl: 'https://img.icons8.com/color/96/code.png',
    description: 'Development expertise',
    color: Color(0xFF54C5F8),
    fallback: Icons.code,
  );
}

// ── Tool Helpers ────────────────────────────────────────────

String _toolLogo(String name) {
  switch (name) {
    case 'Flutter':
      return 'https://img.icons8.com/color/96/flutter.png';
    case 'React Native':
      return 'https://img.icons8.com/color/96/react-native.png';
    case 'Dart':
      return 'https://img.icons8.com/color/96/dart.png';
    case 'Firebase':
      return 'https://img.icons8.com/color/96/firebase.png';
    case 'SQLite':
      return 'https://img.icons8.com/color/96/sql.png';
    case 'Hive DB':
      return 'https://img.icons8.com/color/96/database.png';
    case 'GitHub':
      return 'https://img.icons8.com/color/96/github.png';
    case 'Figma':
      return 'https://img.icons8.com/color/96/figma--v1.png';
    case 'Cloud Fn':
      return 'https://img.icons8.com/color/96/google-cloud.png';
    case 'TF Lite':
      return 'https://img.icons8.com/color/96/tensorflow.png';
    case 'VS Code':
      return 'https://img.icons8.com/color/96/visual-studio-code-2019.png';
    case 'CI/CD':
      return 'https://img.icons8.com/color/96/deployment.png';
    default:
      return 'https://img.icons8.com/color/96/code.png';
  }
}

Color _toolColor(String name) {
  switch (name) {
    case 'Flutter':
      return const Color(0xFF54C5F8);
    case 'React Native':
      return const Color(0xFF61DAFB);
    case 'Dart':
      return const Color(0xFF0175C2);
    case 'Firebase':
      return const Color(0xFFFFCA28);
    case 'SQLite':
      return const Color(0xFF003B57);
    case 'Hive DB':
      return const Color(0xFFF59E0B);
    case 'GitHub':
      return const Color(0xFF6E5494);
    case 'Figma':
      return const Color(0xFFF24E1E);
    case 'Cloud Fn':
      return const Color(0xFF4285F4);
    case 'TF Lite':
      return const Color(0xFFFF6F00);
    case 'VS Code':
      return const Color(0xFF007ACC);
    case 'CI/CD':
      return const Color(0xFF059669);
    default:
      return const Color(0xFF54C5F8);
  }
}