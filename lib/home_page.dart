import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sections/hero_section.dart';
import 'sections/about_section.dart';
import 'sections/skills_section.dart';
import 'sections/projects_section.dart';
import 'sections/education_section.dart';
import 'sections/contact_section.dart';
import 'sections/footer_section.dart';
import 'widgets/common_widgets.dart';

class PortfolioHomePage extends StatefulWidget {
  @override
  _PortfolioHomePageState createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatingAnimation;

  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  // Global keys for scrolling to sections
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutQuart),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 100;
      });
    });

    _fadeController.forward();
    _slideController.forward();
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _floatingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
    HapticFeedback.lightImpact();
    // Close drawer after navigation on mobile
    if (MediaQuery.of(context!).size.width < 600) {
      Navigator.of(context!).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return Scaffold(
      backgroundColor: Color(0xFF0A0E27),
      endDrawer: isMobile ? _buildMobileDrawer() : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(isMobile, isTablet, screenWidth),
          SliverToBoxAdapter(
            child: Column(
              children: [
                HeroSection(
                  fadeAnimation: _fadeAnimation,
                  slideAnimation: _slideAnimation,
                  floatingAnimation: _floatingAnimation,
                  isMobile: isMobile,
                  isTablet: isTablet,
                  screenWidth: screenWidth,
                ),
                AboutSection(
                  key: _aboutKey,
                  isMobile: isMobile,
                  isTablet: isTablet,
                  screenWidth: screenWidth,
                ),
                SkillsSection(
                  key: _skillsKey,
                  isMobile: isMobile,
                  isTablet: isTablet,
                  screenWidth: screenWidth,
                ),
                ProjectsSection(
                  key: _projectsKey,
                  isMobile: isMobile,
                  isTablet: isTablet,
                  screenWidth: screenWidth,
                ),
                EducationSection(
                  key: _educationKey,
                  isMobile: isMobile,
                  isTablet: isTablet,
                  screenWidth: screenWidth,
                ),
                ContactSection(
                  key: _contactKey,
                  isMobile: isMobile,
                  isTablet: isTablet,
                  screenWidth: screenWidth,
                ),
                FooterSection(isMobile: isMobile),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _isScrolled
          ? FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: Color(0xFF00D4FF),
        child: Icon(Icons.keyboard_arrow_up, color: Colors.white),
      )
          : null,
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      backgroundColor: Color(0xFF0A0E27),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Drawer Header
              Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF00D4FF).withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.code,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Farooq Sarwar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Flutter Developer',
                      style: TextStyle(
                        color: Color(0xFF00D4FF),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Navigation Items
              Expanded(
                child: Column(
                  children: [
                    _buildDrawerItem(
                      icon: Icons.person_outline,
                      title: 'About',
                      onTap: () => _scrollToSection(_aboutKey),
                    ),
                    _buildDrawerItem(
                      icon: Icons.star_outline,
                      title: 'Skills',
                      onTap: () => _scrollToSection(_skillsKey),
                    ),
                    _buildDrawerItem(
                      icon: Icons.work_outline,
                      title: 'Projects',
                      onTap: () => _scrollToSection(_projectsKey),
                    ),
                    _buildDrawerItem(
                      icon: Icons.school_outlined,
                      title: 'Education',
                      onTap: () => _scrollToSection(_educationKey),
                    ),
                    _buildDrawerItem(
                      icon: Icons.contact_mail_outlined,
                      title: 'Contact',
                      onTap: () => _scrollToSection(_contactKey),
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Divider(color: Colors.white24),
                    SizedBox(height: 16),
                    Text(
                      '© Farooq Sarwar',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00D4FF).withOpacity(0.2),
                Color(0xFF0099CC).withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Color(0xFF00D4FF).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: Color(0xFF00D4FF),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hoverColor: Color(0xFF00D4FF).withOpacity(0.1),
        splashColor: Color(0xFF00D4FF).withOpacity(0.2),
      ),
    );
  }

  Widget _buildAppBar(bool isMobile, bool isTablet, double screenWidth) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: _isScrolled
          ? Color(0xFF0A0E27).withOpacity(0.95)
          : Colors.transparent,
      flexibleSpace: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: _isScrolled
              ? LinearGradient(
            colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          boxShadow: _isScrolled
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ]
              : null,
        ),
      ),
      title: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF00D4FF).withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.code, color: Colors.white, size: isMobile ? 18 : 20),
          ),
          SizedBox(width: 12),
          Text(
            'Farooq Sarwar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: isMobile ? 16 : 18,
            ),
          ),
        ],
      ),
      actions: isMobile
          ? [
        Builder(
          builder: (context) => IconButton(
            icon: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.menu,
                color: Colors.white,
                size: 20,
              ),
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
              HapticFeedback.lightImpact();
            },
          ),
        ),
        SizedBox(width: 8),
      ]
          : [
        _buildNavButton('About', () => _scrollToSection(_aboutKey)),
        _buildNavButton('Skills', () => _scrollToSection(_skillsKey)),
        _buildNavButton('Projects', () => _scrollToSection(_projectsKey)),
        _buildNavButton('Education', () => _scrollToSection(_educationKey)),
        _buildNavButton('Contact', () => _scrollToSection(_contactKey)),
        SizedBox(width: 20),
      ],
    );
  }

  Widget _buildNavButton(String text, VoidCallback onPressed) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white70,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}