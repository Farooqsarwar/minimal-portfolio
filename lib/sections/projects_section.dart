import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
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
        const _PlayStoreBanner(),
        const SizedBox(height: 40),
        // Use column of rows instead of GridView with fixed aspect ratio
        if (isMobile)
          Column(children: projects.map((p) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _ProjectCard(model: p),
          )).toList())
        else
          _ProjectsGrid(),
      ]),
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Build pairs of cards in rows — no fixed childAspectRatio
    final rows = <Widget>[];
    for (int i = 0; i < projects.length; i += 2) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _ProjectCard(model: projects[i])),
              const SizedBox(width: 20),
              if (i + 1 < projects.length)
                Expanded(child: _ProjectCard(model: projects[i + 1]))
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
      if (i + 2 < projects.length) rows.add(const SizedBox(height: 20));
    }
    return Column(children: rows);
  }
}

// ── Play Store Banner ─────────────────────────────────────
class _PlayStoreBanner extends StatefulWidget {
  const _PlayStoreBanner();
  @override State<_PlayStoreBanner> createState() => _PlayStoreBannerState();
}
class _PlayStoreBannerState extends State<_PlayStoreBanner> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(AppStrings.playStoreUrl), mode: LaunchMode.externalApplication),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _hovered ? AppColors.serviceGreen.withOpacity(0.5) : AppColors.border),
            gradient: const LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [AppColors.bgSecondary, AppColors.bgTertiary],
            ),
            boxShadow: _hovered ? [BoxShadow(color: AppColors.serviceGreen.withOpacity(0.1), blurRadius: 30)] : [],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Row(children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.serviceGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.serviceGreen.withOpacity(0.3)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Text('🏪', style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 6),
                    Flexible(child: Text('Google Play Store — FocuslabsLLC',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                        color: AppColors.serviceGreen),
                      overflow: TextOverflow.ellipsis)),
                  ]),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.open_in_new, size: 15, color: AppColors.textMuted.withOpacity(0.5)),
            ]),
            const SizedBox(height: 16),
            if (isMobile)
              Wrap(spacing: 8, runSpacing: 8,
                children: playStoreApps.map((a) => SizedBox(
                  width: (w - 48 - 32) / 2, // 2 per row on mobile
                  child: _PlayStoreAppChip(app: a),
                )).toList())
            else
              Row(children: playStoreApps.map((a) => Expanded(
                child: Padding(padding: const EdgeInsets.only(right: 8), child: _PlayStoreAppChip(app: a))
              )).toList()),
            const SizedBox(height: 12),
            Text('5 apps published under FocuslabsLLC',
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w300)),
          ]),
        ),
      ),
    );
  }
}

class _PlayStoreAppChip extends StatelessWidget {
  final PlayStoreApp app;
  const _PlayStoreAppChip({required this.app});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: app.color.withOpacity(0.07),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: app.color.withOpacity(0.2)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Text(app.emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 4),
      Text(app.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        overflow: TextOverflow.ellipsis),
      Text(app.shortDesc, style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w300),
        overflow: TextOverflow.ellipsis),
    ]),
  );
}

// ── Project Card ─────────────────────────────────────────
class _ProjectCard extends StatefulWidget {
  final ProjectModel model;
  const _ProjectCard({required this.model});
  @override State<_ProjectCard> createState() => _ProjectCardState();
}
class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _hovered ? Colors.white.withOpacity(0.1) : AppColors.border),
          boxShadow: _hovered ? [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 50)] : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // KEY: don't force height
          children: [
            // Thumbnail — fixed height, not Expanded
            SizedBox(
              height: 160,
              width: double.infinity,
              child: Stack(children: [
                Positioned.fill(child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: widget.model.gradientColors,
                    )),
                )),
                if (widget.model.isFeatured)
                  Positioned(top: 12, right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.fiverr,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text('FIVERR PROJECT',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1)),
                    )),
                Center(child: Text(
                  widget.model.title.substring(0, 2).toUpperCase(),
                  style: GoogleFonts.syne(fontSize: 48, fontWeight: FontWeight.w800,
                    color: Colors.white.withOpacity(0.12), letterSpacing: -3),
                )),
              ]),
            ),
            // Body — natural height, no Expanded
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.model.category,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                      letterSpacing: 1.5, color: AppColors.accent)),
                  const SizedBox(height: 6),
                  Text(widget.model.title,
                    style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  Text(widget.model.description,
                    style: const TextStyle(fontSize: 12, height: 1.6, color: AppColors.textMuted, fontWeight: FontWeight.w300),
                    maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  // Tech tags
                  Wrap(spacing: 5, runSpacing: 5,
                    children: widget.model.techTags.map((t) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(t, style: const TextStyle(fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                    )).toList()),
                  // Cost + duration
                  if (widget.model.cost != null) ...[
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, runSpacing: 6, children: [
                      _MetaChip(icon: '💰', text: widget.model.cost!),
                      _MetaChip(icon: '⏱️', text: widget.model.duration!),
                    ]),
                  ],
                  const SizedBox(height: 12),
                  // Links — use Wrap to avoid Row overflow
                  Wrap(spacing: 14, runSpacing: 8, children: [
                    if (widget.model.githubUrl != null)
                      _ProjLink(label: 'Source', icon: '🐙', url: widget.model.githubUrl!),
                    if (widget.model.liveUrl != null)
                      _ProjLink(label: 'Live Demo', icon: '🔗', url: widget.model.liveUrl!),
                    if (widget.model.playStoreUrl != null)
                      _ProjLink(label: 'Play Store', icon: '▶️', url: widget.model.playStoreUrl!),
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
  final String icon; final String text;
  const _MetaChip({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: AppColors.fiverr.withOpacity(0.07),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: AppColors.fiverr.withOpacity(0.2)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(icon, style: const TextStyle(fontSize: 10)),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(fontSize: 10, color: AppColors.fiverr, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _ProjLink extends StatefulWidget {
  final String label, icon, url;
  const _ProjLink({required this.label, required this.icon, required this.url});
  @override State<_ProjLink> createState() => _ProjLinkState();
}
class _ProjLinkState extends State<_ProjLink> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit:  (_) => setState(() => _hovered = false),
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () => launchUrl(Uri.parse(widget.url), mode: LaunchMode.externalApplication),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(widget.icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 5),
        Text(widget.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
          color: _hovered ? AppColors.accent : AppColors.textMuted)),
      ]),
    ),
  );
}
