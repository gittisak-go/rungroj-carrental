import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/magic_link_auth_service.dart';

class MagicLinkBookingDialog extends StatefulWidget {
  final VoidCallback onAuthSuccess;

  const MagicLinkBookingDialog({super.key, required this.onAuthSuccess});

  @override
  State<MagicLinkBookingDialog> createState() => _MagicLinkBookingDialogState();
}

class _MagicLinkBookingDialogState extends State<MagicLinkBookingDialog> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = MagicLinkAuthService();

  bool _isLoading = false;
  bool _linkSent = false;
  bool _isAuthenticating = false;
  String? _errorMessage;
  String? _detectedRole;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    // If already authenticated, proceed immediately
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _authService.upsertUserRole();
        if (mounted) {
          Navigator.of(context).pop();
          widget.onAuthSuccess();
        }
      });
      return;
    }
    // Listen for Magic Link callback (user clicks link in email)
    _authSubscription = _authService.authStateChanges.listen(
      _onAuthStateChange,
    );
  }

  void _onAuthStateChange(AuthState state) async {
    if (state.event == AuthChangeEvent.signedIn && state.session != null) {
      if (!mounted) return;
      setState(() => _isAuthenticating = true);

      // Upsert role in Supabase profiles table
      final role = await _authService.upsertUserRole();

      if (!mounted) return;
      setState(() => _isAuthenticating = false);

      Navigator.of(context).pop();
      widget.onAuthSuccess();

      // Show role-specific welcome snackbar
      if (mounted) {
        final email = _authService.currentUser?.email ?? '';
        _showWelcomeSnackbar(context, role, email);
      }
    }
  }

  void _showWelcomeSnackbar(BuildContext ctx, String role, String email) {
    final isSuperAdmin = role == 'Super_Admin';
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuperAdmin ? Icons.admin_panel_settings : Icons.person_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isSuperAdmin
                    ? 'ยินดีต้อนรับ Super Admin 👑'
                    : 'เข้าสู่ระบบสำเร็จ! สถานะ: User ✅',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: isSuperAdmin
            ? Colors.amber.shade700
            : Colors.green.shade600,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    final email = value.trim().toLowerCase();
    setState(() {
      _detectedRole = email.isNotEmpty
          ? MagicLinkAuthService.getUserRole(email)
          : null;
      _errorMessage = null;
    });
  }

  Future<void> _sendMagicLink() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim().toLowerCase();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.sendMagicLink(email);
      if (mounted) {
        setState(() {
          _linkSent = true;
          _isLoading = false;
        });
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Show authenticating overlay when Magic Link is being processed
    if (_isAuthenticating) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                'กำลังยืนยันตัวตน...',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'กรุณารอสักครู่',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.lock_open_rounded,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'เข้าสู่ระบบเพื่อจอง',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Magic Link ผ่านอีเมล',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (!_linkSent)
                ..._buildEmailForm(theme)
              else
                ..._buildLinkSentState(theme),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEmailForm(ThemeData theme) {
    return [
      Text(
        'กรอกอีเมลของคุณ เราจะส่ง Magic Link ให้คุณเข้าสู่ระบบโดยไม่ต้องใช้รหัสผ่าน',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 16),
      Form(
        key: _formKey,
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          onChanged: _onEmailChanged,
          decoration: InputDecoration(
            labelText: 'อีเมล',
            hintText: 'example@email.com',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: _detectedRole != null
                ? Tooltip(
                    message: 'สถานะ: $_detectedRole',
                    child: Icon(
                      _detectedRole == 'Super_Admin'
                          ? Icons.admin_panel_settings
                          : Icons.person,
                      color: _detectedRole == 'Super_Admin'
                          ? Colors.amber.shade700
                          : theme.colorScheme.primary,
                    ),
                  )
                : null,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'กรุณากรอกอีเมล';
            }
            final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$');
            if (!emailRegex.hasMatch(value.trim())) {
              return 'รูปแบบอีเมลไม่ถูกต้อง';
            }
            return null;
          },
        ),
      ),

      // Role badge
      if (_detectedRole != null) ..._buildRoleBadge(theme),

      // Error message
      if (_errorMessage != null) ..._buildErrorMessage(theme),

      const SizedBox(height: 20),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _sendMagicLink,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(
                  'ส่ง Magic Link',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
        ),
      ),
    ];
  }

  List<Widget> _buildRoleBadge(ThemeData theme) {
    final isSuperAdmin = _detectedRole == 'Super_Admin';
    return [
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSuperAdmin
              ? Colors.amber.withValues(alpha: 0.15)
              : theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSuperAdmin
                ? Colors.amber.shade700
                : theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSuperAdmin ? Icons.admin_panel_settings : Icons.person_rounded,
              size: 16,
              color: isSuperAdmin
                  ? Colors.amber.shade700
                  : theme.colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              isSuperAdmin ? 'สถานะ: Super_Admin 👑' : 'สถานะ: User ✅',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSuperAdmin
                    ? Colors.amber.shade800
                    : theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
      if (!isSuperAdmin) ..._buildUserRoleInfo(theme),
    ];
  }

  List<Widget> _buildUserRoleInfo(ThemeData theme) {
    return [
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 14, color: Colors.blue.shade600),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'อีเมลนี้จะได้รับสิทธิ์ User เมื่อเข้าสู่ระบบ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.blue.shade700,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildErrorMessage(ThemeData theme) {
    return [
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _errorMessage!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildLinkSentState(ThemeData theme) {
    final email = _emailController.text.trim();
    final role = MagicLinkAuthService.getUserRole(email.toLowerCase());
    final isSuperAdmin = role == 'Super_Admin';

    return [
      Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read_outlined,
                size: 48,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'ส่ง Magic Link แล้ว!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'กรุณาตรวจสอบอีเมล\n$email\nแล้วคลิกลิงก์เพื่อเข้าสู่ระบบ',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            // Role assignment info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSuperAdmin
                    ? Colors.amber.withValues(alpha: 0.1)
                    : Colors.blue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSuperAdmin
                      ? Colors.amber.shade300
                      : Colors.blue.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSuperAdmin
                        ? Icons.admin_panel_settings
                        : Icons.person_rounded,
                    size: 16,
                    color: isSuperAdmin
                        ? Colors.amber.shade700
                        : Colors.blue.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isSuperAdmin
                        ? 'จะได้รับสิทธิ์ Super_Admin 👑'
                        : 'จะได้รับสิทธิ์ User ✅',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSuperAdmin
                          ? Colors.amber.shade800
                          : Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  _linkSent = false;
                  _emailController.clear();
                  _detectedRole = null;
                });
              },
              child: const Text('ส่งอีกครั้ง'),
            ),
          ],
        ),
      ),
    ];
  }
}
