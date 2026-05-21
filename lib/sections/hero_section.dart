import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/common_widgets.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onViewWork;
  final VoidCallback onContact;
  const HeroSection({super.key, required this.onViewWork, required this.onContact});
  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with TickerProviderStateMixin {
  late final List<AnimationController> _ctrls;
  late final List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(
      5,
          (i) => AnimationController(vsync: this, duration: const Duration(milliseconds: 700)),
    );
    _anims = _ctrls
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut))
        .toList();
    for (int i = 0; i < _ctrls.length; i++) {
      Future.delayed(Duration(milliseconds: 180 + i * 140), () {
        if (mounted) _ctrls[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    super.dispose();
  }

  Widget _fade(int i, Widget child) => FadeTransition(
    opacity: _anims[i],
    child: SlideTransition(
      position:
      Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
          .animate(_anims[i]),
      child: child,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;
    final isTablet = w >= 768 && w < 1100;
    final px = isMobile ? 20.0 : 60.0;

    return Container(
      width: double.infinity,
      constraints:
      BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.92),
      padding: EdgeInsets.fromLTRB(
          px, isMobile ? 100 : 140, px, isMobile ? 60 : 80),
      child: Stack(children: [
        // FIX: RepaintBoundary isolates glow blob repaints from the rest of the tree
        Positioned(
          top: -100,
          right: -100,
          child: RepaintBoundary(
            child: _GlowBlob(
                color: AppColors.accent.withOpacity(0.055), size: 500),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -80,
          child: RepaintBoundary(
            child: _GlowBlob(
                color: AppColors.accentPurple.withOpacity(0.065), size: 450),
          ),
        ),

        isMobile
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContent(isMobile, isTablet),
            const SizedBox(height: 40),
            _buildVisual(isMobile),
          ],
        )
            : Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 5, child: _buildContent(isMobile, isTablet)),
            const SizedBox(width: 40),
            Expanded(flex: 4, child: _buildVisual(isMobile)),
          ],
        ),
      ]),
    );
  }

  Widget _buildContent(bool isMobile, bool isTablet) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _fade(0, const _AvailabilityBadge()),
      const SizedBox(height: 32),

      _fade(
        1,
        RichText(
          text: TextSpan(
            style: GoogleFonts.syne(
              fontSize: isMobile ? 38 : isTablet ? 52 : 68,
              fontWeight: FontWeight.w800,
              height: 1.04,
              letterSpacing: isMobile ? -1.5 : -2.5,
              color: AppColors.textPrimary,
            ),
            children: [
              TextSpan(
                text: '${AppStrings.tagline}\n',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w300,
                  fontSize: isMobile ? 22 : isTablet ? 28 : 34,
                ),
              ),
              const TextSpan(text: 'Farooq Sarwar'),
              const TextSpan(
                  text: '.', style: TextStyle(color: AppColors.accent)),
              TextSpan(
                text: '\n${AppStrings.role}',
                style: GoogleFonts.syne(
                  fontSize: isMobile ? 18 : isTablet ? 22 : 28,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 28),

      _fade(
        2,
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Text(AppStrings.heroSub,
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  height: 1.85,
                  color: AppColors.textMuted)),
        ),
      ),
      const SizedBox(height: 40),

      _fade(
        3,
        Wrap(spacing: 14, runSpacing: 12, children: [
          PrimaryButton(
            label: 'View My Work',
            onTap: widget.onViewWork,
            trailing:
            const Icon(Icons.arrow_forward, size: 16, color: AppColors.bgPrimary),
          ),
          PrimaryButton(
            label: 'Hire on Fiverr',
            bgColor: AppColors.fiverr,
            textColor: Colors.white,
            glowColor: AppColors.fiverr,
            onTap: () => launchUrl(Uri.parse(AppStrings.fiverrGigUrl),
                mode: LaunchMode.externalApplication),
          ),
          GhostButton(label: 'Get in Touch', onTap: widget.onContact),
        ]),
      ),
      const SizedBox(height: 48),

      _fade(
        4,
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'TECH STACK',
            style: GoogleFonts.spaceMono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: AppColors.textMuted.withOpacity(0.5)),
          ),
          const SizedBox(height: 12),
          const Wrap(spacing: 8, runSpacing: 8, children: [
            _TechIcon(
                url: 'https://img.icons8.com/color/96/flutter.png',
                name: 'Flutter'),
            _TechIcon(
                url: 'https://img.icons8.com/color/96/react-native.png',
                name: 'React Native'),
            _TechIcon(
                url: 'https://img.icons8.com/color/96/dart.png', name: 'Dart'),
            _TechIcon(
                url: 'https://img.icons8.com/color/96/firebase.png',
                name: 'Firebase'),
            _TechIcon(
                url: 'https://img.icons8.com/color/96/python--v1.png',
                name: 'Python'),
            _TechIcon(
                url: 'https://img.icons8.com/color/96/figma--v1.png',
                name: 'Figma'),
          ]),
        ]),
      ),
    ]);
  }

  Widget _buildVisual(bool isMobile) {
    return Center(
      child: SizedBox(
        width: isMobile ? 280 : 380,
        height: isMobile ? 320 : 440,
        child: Stack(clipBehavior: Clip.none, children: [
          // FIX: CachedNetworkImage replaces Image.network — no re-fetch on rebuild
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border:
                Border.all(color: AppColors.border.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 40,
                      offset: const Offset(0, 16)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(fit: StackFit.expand, children: [
                  CachedNetworkImage(
                    imageUrl:
                    'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800&q=80',
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: AppColors.bgSecondary,
                      child: Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: AppColors.accent.withOpacity(0.4)),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.bgSecondary,
                      child: Icon(Icons.code,
                          size: 48,
                          color: AppColors.textMuted.withOpacity(0.2)),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            AppColors.bgPrimary.withOpacity(0.8)
                          ],
                          stops: const [0, 0.5, 1],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),

          // FIX: RepaintBoundary on each floating card — their looping animations
          // no longer invalidate the parent hero section on every frame
          Positioned(
            bottom: -16,
            left: -20,
            child: RepaintBoundary(
              child: _FloatingInfoCard(
                iconUrl: 'https://img.icons8.com/color/96/flutter.png',
                title: '10+ Projects',
                subtitle: 'Delivered',
              ),
            ),
          ),

          Positioned(
            top: isMobile ? 20 : 30,
            right: -20,
            child: RepaintBoundary(
              child: _FloatingInfoCard(
                iconUrl: 'https://img.icons8.com/color/96/google-play.png',
                title: '5 Apps',
                subtitle: 'Play Store',
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Availability Badge ──────────────────────────────────────

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.border),
        color: AppColors.surface,
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        // FIX: RepaintBoundary isolates the blink dot's per-frame repaints
        const RepaintBoundary(child: _BlinkDot()),
        const SizedBox(width: 8),
        Text('AVAILABLE FOR WORK',
            style: GoogleFonts.spaceMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.8,
                color: AppColors.accent)),
      ]),
    );
  }
}

// ── Tech Icon ───────────────────────────────────────────────

class _TechIcon extends StatefulWidget {
  final String url, name;
  const _TechIcon({required this.url, required this.name});
  @override
  State<_TechIcon> createState() => _TechIconState();
}

class _TechIconState extends State<_TechIcon> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: Tooltip(
        message: widget.name,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 42,
          height: 42,
          transform: Matrix4.translationValues(0, _h ? -3 : 0, 0),
          decoration: BoxDecoration(
            color: _h
                ? AppColors.accent.withOpacity(0.08)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: _h
                    ? AppColors.accent.withOpacity(0.3)
                    : AppColors.border),
          ),
          // FIX: CachedNetworkImage for all icons
          child: Center(
            child: CachedNetworkImage(
              imageUrl: widget.url,
              width: 22,
              height: 22,
              fit: BoxFit.contain,
              errorWidget: (_, __, ___) => Icon(Icons.code,
                  size: 18, color: AppColors.textMuted.withOpacity(0.5)),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Floating Info Card ──────────────────────────────────────

class _FloatingInfoCard extends StatefulWidget {
  final String iconUrl, title, subtitle;
  const _FloatingInfoCard(
      {required this.iconUrl,
        required this.title,
        required this.subtitle});
  @override
  State<_FloatingInfoCard> createState() => _FloatingInfoCardState();
}

class _FloatingInfoCardState extends State<_FloatingInfoCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  // FIX: CurvedAnimation created once in initState, not inside build()
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3200))
      ..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) =>
          Transform.translate(offset: Offset(0, -6 * _anim.value), child: child),
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 8)),
          ],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
              child: CachedNetworkImage(
                imageUrl: widget.iconUrl,
                width: 18,
                height: 18,
                fit: BoxFit.contain,
                errorWidget: (_, __, ___) => Icon(Icons.code,
                    size: 16, color: AppColors.accent.withOpacity(0.7)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.title,
                    style: GoogleFonts.syne(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(widget.subtitle,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.textMuted)),
              ]),
        ]),
      ),
    );
  }
}

// ── Blink Dot ───────────────────────────────────────────────

class _BlinkDot extends StatefulWidget {
  const _BlinkDot();
  @override
  State<_BlinkDot> createState() => _BlinkDotState();
}

class _BlinkDotState extends State<_BlinkDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl),
    child: Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: AppColors.fiverr,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: AppColors.fiverr.withOpacity(0.6), blurRadius: 6)
        ],
      ),
    ),
  );
}

// ── Glow Blob ───────────────────────────────────────────────

class _GlowBlob extends StatefulWidget {
  final Color color;
  final double size;
  const _GlowBlob({required this.color, required this.size});
  @override
  State<_GlowBlob> createState() => _GlowBlobState();
}

class _GlowBlobState extends State<_GlowBlob>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 7))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) => Opacity(
      opacity: 0.6 + _ctrl.value * 0.4,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient:
          RadialGradient(colors: [widget.color, Colors.transparent]),
        ),
      ),
    ),
  );
}