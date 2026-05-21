import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/portfolio_data.dart';
import '../widgets/common_widgets.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 900;
    final px = isMobile ? 24.0 : 60.0;

    return Container(
      width: double.infinity,
      color: AppColors.bgPrimary,
      padding: EdgeInsets.symmetric(horizontal: px, vertical: 100),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(label: 'Portfolio', title: 'Featured Projects'),
        const SizedBox(height: 30),
        const _PlayStoreBanner(),
        const SizedBox(height: 40),
        LayoutBuilder(builder: (context, constraints) {
          if (isMobile) {
            return Column(
              children: projects
                  .map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: RepaintBoundary(
                  child: _ProjectCard(
                      model: p, cardWidth: constraints.maxWidth),
                ),
              ))
                  .toList(),
            );
          }
          final cardW = (constraints.maxWidth - 24) / 2;
          return Wrap(
            spacing: 24,
            runSpacing: 24,
            children: projects
                .map((p) => SizedBox(
              width: cardW,
              // FIX: RepaintBoundary on every project card
              child: RepaintBoundary(
                child: _ProjectCard(model: p, cardWidth: cardW),
              ),
            ))
                .toList(),
          );
        }),
      ]),
    );
  }
}

class _PlayStoreBanner extends StatefulWidget {
  const _PlayStoreBanner();
  @override
  State<_PlayStoreBanner> createState() => _PlayStoreBannerState();
}

class _PlayStoreBannerState extends State<_PlayStoreBanner> {
  bool _h = false;

  void _setHover(bool val) {
    if (_h != val && mounted) setState(() => _h = val);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(AppStrings.playStoreUrl),
            mode: LaunchMode.externalApplication),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: _h
                    ? AppColors.serviceGreen.withOpacity(0.5)
                    : AppColors.border),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.bgSecondary, AppColors.bgTertiary],
            ),
            boxShadow: _h
                ? [
              BoxShadow(
                  color: AppColors.serviceGreen.withOpacity(0.1),
                  blurRadius: 20)
            ]
                : [],
          ),
          child: RepaintBoundary(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.serviceGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color:
                            AppColors.serviceGreen.withOpacity(0.3)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        CachedNetworkImage(
                          imageUrl:
                          'https://img.icons8.com/color/96/google-play.png',
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                          errorWidget: (_, __, ___) => const Icon(
                              Icons.store,
                              size: 16,
                              color: AppColors.serviceGreen),
                        ),
                        const SizedBox(width: 8),
                        const Flexible(
                          child: Text(
                            'Google Play Store — FocuslabsLLC',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.serviceGreen),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.open_in_new,
                      size: 16,
                      color: AppColors.textMuted.withOpacity(0.5)),
                ]),
                const SizedBox(height: 20),
                if (isMobile)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: playStoreApps
                        .map((a) => SizedBox(
                      width: (w - 48 - 34) / 2,
                      child: _PlayStoreAppChip(app: a),
                    ))
                        .toList(),
                  )
                else
                  Row(
                    children: playStoreApps
                        .map((a) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _PlayStoreAppChip(app: a),
                      ),
                    ))
                        .toList(),
                  ),
                const SizedBox(height: 14),
                const Text(
                  '5 apps published under FocuslabsLLC',
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayStoreAppChip extends StatelessWidget {
  final PlayStoreApp app;
  const _PlayStoreAppChip({required this.app});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: app.color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: app.color.withOpacity(0.2)),
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: _playStoreAppIcon(app.name),
            width: 36,
            height: 36,
            fit: BoxFit.contain,
            errorWidget: (_, __, ___) => Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: app.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.apps_rounded,
                  size: 20, color: app.color.withOpacity(0.7)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(app.name,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(app.shortDesc,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w300),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ]),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectModel model;
  final double cardWidth;
  const _ProjectCard({required this.model, required this.cardWidth});
  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _h = false;

  void _setHover(bool val) {
    if (_h != val && mounted) setState(() => _h = val);
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.model;
    final isMobile = MediaQuery.of(context).size.width < 900;
    final imageUrl = _projectImage(m.title);

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _h ? -6 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: _h
                  ? Colors.white.withOpacity(0.12)
                  : AppColors.border),
          boxShadow: _h
              ? [
            BoxShadow(
                color: m.gradientColors.last.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 10)),
          ]
              : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: isMobile ? 220 : 240,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: m.gradientColors,
                        ),
                      ),
                    ),
                  ),
                  // FIX: CachedNetworkImage replaces Image.network with cacheWidth
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      // FIX: memCacheWidth limits decode size — equivalent to cacheWidth
                      memCacheWidth: 800,
                      placeholder: (_, __) => const SizedBox(),
                      errorWidget: (_, __, ___) => const SizedBox(),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 0.9,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.15),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 60,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.bgSecondary
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.12)),
                      ),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                  color: m.gradientColors.last,
                                  shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: widget.cardWidth * 0.45),
                              child: Text(
                                m.category,
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    color: Colors.white70),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.12)),
                      ),
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: _projectLogo(m.title),
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          errorWidget: (_, __, ___) => const Icon(
                              Icons.code,
                              size: 16,
                              color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                  if (m.isFeatured)
                    Positioned(
                      bottom: 14,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            AppColors.accent,
                            AppColors.accent.withOpacity(0.7)
                          ]),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.star_rounded,
                                size: 12, color: Colors.black87),
                            SizedBox(width: 4),
                            Text('Featured',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(m.title,
                      style: GoogleFonts.syne(
                          fontSize: isMobile ? 18 : 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(m.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w300)),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: m.techTags
                        .take(4)
                        .map((t) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(6),
                        border:
                        Border.all(color: AppColors.border),
                      ),
                      child: Text(t,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500)),
                    ))
                        .toList(),
                  ),
                  if (m.cost != null) ...[
                    const SizedBox(height: 12),
                    Wrap(spacing: 8, runSpacing: 6, children: [
                      _MetaChip(
                          icon: Icons.payments_outlined, text: m.cost!),
                      _MetaChip(
                          icon: Icons.schedule_rounded,
                          text: m.duration!),
                    ]),
                  ],
                  const SizedBox(height: 16),
                  Container(
                      height: 1,
                      color: AppColors.border.withOpacity(0.4)),
                  const SizedBox(height: 14),
                  Wrap(spacing: 16, runSpacing: 8, children: [
                    if (m.githubUrl != null)
                      _ProjLink(
                          label: 'Source',
                          icon: Icons.code_rounded,
                          url: m.githubUrl!),
                    if (m.liveUrl != null)
                      _ProjLink(
                          label: 'Live',
                          icon: Icons.launch_rounded,
                          url: m.liveUrl!),
                    if (m.playStoreUrl != null)
                      _ProjLink(
                          label: 'Play Store',
                          icon: Icons.play_arrow_rounded,
                          url: m.playStoreUrl!),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaChip({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.accent.withOpacity(0.07),
      borderRadius: BorderRadius.circular(6),
      border:
      Border.all(color: AppColors.accent.withOpacity(0.2)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: AppColors.accent),
      const SizedBox(width: 4),
      Text(text,
          style: const TextStyle(
              fontSize: 11,
              color: AppColors.accent,
              fontWeight: FontWeight.w600)),
    ]),
  );
}

