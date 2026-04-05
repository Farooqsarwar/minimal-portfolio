import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../models/portfolio_data.dart';
import '../widgets/common_widgets.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final px = isMobile ? 24.0 : 60.0;

    return Container(
      width: double.infinity,
      color: AppColors.bgPrimary,
      padding: EdgeInsets.symmetric(horizontal: px, vertical: 100),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header row with overall rating
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Expanded(child: SectionHeader(label: 'Client Reviews', title: 'What Clients Say')),
          if (!isMobile) _OverallRating(),
        ]),
        if (isMobile) ...[_OverallRating(), const SizedBox(height: 32)],

        // Scrollable review cards in two rows
        if (isMobile)
          Column(children: reviews.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _ReviewCard(model: r),
          )).toList())
        else
          _ReviewsGrid(),
      ]),
    );
  }
}

class _OverallRating extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    decoration: BoxDecoration(
      color: AppColors.bgSecondary,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(children: [
      Text('5.0', style: GoogleFonts.syne(fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
      const Text('★★★★★', style: TextStyle(color: AppColors.accentAmber, fontSize: 16, letterSpacing: 3)),
      const SizedBox(height: 4),
      const Text('Overall Rating', style: TextStyle(fontSize: 11, color: AppColors.textMuted, letterSpacing: 1)),
    ]),
  );
}

class _ReviewsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 2 rows × 3 columns
    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: reviews.take(3).map((r) => Expanded(
            child: Padding(padding: const EdgeInsets.only(right: 16), child: _ReviewCard(model: r)),
          )).toList()),
      const SizedBox(height: 16),
      Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...reviews.skip(3).map((r) => Expanded(
                child: Padding(padding: const EdgeInsets.only(right: 16), child: _ReviewCard(model: r)))),
            // Empty filler if less than 3 in second row
            if (reviews.length % 3 != 0)
              ...List.generate(3 - (reviews.length % 3), (_) => const Expanded(child: SizedBox())),
          ]),
    ]);
  }
}

class _ReviewCard extends StatefulWidget {
  final ReviewModel model;
  const _ReviewCard({required this.model});
  @override State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _hovered ? Colors.white.withOpacity(0.08) : AppColors.border),
          boxShadow: _hovered ? [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30)] : [],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Top: stars
          const Text('★★★★★', style: TextStyle(color: AppColors.accentAmber, fontSize: 14, letterSpacing: 1.5)),
          const SizedBox(height: 14),

          // Review text
          Text(widget.model.review,
              style: const TextStyle(fontSize: 13, height: 1.75, color: AppColors.textMuted,
                  fontWeight: FontWeight.w300, fontStyle: FontStyle.italic)),
          const SizedBox(height: 24), // Increased slightly to replace the removed row's spacing

          // Author
          Row(children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: widget.model.avatarGradient),
              ),
              child: Center(child: Text(widget.model.initials,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white))),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.model.name,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text('${widget.model.countryFlag} ${widget.model.country}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ]),
          ]),
        ]),
      ),
    );
  }
}