import 'package:supabase_flutter/supabase_flutter.dart';
import './supabase_service.dart';

class MagicLinkAuthService {
  final SupabaseClient _client = SupabaseService.instance.client;

  // Super_Admin emails - single source of truth
  static const List<String> superAdminEmails = [
    'gittisakwannakeeree@gmail.com',
    'info@gtsalphamcp.com',
    'director@gtsalphamcp.com',
    'phongwut.w@gmail.com',
  ];

  /// Check if an email belongs to Super_Admin role
  static bool isSuperAdmin(String email) {
    return superAdminEmails.contains(email.toLowerCase().trim());
  }

  /// Determine role from email (client-side, for UI preview only)
  static String getUserRole(String email) {
    if (isSuperAdmin(email.toLowerCase().trim())) {
      return 'Super_Admin';
    }
    return 'User';
  }

  /// Send Magic Link to email
  /// Non-Super_Admin emails get User role assigned automatically after login
  Future<void> sendMagicLink(String email) async {
    await _client.auth.signInWithOtp(
      email: email.toLowerCase().trim(),
      emailRedirectTo: 'https://taxihouse1176.builtwithrocket.new',
    );
  }

  /// Upsert user profile with role after successful Magic Link authentication
  /// Called after auth state changes to SIGNED_IN
  Future<String> upsertUserRole() async {
    final user = _client.auth.currentUser;
    if (user == null) return 'Visitor';

    final email = user.email?.toLowerCase().trim() ?? '';
    final role = getUserRole(email);

    try {
      await _client.from('profiles').upsert({
        'id': user.id,
        'email': email,
        'role': role,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'id');
    } catch (_) {
      // Profile upsert failed silently — role still determined client-side
    }

    return role;
  }

  /// Fetch user role from Supabase profiles table
  Future<String> fetchUserRole() async {
    final user = _client.auth.currentUser;
    if (user == null) return 'Visitor';

    try {
      final response = await _client
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      if (response != null && response['role'] != null) {
        return response['role'] as String;
      }
    } catch (_) {
      // Fallback to client-side role detection
    }

    // Fallback: determine role from email
    final email = user.email?.toLowerCase().trim() ?? '';
    return getUserRole(email);
  }

  /// Get current authenticated user
  User? get currentUser => _client.auth.currentUser;

  /// Check if current user is Super_Admin (client-side check)
  bool get isCurrentUserSuperAdmin {
    final email = currentUser?.email;
    if (email == null) return false;
    return isSuperAdmin(email);
  }

  /// Get current user role (client-side, synchronous)
  String get currentUserRole {
    final email = currentUser?.email;
    if (email == null) return 'Visitor';
    return getUserRole(email);
  }

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Auth state stream
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
