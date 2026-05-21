import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});
  @override State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _selectedService = '';
  String _selectedBudget = '';
  bool _submitted = false;
  bool _loading = false;

  static const _services = [
    'Flutter Mobile App', 'Flutter Web App', 'Firebase Integration',
    'Figma to Flutter', 'Code Review / Bug Fix', 'Custom Offer', 'Other',
  ];

  static const _budgets = [
    '\$50 – \$200', '\$200 – \$500', '\$500 – \$1,000', '\$1,000+', 'Custom Budget',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  // Unified safe email sending using EmailJS for ALL platforms
  Future<void> _sendEmail(String name, String email, String fullMessage) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': 'service_c7aeuz7',
          'template_id': 'template_wfs38ef',
          'user_id': 'hf3o9gLowcQS6Lpj_',
          'template_params': {
            'from_name': name,
            'from_email': email,
            'message': fullMessage,
            'to_email': 'farooqsarwar953@gmail.com',
            'reply_to': email,
          },
        }),
      );
      if (response.statusCode != 200) throw Exception('EmailJS failed');
    } catch (e) {
      // Formspree fallback (Make sure to replace 'your_form_id' with your actual Formspree ID if you want to use this)
      final fallbackResponse = await http.post(
        Uri.parse('https://formspree.io/f/your_form_id'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: json.encode({
          'name': name, 'email': email, 'message': fullMessage,
          '_replyto': email, '_subject': 'Portfolio Contact Form: Message from $name',
        }),
      );
      if (fallbackResponse.statusCode != 200) throw Exception('All email methods failed');
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();
    setState(() => _loading = true);
    final fullMessage =
        'Service Needed: ${_selectedService.isEmpty ? "Not Selected" : _selectedService}\n'
        'Budget: ${_selectedBudget.isEmpty ? "Not Selected" : _selectedBudget}\n\n'
        'Message:\n${_messageCtrl.text.trim()}';
    try {
      await _sendEmail(_nameCtrl.text.trim(), _emailCtrl.text.trim(), fullMessage);
      setState(() => _submitted = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send message. Please email me directly.'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Container(
      width: double.infinity,
      color: AppColors.bgSecondary,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60, vertical: 100),
      child: isMobile
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildInfo(), const SizedBox(height: 48), _buildForm(),
      ])
          : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _buildInfo()),
        const SizedBox(width: 80),
        Expanded(child: _buildForm()),
      ]),
    );
  }

  Widget _buildInfo() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 28, height: 1.5, decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.6), borderRadius: BorderRadius.circular(1))),
        const SizedBox(width: 12),
        Text("LET'S WORK TOGETHER", style: GoogleFonts.spaceMono(
            fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 3.5, color: AppColors.accent)),
      ]),
      const SizedBox(height: 24),
      RichText(text: TextSpan(
        style: GoogleFonts.syne(fontSize: 42, fontWeight: FontWeight.w800,
            height: 1.1, letterSpacing: -1.5, color: AppColors.textPrimary),
        children: const [
          TextSpan(text: 'Have a project\nin mind'),
          TextSpan(text: '?', style: TextStyle(color: AppColors.accent)),
        ],
      )),
      const SizedBox(height: 20),
      Text(AppStrings.contactBody, style: GoogleFonts.inter(
          fontSize: 15, fontWeight: FontWeight.w300, height: 1.85, color: AppColors.textMuted)),
      const SizedBox(height: 36),

      // Selectable text only for email
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border.withOpacity(0.3)),
        ),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: const Color(0xFFEA4335).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Image.network('https://img.icons8.com/color/96/gmail-new.png', width: 18, height: 18, fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(Icons.email_rounded, size: 16, color: const Color(0xFFEA4335).withOpacity(0.7)))),
          ),
          const SizedBox(width: 12),
          Expanded(child: SelectableText('farooqsarwar953@gmail.com', style: GoogleFonts.inter(
              fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary))),
          const Tooltip(
            message: 'Highlight to copy',
            child: Icon(Icons.text_fields_rounded, size: 14, color: AppColors.textMuted),
          ),
        ]),
      ),
      const SizedBox(height: 10),

      _ContactLink(
          iconUrl: 'https://img.icons8.com/ios-filled/96/1dbf73/fiverr.png',
          fallback: Icons.work_rounded, color: const Color(0xFF1DBF73),
          label: 'fiverr.com/farooq_sarwar',
          onTap: () => launchUrl(Uri.parse(AppStrings.fiverrUrl))),
      const SizedBox(height: 10),
      _ContactLink(
          iconUrl: 'https://img.icons8.com/color/96/github.png',
          fallback: Icons.code_rounded, color: const Color(0xFF6E5494),
          label: 'github.com/Farooqsarwar',
          onTap: () => launchUrl(Uri.parse(AppStrings.githubUrl))),
      const SizedBox(height: 10),
      _ContactLink(
          iconUrl: 'https://img.icons8.com/color/96/linkedin.png',
          fallback: Icons.business_center_rounded, color: const Color(0xFF0A66C2),
          label: 'linkedin.com/in/farooq-sarwar',
          onTap: () => launchUrl(Uri.parse('https://www.linkedin.com/in/farooq-sarwar--/'))),
    ]);
  }

  Widget _buildForm() {
    if (_submitted) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.accent.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accent.withOpacity(0.2)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.check_circle_rounded, size: 48, color: AppColors.accent),
          const SizedBox(height: 16),
          Text('Message Sent!', style: GoogleFonts.syne(
              fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text("I'll get back to you within 24 hours.", textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted, height: 1.6)),
        ]),
      );
    }

    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: _FormField(label: 'Your Name', hint: 'John Doe',
              controller: _nameCtrl, validator: (v) => v!.isEmpty ? 'Required' : null)),
          const SizedBox(width: 16),
          Expanded(child: _FormField(label: 'Email Address', hint: 'john@email.com',
              controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
              validator: (v) => !v!.contains('@') ? 'Valid email required' : null)),
        ]),
        const SizedBox(height: 20),
        _DropdownField(label: 'Service Needed', hint: 'Select a service...',
            items: _services, value: _selectedService,
            onChanged: (v) => setState(() => _selectedService = v ?? '')),
        const SizedBox(height: 20),
        _DropdownField(label: 'Budget Range', hint: 'Select budget...',
            items: _budgets, value: _selectedBudget,
            onChanged: (v) => setState(() => _selectedBudget = v ?? '')),
        const SizedBox(height: 20),
        _FormField(label: 'Message', hint: 'Tell me about your project...',
            controller: _messageCtrl, maxLines: 5,
            validator: (v) => v!.isEmpty ? 'Required' : null),
        const SizedBox(height: 28),

        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _loading ? null : _submit,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 6))],
              ),
              child: Center(child: _loading
                  ? const SizedBox(width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.bgPrimary))
                  : Text('Send Message →', style: GoogleFonts.inter(
                  fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.bgPrimary))),
            ),
          ),
        ),
      ]),
    );
  }
}

