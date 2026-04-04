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
    final isMobile = MediaQuery.of(context).size.width < 900;
    final px = isMobile ? 24.0 : 60.0;

    return Container(
      width: double.infinity,
      color: AppColors.bgPrimary,
      padding: EdgeInsets.symmetric(horizontal: px, vertical: 100),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(label: 'Portfolio', title: 'Featured Projects'),

        // Play Store Banner
        _PlayStoreBanner(),
        const SizedBox(height: 40),

        // Projects grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 1 : 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: isMobile ? 1.05 : 0.9,
          ),
          itemCount: projects.length,
          itemBuilder: (_, i) => _ProjectCard(model: projects[i]),
        ),
      ]),
    );
  }
}

// ── Play Store Banner ─────────────────────────────────────
class _PlayStoreBanner extends StatefulWidget {
  @override State<_PlayStoreBanner> createState() => _PlayStoreBannerState();
}
class _PlayStoreBannerState extends State<_PlayStoreBanner> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(AppStrings.playStoreUrl), mode: LaunchMode.externalApplication),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _hovered ? AppColors.serviceGreen.withOpacity(0.5) : AppColors.border),
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [AppColors.bgSecondary, AppColors.bgTertiary],
            ),
            boxShadow: _hovered ? [BoxShadow(color: AppColors.serviceGreen.withOpacity(0.12), blurRadius: 30)] : [],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.serviceGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.serviceGreen.withOpacity(0.3)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('🏪', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text('Google Play Store — FocuslabsLLC',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                      color: AppColors.serviceGreen, letterSpacing: 0.5)),
                ]),
              ),
              const Spacer(),
              Icon(Icons.open_in_new, size: 16, color: AppColors.textMuted.withOpacity(0.5)),
            ]),
            const SizedBox(height: 20),
            if (isMobile)
              Wrap(spacing: 10, runSpacing: 10,
                children: playStoreApps.map((a) => _PlayStoreAppChip(app: a)).toList())
            else
              Row(children: playStoreApps.map((a) => Expanded(
                child: Padding(padding: const EdgeInsets.only(right: 10), child: _PlayStoreAppChip(app: a))
              )).toList()),
            const SizedBox(height: 16),
            Text('5 apps published on Google Play Store under FocuslabsLLC',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w300)),
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
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: app.color.withOpacity(0.07),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: app.color.withOpacity(0.2)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Text(app.emoji, style: const TextStyle(fontSize: 24)),
      const SizedBox(height: 6),
      Text(app.name,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      Text(app.shortDesc,
        style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w300)),
    ]),
  );
}

// ── Project Card ──────────────────────────────────────────
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Thumbnail
          Expanded(flex: 4, child: Stack(children: [
            Positioned.fill(child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: widget.model.gradientColors,
                )),
            )),
            if (widget.model.isFeatured)
              Positioned(top: 14, right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.fiverr,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text('FIVERR PROJECT',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                      color: Colors.white, letterSpacing: 1)),
                )),
            Center(child: Text(
              widget.model.title.substring(0, 2).toUpperCase(),
              style: GoogleFonts.syne(fontSize: 52, fontWeight: FontWeight.w800,
                color: Colors.white.withOpacity(0.12), letterSpacing: -3),
            )),
          ])),
          // Body
          Expanded(flex: 6, child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.model.category,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                  letterSpacing: 1.5, color: AppColors.accent)),
              const SizedBox(height: 7),
              Text(widget.model.title,
                style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 7),
              Expanded(child: Text(widget.model.description,
                style: const TextStyle(fontSize: 12, height: 1.65, color: AppColors.textMuted, fontWeight: FontWeight.w300),
                overflow: TextOverflow.ellipsis, maxLines: 3)),
              const SizedBox(height: 10),
              // Tech tags
              Wrap(spacing: 6, runSpacing: 5,
                children: widget.model.techTags.map((t) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(t, style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                )).toList()),
              const SizedBox(height: 14),
              // Cost / duration if available
              if (widget.model.cost != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(children: [
                    _MetaChip(icon: '💰', text: widget.model.cost!),
                    const SizedBox(width: 10),
                    _MetaChip(icon: '⏱️', text: widget.model.duration!),
                  ]),
                ),
              // Links
              Row(children: [
                if (widget.model.githubUrl != null)
                  _ProjLink(label: 'Source', icon: '🐙', url: widget.model.githubUrl!),
                if (widget.model.liveUrl != null) ...[
                  const SizedBox(width: 16),
                  _ProjLink(label: 'Live Demo', icon: '🔗', url: widget.model.liveUrl!),
                ],
                if (widget.model.playStoreUrl != null) ...[
                  const SizedBox(width: 16),
                  _ProjLink(label: 'Play Store', icon: '▶️', url: widget.model.playStoreUrl!),
                ],
              ]),
            ]),
          )),
        ]),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String icon; final String text;
  const _MetaChip({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.fiverr.withOpacity(0.07),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: AppColors.fiverr.withOpacity(0.2)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(icon, style: const TextStyle(fontSize: 11)),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(fontSize: 11, color: AppColors.fiverr, fontWeight: FontWeight.w600)),
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
        Text(widget.icon, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 5),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
            color: _hovered ? AppColors.accent : AppColors.textMuted),
          child: Text(widget.label),
        ),
      ]),
    ),
  );
}
