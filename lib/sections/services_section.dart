import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/portfolio_data.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w < 768 ? 1 : (w < 1100 ? 2 : 3);
    final px = w < 768 ? 24.0 : 60.0;
    const gap = 20.0;

    return Container(
      width: double.infinity,
      color: AppColors.bgPrimary,
      padding: EdgeInsets.symmetric(horizontal: px, vertical: 100),
      child: LayoutBuilder(
        builder: (_, c) {
          final itemWidth =
          cols == 1 ? c.maxWidth : (c.maxWidth - gap * (cols - 1)) / cols;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),
              const SizedBox(height: 34),
              Wrap(
                spacing: gap,
                runSpacing: gap,
                children: services
                    .map((s) => SizedBox(
                  width: itemWidth,
                  // FIX: RepaintBoundary on every card — hover state on one
                  // card no longer repaints siblings
                  child: RepaintBoundary(
                    child: _ServiceCard(model: s),
                  ),
                ))
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 28,
            height: 1.5,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.6),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(width: 12),
          Text('WHAT I DO', style: AppTextStyles.sectionLabel),
        ]),
        const SizedBox(height: 18),
        Text('Services I Provide', style: AppTextStyles.sectionTitle),
      ],
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
    final title = widget.model.title;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hovered ? c.withOpacity(0.35) : AppColors.border,
          ),
          boxShadow: _hovered
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 28,
              offset: const Offset(0, 14),
              spreadRadius: -6,
            ),
          ]
              : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // FIX: CachedNetworkImage — image cached after first load
                _CachedServiceImage(_serviceImage(title), height: 170),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          AppColors.bgSecondary.withOpacity(0.92),
                        ],
                        stops: const [0, .55, 1],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: _serviceLogo(title),
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                        errorWidget: (_, __, ___) => Icon(
                          _fallbackIcon(title),
                          size: 20,
                          color: c.withOpacity(0.85),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: c.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: c.withOpacity(0.22)),
                    ),
                    child: Text(
                      'Service',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 8),
                  Text(widget.model.description,
                      style: AppTextStyles.bodySmall),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.model.tags
                        .map((t) => _Tag(text: t, color: c))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary.withOpacity(0.9),
          height: 1,
        ),
      ),
    );
  }
}

// FIX: Dedicated cached image widget replaces _NetImage (which used Image.network)
class _CachedServiceImage extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;

  const _CachedServiceImage(this.url, {this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width ?? double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        height: height,
        width: width,
        color: AppColors.bgSecondary,
        child: Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: AppColors.accent.withOpacity(0.4),
            ),
          ),
        ),
      ),
      errorWidget: (_, __, ___) => Container(
        height: height,
        width: width,
        color: AppColors.bgSecondary,
        child: const Center(
          child: Icon(Icons.image_outlined,
              color: AppColors.textMuted, size: 28),
        ),
      ),
    );
  }
}

String _serviceImage(String title) {
  final t = title.toLowerCase();
  if (t.contains('design') || t.contains('ui') || t.contains('ux')) {
    return 'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?w=1200&q=80';
  }
  if (t.contains('web') || t.contains('website') || t.contains('frontend')) {
    return 'https://images.unsplash.com/photo-1467232004584-a241de8bcf5d?w=1200&q=80';
  }
  if (t.contains('backend') || t.contains('api') || t.contains('firebase')) {
    return 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=1200&q=80';
  }
  if (t.contains('ai') || t.contains('ml')) {
    return 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=1200&q=80';
  }
  return 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=1200&q=80';
}

String _serviceLogo(String title) {
  final t = title.toLowerCase();
  if (t.contains('design') || t.contains('ui') || t.contains('ux')) {
    return 'https://img.icons8.com/color/96/figma--v1.png';
  }
  if (t.contains('web') || t.contains('website') || t.contains('frontend')) {
    return 'https://img.icons8.com/color/96/domain.png';
  }
  if (t.contains('backend') || t.contains('api') || t.contains('firebase')) {
    return 'https://img.icons8.com/color/96/firebase.png';
  }
  if (t.contains('ai') || t.contains('ml')) {
    return 'https://img.icons8.com/color/96/python--v1.png';
  }
  if (t.contains('react')) {
    return 'https://img.icons8.com/color/96/react-native.png';
  }
  return 'https://img.icons8.com/color/96/flutter.png';
}

IconData _fallbackIcon(String title) {
  final t = title.toLowerCase();
  if (t.contains('design') || t.contains('ui') || t.contains('ux')) {
    return Icons.palette_outlined;
  }
  if (t.contains('web') || t.contains('website')) {
    return Icons.language_rounded;
  }
  if (t.contains('backend') || t.contains('api') || t.contains('firebase')) {
    return Icons.storage_rounded;
  }
  if (t.contains('ai') || t.contains('ml')) {
    return Icons.psychology_rounded;
  }
  return Icons.phone_android_rounded;
}