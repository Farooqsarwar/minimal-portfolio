import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/portfolio_data.dart';
import '../widgets/common_widgets.dart';

class FiverrSection extends StatelessWidget {
  const FiverrSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final px = isMobile ? 20.0 : 60.0;

    return Container(
      width: double.infinity,
      color: AppColors.bgSecondary,
      child: Stack(children: [
        Positioned.fill(
          child: Center(
            child: Container(
              width: 800,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(400),
                gradient: RadialGradient(colors: [
                  AppColors.fiverr.withOpacity(0.05),
                  Colors.transparent
                ]),
              ),
            ),
          ),
        ),

        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: px, vertical: 100),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.syne(
                      fontSize: isMobile ? 30 : 52,
                      fontWeight: FontWeight.w800,
                      height: 1.08,
                      letterSpacing: isMobile ? -1 : -2,
                      color: AppColors.textPrimary,
                    ),
                    children: const [
                      TextSpan(text: 'Hire Me on '),
                      TextSpan(
                          text: 'Fiverr',
                          style: TextStyle(color: AppColors.fiverr)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(AppStrings.fiverrSectionBody,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        height: 1.85,
                        color: AppColors.textMuted)),
                const SizedBox(height: 32),

                const _FiverrProfileBadge(),
                const SizedBox(height: 36),

                isMobile
                    ? Column(
                  children: fiverrGigs
                      .map((g) => Padding(
                    padding:
                    const EdgeInsets.only(bottom: 14),
                    child: RepaintBoundary(
                      child: _GigCard(gig: g),
                    ),
                  ))
                      .toList(),
                )
                    : Row(
                  children: fiverrGigs
                      .map((g) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8),
                      // FIX: RepaintBoundary on each gig card
                      child: RepaintBoundary(
                        child: _GigCard(gig: g),
                      ),
                    ),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 40),

                PrimaryButton(
                  label: 'View All Gigs on Fiverr →',
                  bgColor: AppColors.fiverr,
                  textColor: Colors.white,
                  glowColor: AppColors.fiverr,
                  onTap: () => launchUrl(
                      Uri.parse(AppStrings.fiverrGigUrl),
                      mode: LaunchMode.externalApplication),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

// ── Profile Badge ───────────────────────────────────────────

class _FiverrProfileBadge extends StatelessWidget {
  const _FiverrProfileBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.fiverr.withOpacity(0.07),
        border:
        Border.all(color: AppColors.fiverr.withOpacity(0.25)),
      ),
      child: Wrap(
        spacing: 14,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.fiverr,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl:
                  'https://img.icons8.com/ios-filled/96/ffffff/fiverr.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  errorWidget: (_, __, ___) => const Text('f',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('farooqsarwar227',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.fiverr)),
                const SizedBox(height: 2),
                Row(children: [
                  ...List.generate(
                    5,
                        (_) => Icon(Icons.star_rounded,
                        size: 13, color: AppColors.accentAmber),
                  ),
                  const SizedBox(width: 6),
                  Text(AppStrings.fiverrRating,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.textMuted)),
                ]),
              ],
            ),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.fiverr.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: AppColors.fiverr,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.fiverr.withOpacity(0.5),
                        blurRadius: 6),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text('Online',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.fiverr,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── Gig Card ────────────────────────────────────────────────

class _GigCard extends StatefulWidget {
  final GigModel gig;
  const _GigCard({required this.gig});
  @override
  State<_GigCard> createState() => _GigCardState();
}

class _GigCardState extends State<_GigCard> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    final gig = widget.gig;
    final info = _gigInfo(gig.title);

    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(AppStrings.fiverrGigUrl),
            mode: LaunchMode.externalApplication),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(22),
          transform: Matrix4.translationValues(0, _h ? -5 : 0, 0),
          decoration: BoxDecoration(
            color: AppColors.bgTertiary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: _h
                    ? AppColors.fiverr.withOpacity(0.45)
                    : AppColors.fiverr.withOpacity(0.12)),
            boxShadow: _h
                ? [
              BoxShadow(
                  color: AppColors.fiverr.withOpacity(0.1),
                  blurRadius: 30),
            ]
                : [],
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: info.color.withOpacity(0.1)),
                  ),
                  child: Stack(children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        // FIX: CachedNetworkImage for gig thumbnails
                        child: CachedNetworkImage(
                          imageUrl: info.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              gradient: LinearGradient(colors: [
                                info.color.withOpacity(0.15),
                                info.color.withOpacity(0.05)
                              ]),
                            ),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              gradient: LinearGradient(colors: [
                                info.color.withOpacity(0.15),
                                info.color.withOpacity(0.05)
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.bgTertiary.withOpacity(0.6)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: info.logoUrl,
                            width: 18,
                            height: 18,
                            fit: BoxFit.contain,
                            errorWidget: (_, __, ___) => Icon(
                                info.fallback,
                                size: 16,
                                color: info.color.withOpacity(0.7)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.fiverr,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(gig.price,
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),
                Text(gig.title,
                    style: GoogleFonts.syne(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Text(gig.description,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        height: 1.6,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w300)),
                const SizedBox(height: 16),
                Row(children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.schedule_rounded,
                        size: 14,
                        color: AppColors.textMuted.withOpacity(0.6)),
                    const SizedBox(width: 4),
                    Text(info.delivery,
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textMuted)),
                  ]),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _h
                          ? AppColors.fiverr
                          : AppColors.fiverr.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.fiverr
                              .withOpacity(_h ? 1 : 0.3)),
                    ),
                    child: Text('ORDER NOW',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color:
                            _h ? Colors.white : AppColors.fiverr,
                            letterSpacing: 1)),
                  ),
                ]),
              ]),
        ),
      ),
    );
  }
}

// ── Gig Info ────────────────────────────────────────────────

class _GigInfo {
  final String imageUrl, logoUrl, delivery;
  final Color color;
  final IconData fallback;
  const _GigInfo(
      {required this.imageUrl,
        required this.logoUrl,
        required this.delivery,
        required this.color,
        required this.fallback});
}

_GigInfo _gigInfo(String title) {
  final t = title.toLowerCase();

  if (t.contains('cross') || t.contains('mobile')) {
    return const _GigInfo(
      imageUrl:
      'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=600&q=80',
      logoUrl: 'https://img.icons8.com/color/96/flutter.png',
      delivery: '7-14 days',
      color: Color(0xFF54C5F8),
      fallback: Icons.phone_android,
    );
  }
  if (t.contains('ai') || t.contains('powered')) {
    return const _GigInfo(
      imageUrl:
      'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=600&q=80',
      logoUrl: 'https://img.icons8.com/color/96/python--v1.png',
      delivery: '10-21 days',
      color: Color(0xFFAB47BC),
      fallback: Icons.psychology,
    );
  }
  if (t.contains('figma') || t.contains('design')) {
    return const _GigInfo(
      imageUrl:
      'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?w=600&q=80',
      logoUrl: 'https://img.icons8.com/color/96/figma--v1.png',
      delivery: '3-7 days',
      color: Color(0xFFF24E1E),
      fallback: Icons.palette,
    );
  }

  return const _GigInfo(
    imageUrl:
    'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=600&q=80',
    logoUrl: 'https://img.icons8.com/color/96/code.png',
    delivery: '5-10 days',
    color: Color(0xFF059669),
    fallback: Icons.code,
  );
}