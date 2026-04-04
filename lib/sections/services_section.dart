import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/portfolio_data.dart';
import '../widgets/common_widgets.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;
    final isTablet = w < 1100;
    final crossAxis = isMobile ? 1 : (isTablet ? 2 : 3);
    final px = isMobile ? 24.0 : 60.0;

    return Container(
      width: double.infinity,
      color: AppColors.bgPrimary,
      padding: EdgeInsets.symmetric(horizontal: px, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(label: 'What I Do', title: 'Services I Provide'),
          // Use ListView-style column for 1-col, grid for multi-col
          if (crossAxis == 1)
            Column(
              children: services.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ServiceCard(model: s),
              )).toList(),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxis,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                // Dynamic aspect ratio based on column count
                childAspectRatio: crossAxis == 3 ? 0.85 : 0.9,
              ),
              itemCount: services.length,
              itemBuilder: (_, i) => _ServiceCard(model: services[i]),
            ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final ServiceModel model;
  const _ServiceCard({required this.model});
  @override State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.model.accentColor;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? Colors.white.withOpacity(0.12) : AppColors.border,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 40, offset: const Offset(0, 20))]
              : [],
        ),
        // Use intrinsic height - no Expanded inside unbounded Column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              Text(widget.model.icon, style: const TextStyle(fontSize: 32)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: c.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: c.withOpacity(0.2)),
                ),
                child: Text(widget.model.startingFrom,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: c)),
              ),
            ]),
            const SizedBox(height: 14),
            Text(widget.model.title,
              style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text(widget.model.description,
              style: const TextStyle(fontSize: 13, height: 1.65, color: AppColors.textMuted, fontWeight: FontWeight.w300),
              // No Expanded — let text flow naturally
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8, runSpacing: 6,
              children: widget.model.tags.map((t) => GlowBadge(text: t, color: c)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