class _ProjLink extends StatefulWidget {
  final String label, url;
  final IconData icon;
  const _ProjLink(
      {required this.label, required this.icon, required this.url});
  @override
  State<_ProjLink> createState() => _ProjLinkState();
}

class _ProjLinkState extends State<_ProjLink> {
  bool _h = false;
  void _setHover(bool val) {
    if (_h != val && mounted) setState(() => _h = val);
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => _setHover(true),
    onExit: (_) => _setHover(false),
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () => launchUrl(Uri.parse(widget.url),
          mode: LaunchMode.externalApplication),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(widget.icon,
            size: 14,
            color: _h ? AppColors.accent : AppColors.textMuted),
        const SizedBox(width: 6),
        Text(widget.label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color:
                _h ? AppColors.accent : AppColors.textMuted)),
      ]),
    ),
  );
}

// ── Image / Logo helpers ────────────────────────────────────

String _projectImage(String title) {
  switch (title) {
    case 'Lung Scan AI':
      return 'https://static.vecteezy.com/system/resources/previews/004/745/178/non_2x/application-design-set-for-lungs-health-care-check-your-lungs-and-lungs-checkup-ui-onboarding-screens-design-mobile-app-template-web-site-isometric-modern-illustrations-for-user-interface-free-vector.jpg';
    case 'Auction App':
      return 'https://cdn.dribbble.com/userupload/44359403/file/c884a636351eae51d0e5e2ddf7443ad8.png?resize=1600x1138&vertical=center';
    case 'Minimal Social Media Web App':
      return 'https://cdn.dribbble.com/userupload/44543445/file/9976932dc7b2fef4363661166abe5f28.png?resize=2048x1536&vertical=center';
    case 'Tic Tac Toe':
      return 'https://cdn.dribbble.com/userupload/11480770/file/original-fe75d8b3d9ca749946abe0879182a011.png?resize=1504x1128&vertical=center';
    case 'V Chat':
      return 'https://cdn.dribbble.com/userupload/9508817/file/original-4a443e64eb7000c0234a27647ca72e3d.png?resize=1600x1200&vertical=center';
    case 'Steganography App':
      return 'https://cdn.dribbble.com/userupload/43080982/file/original-172b1276c133cabd26350daa8921b098.png?resize=1600x1200&vertical=center';
    case 'Music Player':
      return 'https://cdn.dribbble.com/userupload/37446881/file/original-aa86c3eee01653227bf968750beebc8e.png?resize=2048x1536&vertical=center';
    default:
      return 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800&q=80';
  }
}

String _projectLogo(String title) {
  switch (title) {
    case 'Lung Scan AI':
      return 'https://img.icons8.com/color/96/python--v1.png';
    case 'Auction App':
      return 'https://img.icons8.com/color/96/supabase.png';
    case 'Minimal Social Media Web App':
      return 'https://img.icons8.com/color/96/flutter.png';
    case 'Tic Tac Toe':
      return 'https://img.icons8.com/color/96/react-native.png';
    case 'V Chat':
      return 'https://img.icons8.com/color/96/firebase.png';
    case 'Steganography App':
      return 'https://img.icons8.com/color/96/lock--v1.png';
    case 'Music Player':
      return 'https://img.icons8.com/color/96/music.png';
    default:
      return 'https://img.icons8.com/color/96/flutter.png';
  }
}

String _playStoreAppIcon(String name) {
  switch (name) {
    case 'Bird Watcher':
      return 'https://img.icons8.com/color/96/bird.png';
    case 'Coin Tracker':
      return 'https://img.icons8.com/color/96/bitcoin--v1.png';
    case 'Fish Guide':
      return 'https://img.icons8.com/color/96/fish.png';
    case 'Dog Trainer':
      return 'https://img.icons8.com/color/96/dog--v1.png';
    case 'Cat Companion':
      return 'https://img.icons8.com/color/96/cat--v1.png';
    default:
      return 'https://img.icons8.com/color/96/google-play.png';
  }
}