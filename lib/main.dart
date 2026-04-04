import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'constants/app_colors.dart';
import 'sections/hero_section.dart';
import 'sections/about_section.dart';
import 'sections/services_section.dart';
import 'sections/projects_section.dart';
import 'sections/skills_section.dart';
import 'sections/fiverr_section.dart';
import 'sections/testimonials_section.dart';
import 'sections/contact_section.dart';
import 'sections/footer_section.dart';
import 'widgets/navbar.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farooq Sarwar — Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgPrimary,
        textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme)
            .apply(bodyColor: AppColors.textPrimary, displayColor: AppColors.textPrimary),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          secondary: AppColors.accentPurple,
          surface: AppColors.bgSecondary,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.accent,
          selectionColor: Color(0x3300E5FF),
          selectionHandleColor: AppColors.accent,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
        ),
      ),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: const [
          Breakpoint(start: 0,    end: 480,  name: MOBILE),
          Breakpoint(start: 481,  end: 768,  name: TABLET),
          Breakpoint(start: 769,  end: 1100, name: DESKTOP),
          Breakpoint(start: 1101, end: double.infinity, name: '4K'),
        ],
      ),
      home: const PortfolioHome(),
    );
  }
}

// ─── Home Page ────────────────────────────────────────────
class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final _scrollCtrl = ScrollController();

  // Section keys — used for smooth scroll-to-section nav
  final Map<String, GlobalKey> _keys = {
    'hero':         GlobalKey(),
    'about':        GlobalKey(),
    'services':     GlobalKey(),
    'projects':     GlobalKey(),
    'skills':       GlobalKey(),
    'fiverr':       GlobalKey(),
    'testimonials': GlobalKey(),
    'contact':      GlobalKey(),
  };

  void _scrollTo(String section) {
    final key = _keys[section];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      drawer: MobileDrawer(sectionKeys: _keys),
      body: Stack(
        children: [
          // ── Scrollable content ──────────────────────────
          SingleChildScrollView(
            controller: _scrollCtrl,
            child: Column(
              children: [
                // top padding so content clears fixed navbar
                const SizedBox(height: 64),

                // ── Hero ──────────────────────────────────
                KeyedSubtree(
                  key: _keys['hero'],
                  child: HeroSection(
                    onViewWork: () => _scrollTo('projects'),
                    onContact:  () => _scrollTo('contact'),
                  ),
                ),

                // ── About ─────────────────────────────────
                KeyedSubtree(
                  key: _keys['about'],
                  child: const AboutSection(),
                ),

                // ── Services ──────────────────────────────
                KeyedSubtree(
                  key: _keys['services'],
                  child: const ServicesSection(),
                ),

                // ── Projects ──────────────────────────────
                KeyedSubtree(
                  key: _keys['projects'],
                  child: const ProjectsSection(),
                ),

                // ── Skills ────────────────────────────────
                KeyedSubtree(
                  key: _keys['skills'],
                  child: const SkillsSection(),
                ),

                // ── Fiverr ────────────────────────────────
                KeyedSubtree(
                  key: _keys['fiverr'],
                  child: const FiverrSection(),
                ),

                // ── Testimonials ──────────────────────────
                KeyedSubtree(
                  key: _keys['testimonials'],
                  child: const TestimonialsSection(),
                ),

                // ── Contact ───────────────────────────────
                KeyedSubtree(
                  key: _keys['contact'],
                  child: const ContactSection(),
                ),

                // ── Footer ────────────────────────────────
                const FooterSection(),
              ],
            ),
          ),

          // ── Fixed NavBar (on top) ───────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: PortfolioNavBar(
              scrollController: _scrollCtrl,
              sectionKeys: _keys,
            ),
          ),

          // ── Back-to-top FAB ────────────────────────────
          Positioned(
            bottom: 32,
            right: 32,
            child: _BackToTopButton(
              scrollCtrl: _scrollCtrl,
              onTap: () => _scrollTo('hero'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Back-to-top Button ───────────────────────────────────
class _BackToTopButton extends StatefulWidget {
  final ScrollController scrollCtrl;
  final VoidCallback onTap;

  const _BackToTopButton({
    required this.scrollCtrl,
    required this.onTap,
  });

  @override
  State<_BackToTopButton> createState() => _BackToTopButtonState();
}

class _BackToTopButtonState extends State<_BackToTopButton> {
  bool _visible = false;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    widget.scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    final show = widget.scrollCtrl.offset > 400;
    if (show != _visible) setState(() => _visible = show);
  }

  @override
  void dispose() {
    widget.scrollCtrl.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _visible ? 1.0 : 0.0,
      child: IgnorePointer(
        ignoring: !_visible,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit:  (_) => setState(() => _hovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hovered ? AppColors.accent : AppColors.bgSecondary,
                border: Border.all(
                  color: _hovered ? AppColors.accent : AppColors.border,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.3),
                          blurRadius: 20,
                        )
                      ]
                    : [],
              ),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: _hovered ? AppColors.bgPrimary : AppColors.textMuted,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
