import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/common_widgets.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _selectedService = '';
  String _selectedBudget  = '';
  bool _submitted = false;
  bool _loading   = false;

  static const _services = [
    'Flutter Mobile App',
    'Flutter Web App',
    'Firebase Integration',
    'Figma to Flutter',
    'Code Review / Bug Fix',
    'Other',
  ];

  static const _budgets = [
    '\$50 – \$200',
    '\$200 – \$500',
    '\$500 – \$1,000',
    '\$1,000+',
  ];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() {
      _loading   = false;
      _submitted = true;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      width: double.infinity,
      color: AppColors.bgSecondary,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 60,
        vertical: 100,
      ),
      child: isMobile
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildInfo(context),
              const SizedBox(height: 48),
              _buildForm(context),
            ])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildInfo(context)),
                const SizedBox(width: 80),
                Expanded(child: _buildForm(context)),
              ],
            ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(width: 32, height: 1, color: AppColors.accent),
          const SizedBox(width: 12),
          const Text("LET'S WORK TOGETHER",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.5,
                color: AppColors.accent,
              )),
        ]),
        const SizedBox(height: 16),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -1.5,
              color: AppColors.textPrimary,
            ),
            children: [
              TextSpan(text: 'Have a project\nin mind'),
              TextSpan(text: '?', style: TextStyle(color: AppColors.accent)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(AppStrings.contactBody,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              height: 1.8,
              color: AppColors.textMuted,
            )),
        const SizedBox(height: 40),
        // Contact links
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContactLinkRow(
              icon: '📧',
              label: AppStrings.email,
              onTap: () =>
                  launchUrl(Uri.parse('mailto:${AppStrings.email}')),
            ),
            const SizedBox(height: 16),
            ContactLinkRow(
              icon: '💼',
              label: 'fiverr.com/farooq_sarwar',
              onTap: () => launchUrl(Uri.parse(AppStrings.fiverrUrl)),
            ),
            const SizedBox(height: 16),
            ContactLinkRow(
              icon: '🐙',
              label: 'github.com/Farooqsarwar',
              onTap: () => launchUrl(Uri.parse(AppStrings.githubUrl)),
            ),
            const SizedBox(height: 16),
            ContactLinkRow(
              icon: '💼',
              label: 'linkedin.com/in/farooqsarwar',
              onTap: () => launchUrl(Uri.parse(AppStrings.linkedinUrl)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    if (_submitted) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.fiverr.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.fiverr.withOpacity(0.25)),
        ),
        child: const Text(
          AppStrings.formSuccess,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.fiverr,
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Email row
          Row(
            children: [
              Expanded(
                child: _FormField(
                  label: 'Your Name',
                  hint: 'John Doe',
                  controller: _nameCtrl,
                  validator: (v) =>
                      v!.isEmpty ? 'Name is required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _FormField(
                  label: 'Email Address',
                  hint: 'john@email.com',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      !v!.contains('@') ? 'Valid email required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Service dropdown
          _DropdownField(
            label: 'Service Needed',
            hint: 'Select a service...',
            items: _services,
            value: _selectedService,
            onChanged: (v) => setState(() => _selectedService = v ?? ''),
          ),
          const SizedBox(height: 20),

          // Budget dropdown
          _DropdownField(
            label: 'Budget Range',
            hint: 'Select budget...',
            items: _budgets,
            value: _selectedBudget,
            onChanged: (v) => setState(() => _selectedBudget = v ?? ''),
          ),
          const SizedBox(height: 20),

          // Message
          _FormField(
            label: 'Message',
            hint: 'Tell me about your project...',
            controller: _messageCtrl,
            maxLines: 5,
            validator: (v) =>
                v!.isEmpty ? 'Message is required' : null,
          ),
          const SizedBox(height: 28),

          // Submit
          GestureDetector(
            onTap: _loading ? null : _submit,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 36, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.3),
                    blurRadius: 24,
                  )
                ],
              ),
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.bgPrimary,
                      ),
                    )
                  : const Text(
                      'Send Message →',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.bgPrimary,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  State<_FormField> createState() => _FormFieldState();
}

class _FormFieldState extends State<_FormField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.8,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: TextFormField(
            controller: widget.controller,
            maxLines: widget.maxLines,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
              filled: true,
              fillColor: AppColors.bgTertiary,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.accent, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.8,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          hint: Text(hint,
              style:
                  const TextStyle(color: AppColors.textMuted, fontSize: 14)),
          dropdownColor: AppColors.bgTertiary,
          style: const TextStyle(
              color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.bgTertiary,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.accent, width: 1),
            ),
          ),
          items: items
              .map((i) => DropdownMenuItem(
                    value: i,
                    child: Text(i),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