// ── Contact Link ────────────────────────────────────────────

class _ContactLink extends StatefulWidget {
  final String iconUrl, label;
  final IconData fallback;
  final Color color;
  final VoidCallback onTap;
  const _ContactLink({required this.iconUrl, required this.fallback, required this.color, required this.label, required this.onTap});
  @override State<_ContactLink> createState() => _ContactLinkState();
}

class _ContactLinkState extends State<_ContactLink> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _h ? widget.color.withOpacity(0.06) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _h ? widget.color.withOpacity(0.2) : AppColors.border.withOpacity(0.3)),
          ),
          child: Row(children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: widget.color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Center(child: Image.network(widget.iconUrl, width: 18, height: 18, fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(widget.fallback, size: 16, color: widget.color.withOpacity(0.7)))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(widget.label, style: GoogleFonts.inter(
                fontSize: 13, fontWeight: FontWeight.w500, color: _h ? widget.color : AppColors.textMuted),
                overflow: TextOverflow.ellipsis)),
            Icon(Icons.arrow_outward_rounded, size: 14, color: _h ? widget.color : AppColors.textMuted.withOpacity(0.3)),
          ]),
        ),
      ),
    );
  }
}

// ── Form Field ──────────────────────────────────────────────

class _FormField extends StatelessWidget {
  final String label, hint;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const _FormField({required this.label, required this.hint, required this.controller,
    this.maxLines = 1, this.keyboardType, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(), style: GoogleFonts.spaceMono(
          fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.8, color: AppColors.textMuted)),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller, maxLines: maxLines, keyboardType: keyboardType, validator: validator,
        style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: AppColors.textMuted.withOpacity(0.5), fontSize: 14),
          filled: true, fillColor: AppColors.bgTertiary,
          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: maxLines > 1 ? 16 : 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accent, width: 1.5)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent)),
        ),
      ),
    ]);
  }
}

// ── Dropdown Field ──────────────────────────────────────────

class _DropdownField extends StatelessWidget {
  final String label, hint;
  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;
  const _DropdownField({required this.label, required this.hint, required this.items,
    required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(), style: GoogleFonts.spaceMono(
          fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.8, color: AppColors.textMuted)),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        hint: Text(hint, style: GoogleFonts.inter(color: AppColors.textMuted.withOpacity(0.5), fontSize: 14)),
        dropdownColor: AppColors.bgTertiary,
        style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14),
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textMuted.withOpacity(0.5)),
        decoration: InputDecoration(
          filled: true, fillColor: AppColors.bgTertiary,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accent, width: 1.5)),
        ),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
        onChanged: onChanged,
      ),
    ]);
  }
}