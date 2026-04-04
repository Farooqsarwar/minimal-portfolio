import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_styles.dart';
import 'common_widgets.dart';

class PortfolioNavBar extends StatefulWidget {
  final ScrollController scrollController;
  final Map<String, GlobalKey> sectionKeys;

  const PortfolioNavBar({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
  });

  @override
  State<PortfolioNavBar> createState() => _PortfolioNavBarState();
}

class _PortfolioNavBarState extends State<PortfolioNavBar> {
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isScrolled = widget.scrollController.offset > 50;
    if (isScrolled != _scrolled) setState(() => _scrolled = isScrolled);
  }

  void _scrollTo(String section) {
    final key = widget.sectionKeys[section];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
    // Close drawer if open
    if (Scaffold.of(context).isDrawerOpen) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: _scrolled ? 14 : 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary.withOpacity(0.85),
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          GestureDetector(
            onTap: () => _scrollTo('hero'),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.syne(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
                children: const [
                  TextSpan(text: 'Farooq'),
                  TextSpan(
                    text: '.',
                    style: TextStyle(color: AppColors.accent),
                  ),
                ],
              ),
            ),
          ),

          if (!isMobile) ...[
            // Nav links
            Row(
              children: [
                AppStrings.navAbout,
                AppStrings.navServices,
                AppStrings.navProjects,
                AppStrings.navSkills,
                AppStrings.navFiverr,
                AppStrings.navContact,
              ].map((label) => _NavLink(label: label, onTap: () => _scrollTo(label.toLowerCase()))).toList(),
            ),
            // CTA
            PrimaryButton(
              label: AppStrings.navHireBtn,
              bgColor: Colors.transparent,
              textColor: AppColors.accent,
              onTap: () => launchUrl(Uri.parse(AppStrings.fiverrUrl)),
            ),
          ] else
            Builder(
              builder: (ctx) => GestureDetector(
                onTap: () => Scaffold.of(ctx).openDrawer(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5,
                    children: List.generate(
                      3,
                      (_) => Container(
                        width: 22,
                        height: 2,
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTextStyles.navLink.copyWith(
              color: _hovered ? AppColors.textPrimary : AppColors.textMuted,
            ),
            child: Text(widget.label.toUpperCase()),
          ),
        ),
      ),
    );
  }
}

// ─── Mobile Drawer ────────────────────────────────────────
class MobileDrawer extends StatelessWidget {
  final Map<String, GlobalKey> sectionKeys;

  const MobileDrawer({super.key, required this.sectionKeys});

  void _scrollTo(BuildContext context, String section) {
    final key = sectionKeys[section];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.bgSecondary,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              ...[
                AppStrings.navAbout,
                AppStrings.navServices,
                AppStrings.navProjects,
                AppStrings.navSkills,
                AppStrings.navFiverr,
                AppStrings.navContact,
              ].map(
                (label) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: GestureDetector(
                    onTap: () => _scrollTo(context, label.toLowerCase()),
                    child: Text(
                      label.toUpperCase(),
                      style: AppTextStyles.navLink.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => launchUrl(Uri.parse(AppStrings.fiverrUrl)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.fiverr,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'Hire on Fiverr',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
