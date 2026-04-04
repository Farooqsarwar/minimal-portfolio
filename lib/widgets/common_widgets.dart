import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

// ─── Section Label + Title ────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String label;
  final String title;
  final String? accentWord;

  const SectionHeader({
    super.key,
    required this.label,
    required this.title,
    this.accentWord,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Row(
          children: [
            Container(width: 32, height: 1, color: AppColors.accent),
            const SizedBox(width: 12),
            Text(label.toUpperCase(), style: AppTextStyles.sectionLabel),
          ],
        ),
        const SizedBox(height: 16),
        // Title
        RichText(
          text: TextSpan(
            style: isMobile
                ? AppTextStyles.sectionTitleMobile
                : AppTextStyles.sectionTitle,
            children: _buildTitleSpans(title, accentWord),
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  List<TextSpan> _buildTitleSpans(String title, String? accentWord) {
    if (accentWord == null) return [TextSpan(text: title)];
    final idx = title.indexOf(accentWord);
    if (idx == -1) return [TextSpan(text: title)];
    return [
      TextSpan(text: title.substring(0, idx)),
      TextSpan(
        text: accentWord,
        style: const TextStyle(color: AppColors.accent),
      ),
      TextSpan(text: title.substring(idx + accentWord.length)),
    ];
  }
}

// ─── Primary Button ───────────────────────────────────────
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color bgColor;
  final Color textColor;
  final Color? glowColor;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.trailing,
    this.bgColor = AppColors.accent,
    this.textColor = AppColors.bgPrimary,
    this.glowColor,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final glow = widget.glowColor ?? widget.bgColor;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(100),
            boxShadow: _hovered
                ? [BoxShadow(color: glow.withOpacity(0.4), blurRadius: 32, spreadRadius: 0)]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.label,
                  style: AppTextStyles.button.copyWith(color: widget.textColor)),
              if (widget.trailing != null) ...[
                const SizedBox(width: 10),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Ghost Button ─────────────────────────────────────────
class GhostButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const GhostButton({super.key, required this.label, required this.onTap});

  @override
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: _hovered ? AppColors.accent : AppColors.border,
              width: 1,
            ),
          ),
          child: Text(
            widget.label,
            style: AppTextStyles.button.copyWith(
              color: _hovered ? AppColors.accent : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Skill Bar ────────────────────────────────────────────
class SkillBar extends StatefulWidget {
  final String name;
  final double percentage;

  const SkillBar({super.key, required this.name, required this.percentage});

  @override
  State<SkillBar> createState() => _SkillBarState();
}

class _SkillBarState extends State<SkillBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pct = (widget.percentage * 100).toInt();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  )),
              Text('$pct%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  )),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.bgTertiary,
              borderRadius: BorderRadius.circular(100),
            ),
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _anim.value * widget.percentage,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: const LinearGradient(
                      colors: [AppColors.accentPurple, AppColors.accent],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Glowing Badge ────────────────────────────────────────
class GlowBadge extends StatelessWidget {
  final String text;
  final Color color;

  const GlowBadge({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ─── Skill Tag ────────────────────────────────────────────
class SkillTagChip extends StatefulWidget {
  final String label;

  const SkillTagChip({super.key, required this.label});

  @override
  State<SkillTagChip> createState() => _SkillTagChipState();
}

class _SkillTagChipState extends State<SkillTagChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: _hovered
                ? AppColors.accent
                : AppColors.border,
          ),
          color: _hovered
              ? AppColors.accent.withOpacity(0.05)
              : AppColors.surface,
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _hovered ? AppColors.accent : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

// ─── Hover Card ───────────────────────────────────────────
class HoverCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? borderColor;

  const HoverCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
    this.borderColor,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: widget.padding,
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? (widget.borderColor ?? AppColors.border.withOpacity(2))
                : AppColors.border,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  )
                ]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}

// ─── Animated Stat ────────────────────────────────────────
class StatItem extends StatelessWidget {
  final String value;
  final String label;

  const StatItem({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTextStyles.statNumber,
            children: [
              TextSpan(
                text: value.replaceAll(RegExp(r'[+★]'), ''),
              ),
              TextSpan(
                text: value.contains('+')
                    ? '+'
                    : value.contains('★')
                        ? '★'
                        : '',
                style: const TextStyle(color: AppColors.accent),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(label.toUpperCase(), style: AppTextStyles.statLabel),
      ],
    );
  }
}

// ─── Contact Link Row ─────────────────────────────────────
class ContactLinkRow extends StatefulWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const ContactLinkRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<ContactLinkRow> createState() => _ContactLinkRowState();
}

class _ContactLinkRowState extends State<ContactLinkRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _hovered ? AppColors.accent : AppColors.border,
                ),
                color: AppColors.surface,
              ),
              child: Center(child: Text(widget.icon, style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 14),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                color: _hovered ? AppColors.accent : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
