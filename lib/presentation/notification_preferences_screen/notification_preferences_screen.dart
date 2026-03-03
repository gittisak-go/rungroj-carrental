import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/app_notification_model.dart';
import '../../models/notification_preference_model.dart';
import '../../services/notification_preference_service.dart';
import '../../services/realtime_notification_service.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/batch_control_widget.dart';
import './widgets/notification_banner_widget.dart';
import './widgets/notification_inbox_widget.dart';
import './widgets/preference_section_widget.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({Key? key}) : super(key: key);

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  final _service = NotificationPreferenceService();
  final _realtimeService = RealtimeNotificationService.instance;

  List<NotificationPreferenceModel> _preferences = [];
  Map<String, List<NotificationPreferenceModel>> _groupedPreferences = {};
  bool _isLoading = true;
  bool _isSaving = false;
  final Set<String> _loadingPreferences = {};
  String? _errorMessage;
  RealtimeChannel? _realtimeSubscription;

  // Live notification banners queue
  final List<AppNotificationModel> _activeBanners = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _setupRealtimeSubscription();
    _startRealtimeNotifications();
  }

  @override
  void dispose() {
    _realtimeSubscription?.unsubscribe();
    _realtimeService.removeNotificationListener(_onNewNotification);
    _realtimeService.removeUnreadCountListener(_onUnreadCountChanged);
    super.dispose();
  }

  Future<void> _startRealtimeNotifications() async {
    _realtimeService.addNotificationListener(_onNewNotification);
    _realtimeService.addUnreadCountListener(_onUnreadCountChanged);
    await _realtimeService.startListening();
  }

  void _onNewNotification(AppNotificationModel notification) {
    if (!mounted) return;
    setState(() {
      _activeBanners.add(notification);
    });
  }

  void _onUnreadCountChanged(int count) {
    if (mounted) setState(() {});
  }

  void _dismissBanner(AppNotificationModel notification) {
    if (!mounted) return;
    setState(() {
      _activeBanners.remove(notification);
    });
    _realtimeService.markAsRead(notification.id);
  }

  void _setupRealtimeSubscription() {
    final userId = _service.currentUserId;
    if (userId == null) return;

    _realtimeSubscription = _service.subscribeToPreferenceChanges(
      userId: userId,
      onUpdate: _handleRealtimeUpdate,
    );
  }

  void _handleRealtimeUpdate(PostgresChangePayload payload) {
    try {
      final eventType = payload.eventType.toString();
      final newData = payload.newRecord;

      if (eventType == 'PostgresChangeEvent.update' && newData.isNotEmpty) {
        final updatedPreference = NotificationPreferenceModel.fromJson(newData);

        setState(() {
          final index = _preferences.indexWhere(
            (p) => p.id == updatedPreference.id,
          );

          if (index != -1) {
            _preferences[index] = updatedPreference;
            _groupedPreferences = _service.groupPreferencesByCategory(
              _preferences,
            );
          }
        });

        _showRealtimeSyncSnackBar('Preferences synced from another device');
      } else if (eventType == 'PostgresChangeEvent.insert' &&
          newData.isNotEmpty) {
        final newPreference = NotificationPreferenceModel.fromJson(newData);

        setState(() {
          _preferences.add(newPreference);
          _groupedPreferences = _service.groupPreferencesByCategory(
            _preferences,
          );
        });
      }
    } catch (e) {
      debugPrint('Error handling realtime update: $e');
    }
  }

  void _showRealtimeSyncSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.sync, color: Colors.white, size: 18.sp),
            SizedBox(width: 3.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _loadPreferences() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await _service.getUserPreferences();
      final grouped = _service.groupPreferencesByCategory(prefs);

      setState(() {
        _preferences = prefs;
        _groupedPreferences = grouped;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _togglePreference(
    NotificationPreferenceModel preference,
    bool newValue,
  ) async {
    setState(() => _loadingPreferences.add(preference.id));

    try {
      final updated = await _service.togglePreference(preference.id, newValue);

      setState(() {
        final index = _preferences.indexWhere((p) => p.id == preference.id);
        if (index != -1) {
          _preferences[index] = updated;
          _groupedPreferences = _service.groupPreferencesByCategory(
            _preferences,
          );
        }
        _loadingPreferences.remove(preference.id);
      });

      _showSuccessSnackBar('Preference updated successfully');
    } catch (e) {
      setState(() => _loadingPreferences.remove(preference.id));
      _showErrorSnackBar('Failed to update preference: $e');
    }
  }

  Future<void> _enableAllNotifications() async {
    final confirm = await _showConfirmDialog(
      'เปิดการแจ้งเตือนทั้งหมด',
      'คุณแน่ใจหรือไม่ว่าต้องการเปิดการแจ้งเตือนทุกประเภท?',
    );

    if (confirm != true) return;

    setState(() => _isSaving = true);

    try {
      await _service.enableAllNotifications();
      await _loadPreferences();
      _showSuccessSnackBar('เปิดการแจ้งเตือนทั้งหมดแล้ว');
    } catch (e) {
      _showErrorSnackBar('ไม่สามารถเปิดการแจ้งเตือน: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _disableAllNotifications() async {
    final confirm = await _showConfirmDialog(
      'ปิดการแจ้งเตือนทั้งหมด',
      'คุณแน่ใจหรือไม่ว่าต้องการปิดการแจ้งเตือนทุกประเภท? คุณจะไม่ได้รับการแจ้งเตือนใดๆ',
    );

    if (confirm != true) return;

    setState(() => _isSaving = true);

    try {
      await _service.disableAllNotifications();
      await _loadPreferences();
      _showSuccessSnackBar('ปิดการแจ้งเตือนทั้งหมดแล้ว');
    } catch (e) {
      _showErrorSnackBar('ไม่สามารถปิดการแจ้งเตือน: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<bool?> _showConfirmDialog(String title, String message) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
            ),
            child: const Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 3.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            SizedBox(width: 3.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        variant: CustomAppBarVariant.standard,
        title: 'การตั้งค่าการแจ้งเตือน',
        showBackButton: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.blue.shade700,
                  size: 22.sp,
                ),
                onPressed: () {
                  _realtimeService.markAllAsRead();
                  setState(() {});
                },
              ),
              if (_realtimeService.unreadCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${_realtimeService.unreadCount > 9 ? '9+' : _realtimeService.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                  ),
                )
              : _errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(5.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 30.sp,
                              color: Colors.red.shade400,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'ไม่สามารถโหลดการตั้งค่าได้',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              _errorMessage!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 3.h),
                            ElevatedButton.icon(
                              onPressed: _loadPreferences,
                              icon: const Icon(Icons.refresh),
                              label: const Text('ลองอีกครั้ง'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 1.5.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadPreferences,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Real-time status indicator
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(10.0),
                                border:
                                    Border.all(color: Colors.green.shade200),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 2.w,
                                    height: 2.w,
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade600,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'การแจ้งเตือนแบบเรียลไทม์ทำงานอยู่',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.wifi,
                                    size: 14.sp,
                                    color: Colors.green.shade600,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),

                            // Notification Inbox
                            const NotificationInboxWidget(),
                            SizedBox(height: 2.h),

                            BatchControlWidget(
                              onEnableAll: _enableAllNotifications,
                              onDisableAll: _disableAllNotifications,
                              isLoading: _isSaving,
                            ),
                            SizedBox(height: 3.h),

                            // Section header
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.tune,
                                    size: 16.sp,
                                    color: Colors.grey.shade700,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'ส่วนตั้งค่าการแจ้งเตือน',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),

                            PreferenceSectionWidget(
                              title: 'การแจ้งเตือนการจอง',
                              icon: Icons.event_note,
                              preferences: _groupedPreferences[
                                      'Booking Notifications'] ??
                                  [],
                              onToggle: _togglePreference,
                              loadingPreferences: _loadingPreferences,
                            ),
                            PreferenceSectionWidget(
                              title: 'การแจ้งเตือนการชำระเงิน',
                              icon: Icons.payment,
                              preferences: _groupedPreferences[
                                      'Payment Notifications'] ??
                                  [],
                              onToggle: _togglePreference,
                              loadingPreferences: _loadingPreferences,
                            ),
                            PreferenceSectionWidget(
                              title: 'การสื่อสารกับคนขับ',
                              icon: Icons.directions_car,
                              preferences:
                                  _groupedPreferences['Driver Communication'] ??
                                      [],
                              onToggle: _togglePreference,
                              loadingPreferences: _loadingPreferences,
                            ),
                            PreferenceSectionWidget(
                              title: 'การตลาดและอัปเดต',
                              icon: Icons.campaign,
                              preferences:
                                  _groupedPreferences['Marketing & Updates'] ??
                                      [],
                              onToggle: _togglePreference,
                              loadingPreferences: _loadingPreferences,
                            ),
                            SizedBox(height: 2.h),
                            Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.blue.shade700,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Text(
                                      'การเปลี่ยนแปลงจะบันทึกโดยอัตโนมัติ การแจ้งเตือนแบบเรียลไทม์จะส่งทันทีสำหรับความพร้อมใช้งานรถ การยืนยันการจอง และอัปเดตสถานะการเช่า',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.blue.shade900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 3.h),
                          ],
                        ),
                      ),
                    ),

          // Floating notification banners overlay
          if (_activeBanners.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Column(
                  children: _activeBanners
                      .take(3)
                      .map(
                        (banner) => NotificationBannerWidget(
                          key: ValueKey(banner.id),
                          notification: banner,
                          onDismiss: () => _dismissBanner(banner),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
