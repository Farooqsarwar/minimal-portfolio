
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:web/web.dart' as web;

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

// ─────────────────────────────────────────────────────────────────────────────
// APP
// ─────────────────────────────────────────────────────────────────────────────

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
          Breakpoint(start: 0,    end: 480,             name: MOBILE),
          Breakpoint(start: 481,  end: 768,             name: TABLET),
          Breakpoint(start: 769,  end: 1100,            name: DESKTOP),
          Breakpoint(start: 1101, end: double.infinity, name: '4K'),
        ],
      ),
      home: const PortfolioHome(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HOME
// ─────────────────────────────────────────────────────────────────────────────

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final _scrollCtrl       = ScrollController();
  final _analyticsService = AnalyticsService();

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

  @override
  void initState() {
    super.initState();
    _analyticsService.sendAnalyticsEmail();
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
          // ── Main scrollable content ──────────────────────────
          SingleChildScrollView(
            controller: _scrollCtrl,
            child: Column(
              children: [
                const SizedBox(height: 64),
                KeyedSubtree(
                  key: _keys['hero'],
                  child: HeroSection(
                    onViewWork: () => _scrollTo('projects'),
                    onContact:  () => _scrollTo('contact'),
                  ),
                ),
                KeyedSubtree(key: _keys['about'],        child: const AboutSection()),
                KeyedSubtree(key: _keys['services'],     child: const ServicesSection()),
                KeyedSubtree(key: _keys['projects'],     child: const ProjectsSection()),
                KeyedSubtree(key: _keys['skills'],       child: const SkillsSection()),
                KeyedSubtree(key: _keys['fiverr'],       child: const FiverrSection()),
                KeyedSubtree(key: _keys['testimonials'], child: const TestimonialsSection()),
                KeyedSubtree(key: _keys['contact'],      child: const ContactSection()),
                const FooterSection(),
              ],
            ),
          ),

          // ── Navbar (always on top) ───────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: PortfolioNavBar(
              scrollController: _scrollCtrl,
              sectionKeys: _keys,
            ),
          ),

          // ── Back-to-top button ───────────────────────────────
          Positioned(
            bottom: 32, right: 32,
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

// ANALYTICS SERVICE

class AnalyticsService {
  // ── Email proxy (credentials live server-side, see /api/send-email) ──
  static const String _emailProxyUrl = '/api/send-email';

  // ── GeoJS IP API (free, no key) ──────────────────────────────
  static const String _geoJsUrl = 'https://get.geojs.io/v1/ip/geo.json';

  // ─────────────────────────────────────────────────────────────
  // PUBLIC ENTRY POINT
  // Collects device info immediately, shows GPS popup,
  // waits up to 35s for user to respond, then sends email.
  // ─────────────────────────────────────────────────────────────
  Future<void> sendAnalyticsEmail() async {
    // ── Collect non-location info immediately ──────────────────
    final instagramRef = _extractRef();
    final device       = _deviceInfo();
    final browser      = _browserInfo();
    final referrer     = _referrerInfo();
    final screen       = _screenSize();
    final language     = _language();

    debugPrint('📍 GPS popup triggered. Waiting up to 35s for user response...');

    // ── Wait for GPS or timeout, then fall back to IP ──────────
    final loc = await _waitForLocationWithTimeout(timeoutSeconds: 35);

    debugPrint('📬 Location resolved. Sending email now...');

    // ── Build and send ─────────────────────────────────────────
    final message = _buildMessage(
      loc:          loc,
      instagramRef: instagramRef,
      device:       device,
      browser:      browser,
      referrer:     referrer,
      screen:       screen,
      language:     language,
    );

    await _sendEmail(message);
  }

  // ─────────────────────────────────────────────────────────────
  // WAIT FOR LOCATION
  // Starts GPS listener + 35s hard timeout in parallel.
  // Whichever resolves first wins.
  // ─────────────────────────────────────────────────────────────
  Future<Map<String, String>> _waitForLocationWithTimeout({
    required int timeoutSeconds,
  }) async {
    final completer = Completer<Map<String, String>>();

    // ── Fire GPS popup ─────────────────────────────────────────
    _startGpsListener(completer);

    // ── Hard timeout ───────────────────────────────────────────
    // If user ignores popup for timeoutSeconds → fall back to IP
    Future.delayed(Duration(seconds: timeoutSeconds), () {
      if (!completer.isCompleted) {
        debugPrint('⏱ ${timeoutSeconds}s passed. User ignored popup. Using IP...');
        _fetchIpLocation().then((ipLoc) {
          if (!completer.isCompleted) completer.complete(ipLoc);
        });
      }
    });

    return completer.future;
  }

  // ─────────────────────────────────────────────────────────────
  // GPS LISTENER
  // Callbacks MUST be synchronous (void) for .toJS to work.
  // Async fallbacks use .then() instead of await.
  // ─────────────────────────────────────────────────────────────
  void _startGpsListener(Completer<Map<String, String>> completer) {
    try {
      final geolocation = web.window.navigator.geolocation;

      // ── SUCCESS: User clicked "Allow" ──────────────────────
      final onSuccess = (web.GeolocationPosition position) {
        if (completer.isCompleted) return;

        try {
          final lat = position.coords.latitude.toStringAsFixed(6);
          final lon = position.coords.longitude.toStringAsFixed(6);
          final acc = position.coords.accuracy.toStringAsFixed(0);

          debugPrint('✅ GPS allowed: $lat, $lon (±${acc}m)');

          completer.complete({
            'source':    'GPS',
            'accuracy':  '±${acc}m',
            'lat':       lat,
            'lon':       lon,
            'location':  'GPS coordinates',
            'mapsLink':  'https://www.google.com/maps/search/?api=1&query=$lat,$lon',
            'appleMaps': 'https://maps.apple.com/?q=$lat,$lon',
          });
        } catch (e) {
          debugPrint('❌ GPS parse error: $e — falling back to IP.');
          _fetchIpLocation().then((ipLoc) {
            if (!completer.isCompleted) completer.complete(ipLoc);
          });
        }
      }.toJS;

      // ── ERROR: User clicked "Deny" or browser blocked ──────
      final onError = (web.GeolocationPositionError error) {
        if (completer.isCompleted) return;

        debugPrint(
          '❌ GPS denied (code ${error.code}): ${error.message} — using IP.',
        );

        _fetchIpLocation().then((ipLoc) {
          if (!completer.isCompleted) completer.complete(ipLoc);
        });
      }.toJS;

      // ── Options ────────────────────────────────────────────
      final options = web.PositionOptions(
        enableHighAccuracy: true,
        timeout:            30000, // ms to acquire fix after permission granted
        maximumAge:         0,
      );

      geolocation.getCurrentPosition(onSuccess, onError, options);

    } catch (e) {
      // Geolocation API not available at all → go straight to IP
      debugPrint('❌ Geolocation not available: $e — using IP.');
      _fetchIpLocation().then((ipLoc) {
        if (!completer.isCompleted) completer.complete(ipLoc);
      });
    }
  }

  // ─────────────────────────────────────────────────────────────
  // IP GEOLOCATION FALLBACK
  // Uses GeoJS — free, no API key needed
  // ─────────────────────────────────────────────────────────────
  Future<Map<String, String>> _fetchIpLocation() async {
    try {
      final res = await http
          .get(Uri.parse(_geoJsUrl))
          .timeout(const Duration(seconds: 8));

      if (res.statusCode != 200) {
        debugPrint('❌ GeoJS HTTP ${res.statusCode}');
        return _unknownLocation();
      }

      final data     = json.decode(res.body) as Map<String, dynamic>;
      final ip       = data['ip']?.toString()                ?? 'Unknown';
      final city     = data['city']?.toString()              ?? 'Unknown';
      final region   = data['region']?.toString()            ?? 'Unknown';
      final country  = data['country']?.toString()           ?? 'Unknown';
      final lat      = data['latitude']?.toString()          ?? 'Unknown';
      final lon      = data['longitude']?.toString()         ?? 'Unknown';
      final org      = data['organization_name']?.toString() ?? 'Unknown';
      final timezone = data['timezone']?.toString()          ?? 'Unknown';

      final mapsLink  = (lat != 'Unknown' && lon != 'Unknown')
          ? 'https://www.google.com/maps/search/?api=1&query=$lat,$lon'
          : 'Not available';
      final appleMaps = (lat != 'Unknown' && lon != 'Unknown')
          ? 'https://maps.apple.com/?q=$lat,$lon'
          : 'Not available';

      debugPrint('✅ IP location: $city, $region, $country ($ip)');

      return {
        'source':    'IP',
        'accuracy':  'City-level',
        'ip':        ip,
        'isp':       org,
        'timezone':  timezone,
        'lat':       lat,
        'lon':       lon,
        'location':  '$city, $region, $country',
        'mapsLink':  mapsLink,
        'appleMaps': appleMaps,
      };
    } catch (e) {
      debugPrint('❌ IP geolocation failed: $e');
      return _unknownLocation();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // DEVICE / BROWSER HELPERS
  // ─────────────────────────────────────────────────────────────

  String _extractRef() {
    try {
      final uri = Uri.parse(web.window.location.href);
      return uri.queryParameters['ref']
          ?? uri.queryParameters['utm_source']
          ?? uri.queryParameters['utm_campaign']
          ?? 'None';
    } catch (_) {
      return 'None';
    }
  }

  String _deviceInfo() {
    try {
      final ua = web.window.navigator.userAgent;
      if (ua.contains('iPhone'))    return 'iPhone';
      if (ua.contains('iPad'))      return 'iPad';
      if (ua.contains('Android'))   return 'Android';
      if (ua.contains('Macintosh')) return 'Mac Desktop';
      if (ua.contains('Windows'))   return 'Windows Desktop';
      if (ua.contains('Linux'))     return 'Linux Desktop';
      return 'Desktop';
    } catch (_) {
      return 'Unknown';
    }
  }

  String _browserInfo() {
    try {
      final ua = web.window.navigator.userAgent;
      if (ua.contains('Edg'))     return 'Edge';
      if (ua.contains('OPR'))     return 'Opera';
      if (ua.contains('Firefox')) return 'Firefox';
      if (ua.contains('Chrome'))  return 'Chrome';
      if (ua.contains('Safari'))  return 'Safari';
      return 'Unknown';
    } catch (_) {
      return 'Unknown';
    }
  }

  String _referrerInfo() {
    try {
      final ref = web.document.referrer;
      if (ref.isEmpty)                                        return 'Direct / Typed URL';
      if (ref.contains('instagram'))                         return 'Instagram';
      if (ref.contains('linkedin'))                          return 'LinkedIn';
      if (ref.contains('github'))                            return 'GitHub';
      if (ref.contains('twitter') || ref.contains('x.com')) return 'Twitter/X';
      if (ref.contains('google'))                            return 'Google Search';
      return ref;
    } catch (_) {
      return 'Unknown';
    }
  }

  String _screenSize() {
    try {
      final w = web.window.screen.width;
      final h = web.window.screen.height;
      return '${w}x$h';
    } catch (_) {
      return 'Unknown';
    }
  }

  String _language() {
    try {
      return web.window.navigator.language;
    } catch (_) {
      return 'Unknown';
    }
  }

  // ─────────────────────────────────────────────────────────────
  // EMAIL BODY BUILDER
  // ─────────────────────────────────────────────────────────────
  String _buildMessage({
    required Map<String, String> loc,
    required String instagramRef,
    required String device,
    required String browser,
    required String referrer,
    required String screen,
    required String language,
  }) {
    final source    = loc['source']    ?? 'Unknown';
    final accuracy  = loc['accuracy']  ?? 'Unknown';
    final location  = loc['location']  ?? 'Unknown';
    final ip        = loc['ip']        ?? 'N/A';
    final isp       = loc['isp']       ?? 'N/A';
    final timezone  = loc['timezone']  ?? 'N/A';
    final lat       = loc['lat']       ?? 'Unknown';
    final lon       = loc['lon']       ?? 'Unknown';
    final mapsLink  = loc['mapsLink']  ?? 'Not available';
    final appleMaps = loc['appleMaps'] ?? 'Not available';

    final sourceLabel = source == 'GPS'
        ? 'GPS (Exact — user allowed location)'
        : 'IP  (City-level — GPS denied / unavailable)';

    return '''
==================================
  PORTFOLIO ANALYTICS REPORT
==================================

EVENT      : Portfolio Opened
TIME (UTC) : ${DateTime.now().toUtc()}
PLATFORM   : Flutter Web / Vercel

----------------------------------
  LOCATION
----------------------------------

Source     : $sourceLabel
Accuracy   : $accuracy
Location   : $location
Coords     : $lat, $lon
IP Address : $ip
ISP / Org  : $isp
Timezone   : $timezone

Google Maps: $mapsLink
Apple Maps : $appleMaps

----------------------------------
  VISITOR
----------------------------------

Device     : $device
Browser    : $browser
Screen     : $screen
Language   : $language
Referrer   : $referrer
Ref Param  : $instagramRef

==================================
''';
  }

  // ─────────────────────────────────────────────────────────────
  // EMAILJS SENDER
  // ─────────────────────────────────────────────────────────────
  Future<void> _sendEmail(String message) async {
    try {
      final res = await http.post(
        Uri.parse(_emailProxyUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'type':    'analytics',
          'message': message,
        }),
      );

      if (res.statusCode == 200) {
        debugPrint('✅ Analytics email sent.');
      } else {
        debugPrint('❌ Email proxy ${res.statusCode}: ${res.body}');
      }
    } catch (e) {
      debugPrint('❌ Email proxy failed: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────
  // UNKNOWN LOCATION FALLBACK
  // ─────────────────────────────────────────────────────────────
  Map<String, String> _unknownLocation() => {
    'source':    'Unknown',
    'accuracy':  'Unknown',
    'ip':        'Unknown',
    'isp':       'Unknown',
    'timezone':  'Unknown',
    'lat':       'Unknown',
    'lon':       'Unknown',
    'location':  'Unknown',
    'mapsLink':  'Not available',
    'appleMaps': 'Not available',
  };
}
// ─────────────────────────────────────────────────────────────────────────────
// BACK-TO-TOP BUTTON
// ─────────────────────────────────────────────────────────────────────────────

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
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hovered ? AppColors.accent : AppColors.bgSecondary,
              border: Border.all(
                color: _hovered
                    ? AppColors.accent
                    : AppColors.accent.withOpacity(0.25),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.keyboard_arrow_up_rounded,
              color: _hovered ? AppColors.bgPrimary : AppColors.textPrimary,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}