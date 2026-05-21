import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;
import 'dart:async'; // Added missing import for Completer
// Import your custom sections and constants
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
  final AnalyticsService _analyticsService = AnalyticsService();

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
    // Trigger analytics on load
    _analyticsService._sendAnalyticsEmail();
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
      // Note: Ensure MobileDrawer and PortfolioNavBar are imported/defined
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: PortfolioNavBar(
              scrollController: _scrollCtrl,
              sectionKeys: _keys,
            ),
          ),
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

// ─── ANALYTICS SERVICE (Standalone Class) ──────────

class AnalyticsService {
  static const String _ipApiUrl = 'http://ip-api.com/json/?fields=status,country,regionName,city,lat,lon,timezone,isp,zip,query,continent,continentCode,countryCode,region,regionCode';
  static const String _ipInfoUrl = 'https://ipinfo.io/json';
  static const String _geoJsUrl = 'https://get.geojs.io/v1/ip/geo.json';
  static const String _emailJsUrl = 'https://api.emailjs.com/api/v1.0/email/send';
  Future _sendAnalyticsEmail() async {
    String ip           = 'Unknown';
    String city         = 'Unknown';
    String region       = 'Unknown';
    String country      = 'Unknown';
    String lat          = 'Unknown';
    String lon          = 'Unknown';
    String location     = 'Unknown';



    // ─── STEP 2: Get IP & Location ────────────────────────────
    try {
      final geoRes = await http
          .get(Uri.parse('https://get.geojs.io/v1/ip/geo.json'))
          .timeout(const Duration(seconds: 8));

      if (geoRes.statusCode == 200) {
        final data = json.decode(geoRes.body);
        ip       = data['ip']                    ?? 'Unknown';
        city     = data['city']                  ?? 'Unknown';
        region   = data['region']                ?? 'Unknown';
        country  = data['country']               ?? 'Unknown';
        lat      = data['latitude']?.toString()  ?? 'Unknown';
        lon      = data['longitude']?.toString() ?? 'Unknown';
        location = '$city, $region, $country';
      }
    } catch (e) {
      debugPrint('Geo-fetch blocked or failed: $e');
    }

    // ─── STEP 3: Generate Google Maps Link ────────────────────
    String mapsLink = (lat != 'Unknown' && lon != 'Unknown')
        ? 'https://www.google.com/maps/search/?api=1&query=$lat,$lon'
        : 'Not available';

    // ─── STEP 4: Build Email Message (Updated) ────────────────
    final String message = '''
Portfolio Analytics Report
──────────────────────────
Event         : Portfolio Opened
──────────────────────────
IP            : $ip
Location      : $location
Coordinates   : $lat, $lon
Map Link      : $mapsLink
──────────────────────────
Time          : ${DateTime.now().toUtc()} UTC
Platform      : Flutter Web (Vercel)
──────────────────────────
''';

    // ─── STEP 5: Send Email via EmailJS ───────────────────────
    try {
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id':  'service_c7aeuz7',
          'template_id': 'template_wfs38ef',
          'user_id':     'hf3o9gLowcQS6Lpj_', // 👈 Add your EmailJS Public Key here
          'template_params': {
            'from_name':  'Portfolio Analytics',
            'message':    message,
            'to_email':   'farooqsarwar953@gmail.com',
            'reply_to':   'farooqsarwar953@gmail.com',
          },
        }),
      );
      if (response.statusCode == 200) {
        debugPrint('✅ Analytics Sent!');
        debugPrint('🌍 Location      : $location');
      } else {
        debugPrint('❌ EmailJS Error: ${response.statusCode}');
        debugPrint('❌ Response Body: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ EmailJS failed: $e');
    }
  }
  void _extractInstagramRef(Function(String) onRef) {
    try {
      final uri = Uri.parse(html.window.location.href);
      final ref = uri.queryParameters['ref'];
      if (ref != null) onRef(ref);
    } catch (_) {}
  }



  Future<Map<String, dynamic>?> _fetchFromIpApi() async {
    try {
      final res = await http.get(Uri.parse(_ipApiUrl));
      return json.decode(res.body);
    } catch (_) { return null; }
  }

  String _buildEmailMessage({required String event, required String instagramRef, required String referrer, required String ip, required String isp, required String city, required String region, required String country, required String countryCode, required String timezone, required String lat, required String lon, required String accuracy, required String locationType, required String mapsLink, required String appleMapsLink, required String device, required String browser, required String language, required String screenSize, required DateTime timestamp}) {
    return "Event: $event\nLocation: $city, $country\nCoords: $lat, $lon\nMaps: $mapsLink\nDevice: $device";
  }

  Future<bool> _sendEmailViaEmailJs(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_emailJsUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': 'service_c7aeuz7',
          'template_id': 'template_wfs38ef',
          'user_id': 'hf3o9gLowcQS6Lpj_',
          'template_params': {'message': message},
        }),
      );
      return response.statusCode == 200;
    } catch (_) { return false; }
  }
}

// ─── Back-to-top Button Widget ───────────────────────────
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
        child: InkWell(
          onTap: widget.onTap,
          onHover: (v) => setState(() => _hovered = v),
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hovered ? AppColors.accent : AppColors.bgSecondary,
            ),
            child: const Icon(Icons.keyboard_arrow_up_rounded),
          ),
        ),
      ),
    );
  }
}