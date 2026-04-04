import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/portfolio_data.dart';
import '../widgets/common_widgets.dart';

class FiverrSection extends StatelessWidget {
  const FiverrSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final px = isMobile ? 24.0 : 60.0;

    return Container(
      width: double.infinity,
      color: AppColors.bgSecondary,
      child: Stack(children: [
        // bg radial glow
        Positioned.fill(child: Center(
          child: Container(width: 800, height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(400),
              gradient: RadialGradient(colors: [AppColors.fiverr.withOpacity(0.05), Colors.transparent]),
            )),
        )),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: px, vertical: 100),
          child: Center(child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(children: [
              // Title
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
                    TextSpan(text: 'Fiverr', style: TextStyle(color: AppColors.fiverr)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(AppStrings.fiverrSectionBody,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300,
                  height: 1.85, color: AppColors.textMuted)),
              const SizedBox(height: 40),

              // Gig cards
              isMobile
                ? Column(children: fiverrGigs.map((g) => Padding(
                    padding: const EdgeInsets.only(bottom: 14), child: _GigCard(gig: g))).toList())
                : Row(children: fiverrGigs.map((g) => Expanded(
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _GigCard(gig: g)))).toList()),
              const SizedBox(height: 40),
              // CTA
              PrimaryButton(
                label: 'View All Gigs on Fiverr →',
                bgColor: AppColors.fiverr,
                textColor: Colors.white,
                glowColor: AppColors.fiverr,
                onTap: () => launchUrl(Uri.parse(AppStrings.fiverrGigUrl),
                  mode: LaunchMode.externalApplication),
              ),
            ]),
          )),
        ),
      ]),
    );
  }
}

class _FiverrProfileBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: AppColors.fiverr.withOpacity(0.07),
      border: Border.all(color: AppColors.fiverr.withOpacity(0.25)),
    ),
    child: Wrap(
      spacing: 10, runSpacing: 6,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 32, height: 32,
            decoration: const BoxDecoration(color: AppColors.fiverr, shape: BoxShape.circle),
            child: const Center(child: Text('f', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white))),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            const Text('farooqsarwar227',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.fiverr)),
            Wrap(spacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
              const Text('★★★★★', style: TextStyle(color: AppColors.accentAmber, fontSize: 11, letterSpacing: 1)),
              const Text(AppStrings.fiverrRating,
                style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
            ]),
          ]),
        ]),
        Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppColors.fiverr, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          const Text('Online', style: TextStyle(fontSize: 11, color: AppColors.fiverr, fontWeight: FontWeight.w600)),
        ]),
      ],
    ),
  );
}

class _GigCard extends StatefulWidget {
  final GigModel gig;
  const _GigCard({required this.gig});
  @override State<_GigCard> createState() => _GigCardState();
}
class _GigCardState extends State<_GigCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit:  (_) => setState(() => _hovered = false),
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () => launchUrl(Uri.parse(AppStrings.fiverrGigUrl), mode: LaunchMode.externalApplication),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(22),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.bgTertiary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _hovered
            ? AppColors.fiverr.withOpacity(0.45)
            : AppColors.fiverr.withOpacity(0.12)),
          boxShadow: _hovered ? [BoxShadow(color: AppColors.fiverr.withOpacity(0.1), blurRadius: 30)] : [],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.gig.icon, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 12),
          Text(widget.gig.title,
            style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(widget.gig.description,
            style: const TextStyle(fontSize: 12, height: 1.6, color: AppColors.textMuted, fontWeight: FontWeight.w300)),
          const SizedBox(height: 14),
          Row(children: [
            Text(widget.gig.price,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.fiverr)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.fiverr.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('ORDER NOW',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.fiverr, letterSpacing: 1)),
            ),
          ]),
        ]),
      ),
    ),
  );
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = [
      {'value': '5.0', 'label': 'Avg Rating', 'icon': '⭐'},
      {'value': '2',   'label': 'Reviews',     'icon': '💬'},
      {'value': '1hr', 'label': 'Response',    'icon': '⚡'},
      {'value': '100%','label': 'Completion',  'icon': '✅'},
    ];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgTertiary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        spacing: 20, runSpacing: 16,
        alignment: WrapAlignment.spaceAround,
        children: stats.map((s) => Column(children: [
          Text(s['icon']!, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(s['value']!, style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          Text(s['label']!, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, letterSpacing: 0.5)),
        ])).toList(),
      ),
    );
  }
}
