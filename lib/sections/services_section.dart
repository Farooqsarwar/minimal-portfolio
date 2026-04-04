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

    return Container(
      width: double.infinity,
      color: AppColors.bgPrimary,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 60,
        vertical: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            label: 'What I Do',
            title: 'Services I Provide',
          ),
          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxis,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isMobile ? 1.4 : 1.2,
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

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.model.accentColor;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? Colors.white.withOpacity(0.12)
                : AppColors.border,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  )
                ]
              : [],
        ),
        child: Stack(
          children: [
            // Top accent bar
            if (_hovered)
              Positioned(
                top: -28, left: 0, right: 0,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, c, Colors.transparent],
                    ),
                  ),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.model.icon,
                    style: const TextStyle(fontSize: 36)),
                const SizedBox(height: 16),
                Text(widget.model.title,
                    style: GoogleFonts.syne(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(widget.model.description,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.65,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w300,
                      )),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: widget.model.tags
                      .map((t) => GlowBadge(text: t, color: c))
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
