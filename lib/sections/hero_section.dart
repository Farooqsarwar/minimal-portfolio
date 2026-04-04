import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/common_widgets.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onViewWork;
  final VoidCallback onContact;
  const HeroSection({super.key, required this.onViewWork, required this.onContact});
  @override State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with TickerProviderStateMixin {
  late final List<AnimationController> _ctrls;
  late final List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(5, (i) => AnimationController(vsync: this, duration: const Duration(milliseconds: 700)));
    _anims = _ctrls.map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut)).toList();
    for (int i = 0; i < _ctrls.length; i++) {
      Future.delayed(Duration(milliseconds: 180 + i * 140), () { if (mounted) _ctrls[i].forward(); });
    }
  }

  @override
  void dispose() { for (final c in _ctrls) c.dispose(); super.dispose(); }

  Widget _fade(int i, Widget child) => FadeTransition(
    opacity: _anims[i],
    child: SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(_anims[i]),
      child: child,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;
    final px = isMobile ? 24.0 : 60.0;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.92),
      padding: EdgeInsets.fromLTRB(px, isMobile ? 100 : 140, px, isMobile ? 60 : 80),
      child: Stack(children: [
        // Glow blobs
        Positioned(top: -100, right: -100,
          child: _GlowBlob(color: AppColors.accent.withOpacity(0.055), size: 500)),
        Positioned(bottom: -80, left: -80,
          child: _GlowBlob(color: AppColors.accentPurple.withOpacity(0.065), size: 450)),
        // Content
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Badge row
          _fade(0, Wrap(spacing: 10, runSpacing: 8, children: [
            _AvailabilityBadge(),
            _ResponseBadge(),
          ])),
          const SizedBox(height: 32),

          // Title
          _fade(1, RichText(
            text: TextSpan(
              style: GoogleFonts.syne(
                fontSize: isMobile ? 38 : 68,
                fontWeight: FontWeight.w800,
                height: 1.04,
                letterSpacing: isMobile ? -1.5 : -2.5,
                color: AppColors.textPrimary,
              ),
              children: [
                TextSpan(
                  text: '${AppStrings.tagline}\n',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w300,
                    fontSize: isMobile ? 22 : 34,
                  ),
                ),
                const TextSpan(text: 'Farooq Sarwar'),
                const TextSpan(text: '.', style: TextStyle(color: AppColors.accent)),
                TextSpan(
                  text: '\n${AppStrings.role}',
                  style: GoogleFonts.syne(
                    fontSize: isMobile ? 18 : 28,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 28),

          // Sub
          _fade(2, ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Text(AppStrings.heroSub,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, height: 1.85, color: AppColors.textMuted)),
          )),

          const SizedBox(height: 40),

          // Buttons
          _fade(3, Wrap(spacing: 14, runSpacing: 12, children: [
            PrimaryButton(
              label: 'View My Work',
              onTap: widget.onViewWork,
              trailing: const Icon(Icons.arrow_forward, size: 16, color: AppColors.bgPrimary),
            ),
            PrimaryButton(
              label: 'Hire on Fiverr',
              bgColor: AppColors.fiverr,
              textColor: Colors.white,
              glowColor: AppColors.fiverr,
              onTap: () => launchUrl(Uri.parse(AppStrings.fiverrGigUrl), mode: LaunchMode.externalApplication),
            ),
            GhostButton(label: 'Get in Touch', onTap: widget.onContact),
          ])),
          const SizedBox(height: 64),

          // Stats
          _fade(4, Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(height: 1, color: AppColors.border),
            const SizedBox(height: 36),
            Wrap(spacing: 52, runSpacing: 24, children: const [
              StatItem(value: '3+',   label: 'Years Experience'),
              StatItem(value: '50+',  label: 'Projects Delivered'),
              StatItem(value: '5.0★', label: 'Fiverr Rating'),
              StatItem(value: '1hr',  label: 'Avg. Response'),
            ]),
          ])),
        ]),
      ]),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: AppColors.border),
      color: AppColors.surface,
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      _BlinkDot(),
      const SizedBox(width: 8),
      const Text('AVAILABLE FOR WORK',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.8, color: AppColors.accent)),
    ]),
  );
}

class _ResponseBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: AppColors.fiverr.withOpacity(0.3)),
      color: AppColors.fiverr.withOpacity(0.08),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 7, height: 7,
        decoration: const BoxDecoration(color: AppColors.fiverr, shape: BoxShape.circle)),
      const SizedBox(width: 7),
      const Text('ONLINE ON FIVERR',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppColors.fiverr)),
    ]),
  );
}

class _InfoChip extends StatelessWidget {
  final String icon; final String label;
  const _InfoChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.border),
      color: AppColors.surface,
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(icon, style: const TextStyle(fontSize: 13)),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
    ]),
  );
}

class _BlinkDot extends StatefulWidget {
  @override State<_BlinkDot> createState() => _BlinkDotState();
}
class _BlinkDotState extends State<_BlinkDot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl),
    child: Container(width: 7, height: 7,
      decoration: BoxDecoration(color: AppColors.fiverr, shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: AppColors.fiverr.withOpacity(0.6), blurRadius: 6)])),
  );
}

class _GlowBlob extends StatefulWidget {
  final Color color; final double size;
  const _GlowBlob({required this.color, required this.size});
  @override State<_GlowBlob> createState() => _GlowBlobState();
}
class _GlowBlobState extends State<_GlowBlob> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 7))..repeat(reverse: true);
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) => Opacity(
      opacity: 0.6 + _ctrl.value * 0.4,
      child: Container(width: widget.size, height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [widget.color, Colors.transparent]),
        )),
    ),
  );
}
