import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../models/portfolio_data.dart';
import '../widgets/common_widgets.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final px = isMobile ? 20.0 : 60.0;

    return Container(
      width: double.infinity,
      color: AppColors.bgPrimary,
      padding: EdgeInsets.symmetric(horizontal: px, vertical: 100),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Expanded(
            child: SectionHeader(
                label: 'Client Reviews', title: 'What Clients Say'),
          ),
          if (!isMobile) const _OverallRating(),
        ]),
        if (isMobile) ...[
          const _OverallRating(),
          const SizedBox(height: 32),
        ],

        if (isMobile)
          Column(
            children: reviews
                .map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: RepaintBoundary(child: _ReviewCard(model: r)),
            ))
                .toList(),
          )
        else
          const _ReviewsGrid(),
      ]),
    );
  }
}

// ── Overall Rating ──────────────────────────────────────────

class _OverallRating extends StatelessWidget {
  const _OverallRating();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('5.0',
            style: GoogleFonts.syne(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: List.generate(
              5,
                  (_) => const Icon(Icons.star_rounded,
                  size: 16, color: AppColors.accentAmber),
            ),
          ),
          const SizedBox(height: 4),
          Text('Overall Rating',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5)),
        ]),
      ]),
    );
  }
}

// ── Reviews Grid ────────────────────────────────────────────

class _ReviewsGrid extends StatelessWidget {
  const _ReviewsGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cardW = (constraints.maxWidth - 32) / 3;
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: reviews
            .map((r) => SizedBox(
          width: cardW,
          child: RepaintBoundary(child: _ReviewCard(model: r)),
        ))
            .toList(),
      );
    });
  }
}

// ── Review Card ─────────────────────────────────────────────

class _ReviewCard extends StatefulWidget {
  final ReviewModel model;
  const _ReviewCard({required this.model});
  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.model;

    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(24),
        transform: Matrix4.translationValues(0, _h ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: _h ? Colors.white.withOpacity(0.1) : AppColors.border),
          boxShadow: _h
              ? [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 10)),
          ]
              : [],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header: stars only
          Row(
            children: List.generate(
              5,
                  (_) => const Icon(Icons.star_rounded,
                  size: 14, color: AppColors.accentAmber),
            ),
          ),
          const SizedBox(height: 16),

          Icon(Icons.format_quote_rounded,
              size: 24, color: AppColors.accent.withOpacity(0.3)),
          const SizedBox(height: 8),

          Text(m.review,
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.75,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              )),
          const SizedBox(height: 20),

          Container(height: 1, color: AppColors.border.withOpacity(0.4)),
          const SizedBox(height: 16),

          // Author row
          Row(children: [
            Stack(clipBehavior: Clip.none, children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: m.avatarGradient,
                  ),
                ),
                child: Center(
                  child: Text(m.initials,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ),
              Positioned(
                bottom: -2,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.bgSecondary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: _countryFlag(m.country),
                      width: 14,
                      height: 14,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Text(m.countryFlag,
                          style: const TextStyle(fontSize: 10)),
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(m.name,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                      if (m.isVerified) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.verified_rounded,
                            size: 14,
                            color: AppColors.accent.withOpacity(0.8)),
                      ],
                    ]),
                    const SizedBox(height: 2),
                    Text(m.country,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.textMuted)),
                  ]),
            ),
          ]),
        ]),
      ),
    );
  }
}

// ── Helpers ─────────────────────────────────────────────────

String _countryFlag(String country) {
  switch (country) {
    case 'United States':
      return 'https://flagcdn.com/w80/us.png';
    case 'Australia':
      return 'https://flagcdn.com/w80/au.png';
    case 'Pakistan':
      return 'https://flagcdn.com/w80/pk.png';
    case 'United Kingdom':
      return 'https://flagcdn.com/w80/gb.png';
    case 'Canada':
      return 'https://flagcdn.com/w80/ca.png';
    default:
      return 'https://flagcdn.com/w80/un.png';
  }
}