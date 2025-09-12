import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../widgets/common_widgets.dart';

class ContactSection extends StatefulWidget {
  final bool isMobile;
  final bool isTablet;
  final double screenWidth;

  ContactSection({
    Key? key,
    required this.isMobile,
    required this.isTablet,
    required this.screenWidth,
  }) : super(key: key);

  @override
  _ContactSectionState createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendEmailWeb(BuildContext context, String name, String email, String message) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Method 1: Using EmailJS with proper error handling
      try {
        final response = await http.post(
          Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'service_id': 'service_c7aeuz7', // Replace with your EmailJS service ID
            'template_id': 'template_wfs38ef', // Replace with your EmailJS template ID
            'user_id': 'hf3o9gLowcQS6Lpj_', // Replace with your EmailJS user ID
            // 'accessToken': 'your_private_key', // Only if using private key (optional)
            'template_params': {
              'from_name': name,
              'from_email': email,
              'message': message,
              'to_email': 'farooqsarwar953@gmail.com',
              'reply_to': email,
            },
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Message sent successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          _nameController.clear();
          _emailController.clear();
          _messageController.clear();
          return;
        } else {
          print('EmailJS Error: ${response.statusCode} - ${response.body}');
          throw Exception('EmailJS failed: ${response.statusCode}');
        }
      } catch (emailJsError) {
        print('EmailJS failed, trying fallback method: $emailJsError');

        // Method 2: Fallback to Formspree or similar service
        final fallbackResponse = await http.post(
          Uri.parse('https://formspree.io/f/your_form_id'), // Replace with your Formspree form ID
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            'name': name,
            'email': email,
            'message': message,
            '_replyto': email,
            '_subject': 'Portfolio Contact Form: Message from $name',
          }),
        );

        if (fallbackResponse.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Message sent successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          _nameController.clear();
          _emailController.clear();
          _messageController.clear();
          return;
        } else {
          throw Exception('All email methods failed');
        }
      }
    } catch (e) {
      // Method 3: Ultimate fallback - show contact info
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'Message Ready',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unable to send email automatically. Please copy this information and send manually:',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 16),
                SelectableText(
                  'To: farooqsarwar953@gmail.com\n'
                      'From: $name ($email)\n'
                      'Subject: Portfolio Contact Form\n\n'
                      'Message:\n$message',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Copy to clipboard
                  Clipboard.setData(ClipboardData(
                    text: 'To: farooqsarwar953@gmail.com\n'
                        'From: $name ($email)\n'
                        'Subject: Portfolio Contact Form\n\n'
                        'Message:\n$message',
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Message copied to clipboard')),
                  );
                },
                child: Text('Copy', style: TextStyle(color: Color(0xFF00D4FF))),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendEmailMobile(BuildContext context, String name, String email, String message) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Use mailer for mobile/desktop
      final smtpServer = gmail('farooqsarwar953@gmail.com', 'fcbc utuy ebnf kzpm');
      final emailMessage = Message()
        ..from = Address(email, name)
        ..recipients.add('farooqsarwar953@gmail.com')
        ..subject = 'Portfolio Contact Form: Message from $name'
        ..text = 'From: $name ($email)\n\nMessage:\n$message';

      await send(emailMessage, smtpServer);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form only after successful send
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    HapticFeedback.mediumImpact();

    if (kIsWeb) {
      await _sendEmailWeb(
        context,
        _nameController.text.trim(),
        _emailController.text.trim(),
        _messageController.text.trim(),
      );
    } else {
      await _sendEmailMobile(
        context,
        _nameController.text.trim(),
        _emailController.text.trim(),
        _messageController.text.trim(),
      );
    }
  }

  Widget _buildContactField(
      String label,
      TextEditingController controller,
      bool isMobile,
      bool isTablet, {
        int maxLines = 1,
        TextInputType? keyboardType,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required';
            }
            if (label.contains('Email')) {
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                return 'Please enter a valid email address';
              }
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF00D4FF), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            hintText: maxLines > 1 ? 'Write your message here...' : 'Enter your $label',
            hintStyle: TextStyle(color: Colors.grey[500]),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 12,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getHorizontalPadding(widget.isMobile, widget.isTablet),
        vertical: getVerticalPadding(widget.isMobile, widget.isTablet),
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildSectionTitle('Get In Touch', widget.isMobile, widget.isTablet),
                SizedBox(height: 60),
                widget.isMobile
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContactField(
                      'Your Name',
                      _nameController,
                      widget.isMobile,
                      widget.isTablet,
                    ),
                    SizedBox(height: 20),
                    _buildContactField(
                      'Email Address',
                      _emailController,
                      widget.isMobile,
                      widget.isTablet,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    _buildContactField(
                      'Your Message',
                      _messageController,
                      widget.isMobile,
                      widget.isTablet,
                      maxLines: 5,
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF00D4FF),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: Colors.grey[600],
                        ),
                        child: _isLoading
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(
                          'Send Message',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connect With Me',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildSocialButton(
                              Icons.code,
                              Color(0xFF00D4FF),
                              'GitHub',
                              'https://github.com/farooqsarwar',
                            ),
                            SizedBox(width: 12),
                            buildSocialButton(
                              Icons.work,
                              Color(0xFF0077B5),
                              'LinkedIn',
                              'https://linkedin.com/in/farooqsarwar',
                            ),
                            SizedBox(width: 12),
                            buildSocialButton(
                              Icons.email,
                              Color(0xFFEA4335),
                              'Email',
                              'mailto:farooqsarwar953@gmail.com',
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Contact Information',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16),
                        buildContactInfoItem(Icons.location_on, 'Islamabad, Pakistan'),
                        SizedBox(height: 12),
                        buildContactInfoItem(Icons.email, 'farooqsarwar953@gmail.com'),
                        SizedBox(height: 12),
                      ],
                    ),
                  ],
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Send me a message',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildContactField(
                            'Your Name',
                            _nameController,
                            widget.isMobile,
                            widget.isTablet,
                          ),
                          SizedBox(height: 20),
                          _buildContactField(
                            'Email Address',
                            _emailController,
                            widget.isMobile,
                            widget.isTablet,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 20),
                          _buildContactField(
                            'Your Message',
                            _messageController,
                            widget.isMobile,
                            widget.isTablet,
                            maxLines: 5,
                          ),
                          SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _sendEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF00D4FF),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                disabledBackgroundColor: Colors.grey[600],
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                                  : Text(
                                'Send Message',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 60),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connect With Me',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              buildSocialButton(
                                Icons.code,
                                Color(0xFF00D4FF),
                                'GitHub',
                                'https://github.com/farooqsarwar',
                              ),
                              SizedBox(width: 12),
                              buildSocialButton(
                                Icons.work,
                                Color(0xFF0077B5),
                                'LinkedIn',
                                'https://linkedin.com/in/farooqsarwar',
                              ),
                              SizedBox(width: 12),
                              buildSocialButton(
                                Icons.email,
                                Color(0xFFEA4335),
                                'Email',
                                'mailto:farooqsarwar953@gmail.com',
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Text(
                            'Contact Information',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          buildContactInfoItem(Icons.location_on, 'Lahore, Punjab, Pakistan'),
                          SizedBox(height: 12),
                          buildContactInfoItem(Icons.email, 'farooqsarwar953@gmail.com'),
                          SizedBox(height: 12),
                          buildContactInfoItem(Icons.phone, '03165874183'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}