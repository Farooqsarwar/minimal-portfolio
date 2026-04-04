import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/portfolio_data.dart';
import '../widgets/common_widgets.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final px = isMobile ? 24.0 : 60.0;

    return Container(
      width: double.infinity,
      color: AppColors.bgSecondary,
      padding: EdgeInsets.symmetric(horizontal: px, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(label: 'Expertise', title: 'Technical Skills'),
          if (isMobile)
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _SkillBars(),
              const SizedBox(height: 48),
              _ToolsGrid(),
            ])
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _SkillBars()),
                const SizedBox(width: 60),
                Expanded(child: _ToolsGrid()),
              ],
            ),
        ],
      ),
    );
  }
}

class _SkillBars extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: skills.map((s) => SkillBar(name: s.name, percentage: s.percentage)).toList(),
  );
}

class _ToolsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('TOOLS & TECHNOLOGIES',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                letterSpacing: 2.5, color: AppColors.textMuted)),
        const SizedBox(height: 16),
        // Wrap instead of GridView — prevents overflow in bounded containers
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: tools.map((t) => _ToolCard(icon: t['icon']!, name: t['name']!)).toList(),
        ),
      ],
    );
  }
}

class _ToolCard extends StatefulWidget {
  final String icon, name;
  const _ToolCard({required this.icon, required this.name});
  @override State<_ToolCard> createState() => _ToolCardState();
}
class _ToolCardState extends State<_ToolCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 90,
        height: 80,
        transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.bgTertiary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _hovered ? AppColors.accent : AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(widget.name,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2),
            ),
          ],
        ),
      ),
    );
  }
}