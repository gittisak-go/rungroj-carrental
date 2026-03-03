import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/payment_card_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_menu_item_widget.dart';
import './widgets/profile_section_widget.dart';
import './widgets/toggle_menu_item_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _biometricEnabled = false;

  // Mock user data with Thai localization
  final Map<String, dynamic> _userData = {
    "name": "Patteera Sunatrai",
    "email": "Patty_patteera19@hotmail.com",
    "phone": "086 634 8619",
    "membershipStatus": "CEO (Chief Executive Officer)",
    "profileImage": "assets/images/ceo-1767538725333.jpg",
    "emergencyContacts": [
      {
        "name": "John Johnson",
        "phone": "+1 (555) 987-6543",
        "relation": "คู่สมรส",
      },
      {
        "name": "Emily Johnson",
        "phone": "+1 (555) 456-7890",
        "relation": "พี่สาว",
      },
    ],
    "paymentMethods": [
      {"type": "Visa", "lastFour": "4532", "isDefault": true},
      {"type": "Mastercard", "lastFour": "8901", "isDefault": false},
      {"type": "American Express", "lastFour": "2345", "isDefault": false},
    ],
    "preferences": {
      "vehicleType": "สะดวกสบาย",
      "autoTip": "15%",
      "pickupInstructions": "กรุณาโทรหาเมื่อมาถึง",
    },
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: theme.colorScheme.onSurface,
            size: 5.w,
          ),
        ),
        title: Text(
          'โปรไฟล์ของฉัน',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showEditProfileDialog,
            icon: CustomIconWidget(
              iconName: 'edit',
              color: theme.colorScheme.primary,
              size: 5.w,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2.h),

            // Profile Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ProfileHeaderWidget(
                userName: _userData["name"] as String,
                userEmail: _userData["email"] as String,
                membershipStatus: _userData["membershipStatus"] as String,
                profileImageUrl: _userData["profileImage"] as String,
                onEditProfile: _showEditProfileDialog,
              ),
            ),

            SizedBox(height: 4.h),

            // Personal Information Section
            ProfileSectionWidget(
              title: 'ข้อมูลส่วนตัว',
              children: [
                ProfileMenuItemWidget(
                  icon: 'person',
                  title: 'แก้ไขโปรไฟล์',
                  subtitle: 'อัปเดตข้อมูลส่วนตัวของคุณ',
                  onTap: _showEditProfileDialog,
                ),
                ProfileMenuItemWidget(
                  icon: 'phone',
                  title: 'หมายเลขโทรศัพท์',
                  subtitle: _userData["phone"] as String,
                  onTap: _showPhoneEditDialog,
                ),
                ProfileMenuItemWidget(
                  icon: 'email',
                  title: 'อีเมล',
                  subtitle: _userData["email"] as String,
                  onTap: _showEmailEditDialog,
                ),
              ],
            ),

            // Preferences Section
            ProfileSectionWidget(
              title: 'การตั้งค่า',
              children: [
                ToggleMenuItemWidget(
                  icon: 'dark_mode',
                  title: 'โหมดมืด',
                  subtitle: 'เปลี่ยนระหว่างธีมสว่างและมืด',
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() => _isDarkMode = value);
                    HapticFeedback.lightImpact();
                  },
                ),
                ToggleMenuItemWidget(
                  icon: 'notifications',
                  title: 'การแจ้งเตือน',
                  subtitle: 'รับการอัปเดตการเดินทางและโปรโมชั่น',
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() => _notificationsEnabled = value);
                    HapticFeedback.lightImpact();
                  },
                ),
                ToggleMenuItemWidget(
                  icon: 'location_on',
                  title: 'บริการตำแหน่ง',
                  subtitle: 'อนุญาตให้เข้าถึงตำแหน่งเพื่อบริการที่ดีขึ้น',
                  value: _locationEnabled,
                  onChanged: (value) {
                    setState(() => _locationEnabled = value);
                    HapticFeedback.lightImpact();
                  },
                ),
                ProfileMenuItemWidget(
                  icon: 'language',
                  title: 'ภาษา',
                  subtitle: 'ภาษาไทย',
                  onTap: _showLanguageDialog,
                ),
              ],
            ),

            // Payment Methods Section
            ProfileSectionWidget(
              title: 'วิธีการชำระเงิน',
              showDivider: false,
              children: [
                ...((_userData["paymentMethods"] as List)
                    .map(
                      (card) => PaymentCardWidget(
                        cardType: card["type"] as String,
                        lastFourDigits: card["lastFour"] as String,
                        isDefault: card["isDefault"] as bool,
                        onTap: () => _showCardDetailsDialog(card),
                        onDelete: () => _showDeleteCardDialog(card),
                      ),
                    )
                    .toList()),
                ProfileMenuItemWidget(
                  icon: 'add',
                  title: 'เพิ่มวิธีการชำระเงิน',
                  subtitle: 'เพิ่มบัตรหรือวิธีการชำระเงินใหม่',
                  onTap: _showAddPaymentDialog,
                  iconColor: theme.colorScheme.primary,
                ),
              ],
            ),

            // Ride Preferences Section
            ProfileSectionWidget(
              title: 'ความต้องการการเดินทาง',
              children: [
                ProfileMenuItemWidget(
                  icon: 'directions_car',
                  title: 'ประเภทยานพาหนะเริ่มต้น',
                  subtitle: (_userData["preferences"] as Map)["vehicleType"]
                      as String,
                  onTap: _showVehicleTypeDialog,
                ),
                ProfileMenuItemWidget(
                  icon: 'attach_money',
                  title: 'ทิปอัตโนมัติ',
                  subtitle:
                      (_userData["preferences"] as Map)["autoTip"] as String,
                  onTap: _showTipDialog,
                ),
                ProfileMenuItemWidget(
                  icon: 'note',
                  title: 'คำแนะนำการรับ',
                  subtitle: (_userData["preferences"]
                      as Map)["pickupInstructions"] as String,
                  onTap: _showInstructionsDialog,
                ),
              ],
            ),

            // Safety Section
            ProfileSectionWidget(
              title: 'ความปลอดภัยและความปลอดภัย',
              children: [
                ProfileMenuItemWidget(
                  icon: 'emergency',
                  title: 'ผู้ติดต่อฉุกเฉิน',
                  subtitle:
                      'เพิ่มผู้ติดต่อฉุกเฉิน ${(_userData["emergencyContacts"] as List).length} ราย',
                  onTap: _showEmergencyContactsDialog,
                ),
                ToggleMenuItemWidget(
                  icon: 'fingerprint',
                  title: 'การยืนยันตัวตนด้วยไบอเมตริกซ์',
                  subtitle: 'ใช้ลายนิ้วมือหรือ Face ID สำหรับการชำระเงิน',
                  value: _biometricEnabled,
                  onChanged: (value) {
                    setState(() => _biometricEnabled = value);
                    HapticFeedback.lightImpact();
                  },
                ),
                ProfileMenuItemWidget(
                  icon: 'security',
                  title: 'การตั้งค่าความเป็นส่วนตัว',
                  subtitle: 'จัดการข้อมูลและความเป็นส่วนตัวของคุณ',
                  onTap: _showPrivacyDialog,
                ),
              ],
            ),

            // Support Section
            ProfileSectionWidget(
              title: 'ฝ่ายสนับสนุน',
              children: [
                ProfileMenuItemWidget(
                  icon: 'help',
                  title: 'ศูนย์ช่วยเหลือ',
                  subtitle: 'รับความช่วยเหลือและการสนับสนุน',
                  onTap: _showHelpCenter,
                ),
                ProfileMenuItemWidget(
                  icon: 'feedback',
                  title: 'ส่งคำติชม',
                  subtitle: 'แบ่งปันความคิดเห็นของคุณกับเรา',
                  onTap: _showFeedbackDialog,
                ),
                ProfileMenuItemWidget(
                  icon: 'info',
                  title: 'เกี่ยวกับรุ่งโรจน์คาร์เร้นท์',
                  subtitle: 'เวอร์ชัน 1.0.0',
                  onTap: _showAboutDialog,
                ),
              ],
            ),

            // Account Management Section
            ProfileSectionWidget(
              title: 'บัญชี',
              children: [
                ProfileMenuItemWidget(
                  icon: 'lock',
                  title: 'เปลี่ยนรหัสผ่าน',
                  subtitle: 'อัปเดตรหัสผ่านบัญชีของคุณ',
                  onTap: _showChangePasswordDialog,
                ),
                ProfileMenuItemWidget(
                  icon: 'logout',
                  title: 'ออกจากระบบ',
                  subtitle: 'ออกจากระบบบัญชีของคุณ',
                  onTap: _showLogoutDialog,
                  iconColor: theme.colorScheme.error,
                  showArrow: false,
                ),
                ProfileMenuItemWidget(
                  icon: 'delete_forever',
                  title: 'ลบบัญชี',
                  subtitle: 'ลบบัญชีของคุณอย่างถาวร',
                  onTap: _showDeleteAccountDialog,
                  iconColor: theme.colorScheme.error,
                  showArrow: false,
                ),
              ],
            ),

            SizedBox(height: 10.h), // Extra space for bottom navigation
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        variant: CustomBottomBarVariant.standard,
        currentIndex: 3, // Profile tab
        onTap: (index) {
          HapticFeedback.lightImpact();
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/ride-request-screen',
                (route) => false,
              );
              break;
            case 1:
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/live-tracking-screen',
                (route) => false,
              );
              break;
            case 2:
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/ride-history-screen',
                (route) => false,
              );
              break;
            case 3:
              // Already on profile screen
              break;
          }
        },
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text(
          'ฟังก์ชันการแก้ไขโปรไฟล์จะถูกนำมาใช้ที่นี่พร้อมฟอร์มสำหรับชื่อ อีเมล และอัปโหลดรูปภาพ',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  void _showPhoneEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Phone Number'),
        content: const Text(
          'การยืนยันหมายเลขโทรศัพท์จะถูกนำมาใช้ที่นี่ด้วยการยืนยัน SMS',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            },
            child: const Text('อัปเดต'),
          ),
        ],
      ),
    );
  }

  void _showEmailEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Email Address'),
        content: const Text(
          'ฟังก์ชันการอัปเดตอีเมลจะถูกนำมาใช้ที่นี่ด้วยการยืนยันอีเมล',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            },
            child: const Text('อัปเดต'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('ภาษาไทย'),
              leading: Radio(value: true, groupValue: true, onChanged: null),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('English (US)'),
              leading: Radio(value: false, groupValue: true, onChanged: null),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
        ],
      ),
    );
  }

  void _showCardDetailsDialog(Map<String, dynamic> card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${card["type"]} รายละเอียด'),
        content: Text(
          'บัตรที่ลงท้ายด้วย ${card["lastFour"]}\n\nคุณสมบัติการจัดการบัตรจะถูกนำมาใช้ที่นี่',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
          if (!(card["isDefault"] as bool))
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
              child: const Text('ตั้งเป็นค่าเริ่มต้น'),
            ),
        ],
      ),
    );
  }

  void _showDeleteCardDialog(Map<String, dynamic> card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment Method'),
        content: Text(
          'คุณแน่ใจหรือไม่ว่าต้องการลบ ${card["type"]} ที่ลงท้ายด้วย ${card["lastFour"]}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
  }

  void _showAddPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment Method'),
        content: const Text(
          'การเพิ่มวิธีการชำระเงินจะถูกนำมาใช้ที่นี่ด้วยฟอร์มการป้อนบัตรที่ปลอดภัย',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            },
            child: const Text('เพิ่มบัตร'),
          ),
        ],
      ),
    );
  }

  void _showVehicleTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Vehicle Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('ประหยัด'),
              leading: Radio(
                value: 'ประหยัด',
                groupValue: 'สะดวกสบาย',
                onChanged: null,
              ),
            ),
            ListTile(
              title: const Text('สะดวกสบาย'),
              leading: Radio(
                value: 'สะดวกสบาย',
                groupValue: 'สะดวกสบาย',
                onChanged: null,
              ),
            ),
            ListTile(
              title: const Text('พรีเมียม'),
              leading: Radio(
                value: 'พรีเมียม',
                groupValue: 'สะดวกสบาย',
                onChanged: null,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  void _showTipDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Automatic Tip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('10%'),
              leading: Radio(value: '10%', groupValue: '15%', onChanged: null),
            ),
            ListTile(
              title: const Text('15%'),
              leading: Radio(value: '15%', groupValue: '15%', onChanged: null),
            ),
            ListTile(
              title: const Text('20%'),
              leading: Radio(value: '20%', groupValue: '15%', onChanged: null),
            ),
            ListTile(
              title: const Text('กำหนดเอง'),
              leading: Radio(
                value: 'กำหนดเอง',
                groupValue: '15%',
                onChanged: null,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  void _showInstructionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pickup Instructions'),
        content: const TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'ป้อนคำแนะนำพิเศษสำหรับการรับ...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyContactsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Contacts'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: (_userData["emergencyContacts"] as List).length,
            itemBuilder: (context, index) {
              final contact = (_userData["emergencyContacts"] as List)[index];
              return ListTile(
                title: Text(contact["name"] as String),
                subtitle: Text('${contact["relation"]} • ${contact["phone"]}'),
                trailing: IconButton(
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    color: Theme.of(context).colorScheme.error,
                    size: 5.w,
                  ),
                  onPressed: () {},
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            },
            child: const Text('เพิ่มผู้ติดต่อ'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Settings'),
        content: const Text(
          'การตั้งค่าความเป็นส่วนตัวและการจัดการข้อมูลจะถูกนำมาใช้ที่นี่',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help Center'),
        content: const Text(
          'ศูนย์ช่วยเหลือพร้อม FAQ ติดต่อฝ่ายสนับสนุน และคู่มือการแก้ไขปัญหาจะถูกนำมาใช้ที่นี่',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: const TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'แบ่งปันความคิดและข้อเสนอแนะของคุณ...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            },
            child: const Text('ส่ง'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    Navigator.pushNamed(context, '/about-app-screen');
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'รหัสผ่านปัจจุบัน',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'รหัสผ่านใหม่',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'ยืนยันรหัสผ่านใหม่',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            },
            child: const Text('อัปเดต'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบบัญชีของคุณ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/authentication-screen',
                (route) => false,
              );
              HapticFeedback.lightImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'คุณแน่ใจหรือไม่ว่าต้องการลบบัญชีของคุณอย่างถาวร? การดำเนินการนี้ไม่สามารถยกเลิกได้',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('ลบบัญชี'),
          ),
        ],
      ),
    );
  }
}
