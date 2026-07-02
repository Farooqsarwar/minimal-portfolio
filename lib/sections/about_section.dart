import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_styles.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 900;
    final px = isMobile ? 20.0 : w < 1200 ? 48.0 : 80.0;

    return Container(
      width: double.infinity,
      color: AppColors.bgPrimary,
      padding: EdgeInsets.symmetric(
          horizontal: px, vertical: isMobile ? 64 : 110),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: isMobile
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _PhotoWidget(height: 280),
            const SizedBox(height: 20),
            const _ToolkitWidget(),
            const SizedBox(height: 48),
            _TextContentWidget(isMobile: isMobile),
          ])
              : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: w < 1200 ? 360 : 440,
              child: const _VisualColumnWidget(),
            ),
            SizedBox(width: w < 1200 ? 48 : 80),
            Expanded(child: _TextContentWidget(isMobile: isMobile)),
          ]),
        ),
      ),
    );
  }
}

class _VisualColumnWidget extends StatelessWidget {
  const _VisualColumnWidget();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 480,
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned(
            top: -14,
            left: 20,
            child: Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Positioned(
            top: 0, left: 0, right: 40, bottom: 60,
            child: _PhotoWidget(),
          ),
          // FIX: RepaintBoundary isolates the looping float animation
          const Positioned(
            bottom: 8,
            right: 0,
            child: RepaintBoundary(
              child: _FloatingCard(
                imageUrl: 'https://img.icons8.com/color/96/flutter.png',
                title: '10+ Projects',
                subtitle: 'Shipped & Delivered',
              ),
            ),
          ),
        ]),
      ),
      const SizedBox(height: 28),
      const _ToolkitWidget(),
    ]);
  }
}

class _PhotoWidget extends StatelessWidget {
  final double? height;
  const _PhotoWidget({this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 12),
            spreadRadius: -6,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(fit: StackFit.expand, children: [
          // FIX: CachedNetworkImage — no re-fetch on rebuild/scroll
          CachedNetworkImage(
            imageUrl:
            'https://plus.unsplash.com/premium_photo-1720287601920-ee8c503af775?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bW9iaWxlJTIwYXBwJTIwZGV2ZWxvcG1lbnR8ZW58MHx8MHx8fDA%3D',
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: AppColors.bgSecondary,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: AppColors.accent.withOpacity(0.4),
                ),
              ),
            ),
            errorWidget: (_, __, ___) => Container(
              color: AppColors.bgSecondary,
              child: Icon(Icons.code_rounded,
                  size: 40, color: AppColors.textMuted.withOpacity(0.3)),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    AppColors.bgPrimary.withOpacity(0.85),
                  ],
                  stops: const [0, 0.5, 1],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 18,
            left: 18,
            child: Row(children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.accent.withOpacity(0.4),
                        blurRadius: 8),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text('Available for projects',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary.withOpacity(0.9))),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _ToolkitWidget extends StatelessWidget {
  const _ToolkitWidget();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('TOOLKIT',
          style: GoogleFonts.spaceMono(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
              color: AppColors.textMuted)),
      const SizedBox(height: 14),
      const Wrap(spacing: 10, runSpacing: 10, children: [
        _TechLogo(
            url: 'https://img.icons8.com/color/96/flutter.png',
            name: 'Flutter',
            color: Color(0xFF54C5F8)),
        _TechLogo(
            url: 'https://img.icons8.com/color/96/react-native.png',
            name: 'React Native',
            color: Color(0xFF61DAFB)),
        _TechLogo(
            url: 'https://img.icons8.com/color/96/firebase.png',
            name: 'Firebase',
            color: Color(0xFFFFCA28)),
        _TechLogo(
            url: 'https://img.icons8.com/color/96/dart.png',
            name: 'Dart',
            color: Color(0xFF0175C2)),
        _TechLogo(
            url: 'https://img.icons8.com/color/96/google-play.png',
            name: 'Play Store',
            color: Color(0xFF34A853)),
        _TechLogo(
            url: 'https://img.icons8.com/color/96/python--v1.png',
            name: 'AI / ML',
            color: Color(0xFFAB47BC)),
      ]),
    ]);
  }
}

