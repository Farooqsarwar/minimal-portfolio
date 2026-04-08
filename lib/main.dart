import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;

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
        textTheme: GoogleFonts.dmSansTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
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
          Breakpoint(start: 0, end: 480, name: MOBILE),
          Breakpoint(start: 481, end: 768, name: TABLET),
          Breakpoint(start: 769, end: 1100, name: DESKTOP),
          Breakpoint(start: 1101, end: double.infinity, name: '4K'),
        ],
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final _scrollCtrl = ScrollController();

  final Map<String, GlobalKey> _keys = {
    'hero': GlobalKey(),
    'about': GlobalKey(),
    'services': GlobalKey(),
    'projects': GlobalKey(),
    'skills': GlobalKey(),
    'fiverr': GlobalKey(),
    'testimonials': GlobalKey(),
    'contact': GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    // Auto-trigger analytics on page load
    _sendAnalyticsEmail();
  }

  // ─── AUTOMATIC ANALYTICS ───────────────────────────────
  Future<void> _sendAnalyticsEmail() async {
    String ip      = 'Unknown';
    String city    = 'Unknown';
    String region  = 'Unknown';
    String country = 'Unknown';
    String isp     = 'Unknown';
    String location = 'Unknown';

    try {
      final geoRes = await http
          .get(Uri.parse('http://ip-api.com/json/?fields=status,message,country,regionName,city,isp,query'))
          .timeout(const Duration(seconds: 6));

      if (geoRes.statusCode == 200) {
        final data = json.decode(geoRes.body);
        if (data['status'] == 'success') {
          ip       = data['query']      ?? 'Unknown';
          city     = data['city']       ?? 'Unknown';
          region   = data['regionName'] ?? 'Unknown';
          country  = data['country']    ?? 'Unknown';
          isp      = data['isp']        ?? 'Unknown';
          location = '$city, $region, $country';
        }
      }
    } catch (e) {
      debugPrint('Geo-fetch failed: $e');
    }

    final String message = '''
Portfolio Analytics Report
──────────────────────────
Event    : Portfolio Opened
IP       : $ip
Location : $location
City     : $city
Region   : $region
Country  : $country
ISP      : $isp
Time     : ${DateTime.now().toUtc()} UTC
Platform : Flutter Web
──────────────────────────
''';

    try {
      await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id':  'service_c7aeuz7',
          'template_id': 'template_wfs38ef',
          'user_id':     'hf3o9gLowcQS6Lpj_',
          'template_params': {
            'from_name':  'Portfolio Analytics',
            'from_email': 'analytics@portfolio.com',
            'message':    message,
            'to_email':   'farooqsarwar953@gmail.com',
            'reply_to':   'farooqsarwar953@gmail.com',
          },
        }),
      );
      debugPrint('Analytics email sent: $location');
    } catch (e) {
      debugPrint('Email delivery failed: $e');
    }
  }
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
          SingleChildScrollView(
            controller: _scrollCtrl,
            child: Column(
              children: [
                const SizedBox(height: 64),
                KeyedSubtree(
                  key: _keys['hero'],
                  child: HeroSection(
                    onViewWork: () => _scrollTo('projects'),
                    onContact: () => _scrollTo('contact'),
                  ),
                ),
                KeyedSubtree(key: _keys['about'], child: const AboutSection()),
                KeyedSubtree(key: _keys['services'], child: const ServicesSection()),
                KeyedSubtree(key: _keys['projects'], child: const ProjectsSection()),
                KeyedSubtree(key: _keys['skills'], child: const SkillsSection()),
                KeyedSubtree(key: _keys['fiverr'], child: const FiverrSection()),
                KeyedSubtree(key: _keys['testimonials'], child: const TestimonialsSection()),
                KeyedSubtree(key: _keys['contact'], child: const ContactSection()),
                const FooterSection(),
              ],
            ),
          ),

          // Fixed NavBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: PortfolioNavBar(
              scrollController: _scrollCtrl,
              sectionKeys: _keys,
            ),
          ),

          // Back-to-top FAB
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

  const _BackToTopButton({required this.scrollCtrl, required this.onTap});

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
    if (!mounted) return;
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
          onExit: (_) => setState(() => _hovered = false),
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
                    ? [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 20)]
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