class _TextContentWidget extends StatelessWidget {
  final bool isMobile;
  const _TextContentWidget({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        Text('ABOUT ME', style: AppTextStyles.sectionLabel),
      ]),
      const SizedBox(height: 28),
      RichText(
        text: TextSpan(
          style: GoogleFonts.syne(
            fontSize: isMobile ? 28 : 40,
            fontWeight: FontWeight.w800,
            height: 1.15,
            letterSpacing: isMobile ? -0.5 : -1.5,
            color: AppColors.textPrimary,
          ),
          children: [
            const TextSpan(
                text: 'Flutter & React Native\nDeveloper from '),
            TextSpan(
              text: 'Pakistan',
              style: TextStyle(
                color: AppColors.accent,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.accent.withOpacity(0.3),
                decorationThickness: 2,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      ...[AppStrings.aboutBody1, AppStrings.aboutBody2, AppStrings.aboutBody3]
          .map((t) => Text(t, style: AppTextStyles.body)),
      const SizedBox(height: 22),
      Container(width: 56, height: 1, color: AppColors.border),
      const SizedBox(height: 10),
      Text('LANGUAGES',
          style: GoogleFonts.spaceMono(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
              color: AppColors.textMuted)),
      const SizedBox(height: 14),
      const Wrap(spacing: 10, runSpacing: 10, children: [
        _LangChip(
            flagUrl: 'https://flagcdn.com/w80/pk.png',
            lang: 'Urdu',
            level: 'Native'),
        _LangChip(
            flagUrl: 'https://flagcdn.com/w80/gb.png',
            lang: 'English',
            level: 'Fluent'),
        _LangChip(
            flagUrl: 'https://flagcdn.com/w80/af.png',
            lang: 'Pashto',
            level: 'Native'),
      ]),
    ]);
  }
}

class _LangChip extends StatelessWidget {
  final String flagUrl, lang, level;
  const _LangChip(
      {required this.flagUrl, required this.lang, required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        color: AppColors.bgSecondary,
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          // FIX: CachedNetworkImage for flags
          child: CachedNetworkImage(
            imageUrl: flagUrl,
            width: 24,
            height: 16,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => Container(
              width: 24,
              height: 16,
              color: AppColors.border,
              child: const Icon(Icons.flag,
                  size: 12, color: AppColors.textMuted),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(lang,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1)),
              const SizedBox(height: 3),
              Text(level,
                  style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMuted,
                      height: 1)),
            ]),
      ]),
    );
  }
}

class _TechLogo extends StatefulWidget {
  final String url, name;
  final Color color;
  const _TechLogo(
      {required this.url, required this.name, required this.color});
  @override
  State<_TechLogo> createState() => _TechLogoState();
}

class _TechLogoState extends State<_TechLogo> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _h
                ? widget.color.withOpacity(0.1)
                : AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: _h
                    ? widget.color.withOpacity(0.35)
                    : AppColors.border),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            CachedNetworkImage(
              imageUrl: widget.url,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              errorWidget: (_, __, ___) => Icon(Icons.code,
                  size: 22, color: widget.color.withOpacity(0.7)),
            ),
            const SizedBox(width: 10),
            Text(widget.name,
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ]),
        ),
      ),
    );
  }
}

// ── Floating Card ───────────────────────────────────────────

class _FloatingCard extends StatefulWidget {
  final String imageUrl, title, subtitle;
  const _FloatingCard(
      {required this.imageUrl,
        required this.title,
        required this.subtitle});
  @override
  State<_FloatingCard> createState() => _FloatingCardState();
}

class _FloatingCardState extends State<_FloatingCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  // FIX: CurvedAnimation created once in initState, not inside build()
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3400))
      ..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) =>
          Transform.translate(offset: Offset(0, -8 * _anim.value), child: child),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 28,
              offset: const Offset(0, 10),
              spreadRadius: -4,
            ),
          ],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorWidget: (_, __, ___) => Icon(Icons.rocket_launch,
                    size: 20, color: AppColors.accent.withOpacity(0.7)),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.title,
                    style: GoogleFonts.syne(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 5),
                Text(widget.subtitle,
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted)),
              ]),
        ]),
      ),
    );
  }
}