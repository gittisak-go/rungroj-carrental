import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/dsl_colors.dart';

/// Page 9: Settings — User profile and notification preferences
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifyNewBooking = true;
  bool _notifyPayment = true;
  bool _notifyMaintenance = false;
  bool _notifyPromotion = true;
  bool _darkMode = true;
  bool _biometric = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DslColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DslColors.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: DslColors.surface,
                      borderRadius:
                          BorderRadius.circular(DslColors.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x260066FF),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: DslColors.primaryText, size: 20),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: DslColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'R',
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: DslColors.spacingSm),
                      Text(
                        'บัญชีของฉัน',
                        style: GoogleFonts.urbanist(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: DslColors.primaryText,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert_rounded,
                        color: DslColors.primaryText, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Profile card
              Container(
                padding: const EdgeInsets.all(DslColors.spacingLg),
                decoration: BoxDecoration(
                  color: DslColors.surface,
                  borderRadius: BorderRadius.circular(DslColors.radiusLg),
                  border: Border.all(color: DslColors.divider),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x260066FF),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Avatar
                        Stack(
                          children: [
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                color: DslColors.secondary.withAlpha(30),
                                borderRadius:
                                    BorderRadius.circular(DslColors.radiusLg),
                                border: Border.all(
                                    color: DslColors.secondary, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  'ก',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    color: DslColors.secondary,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: DslColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: DslColors.spacingLg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'กิตติพงษ์ วงศ์รุ่งเรือง',
                                style: GoogleFonts.urbanist(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: DslColors.primaryText,
                                  height: 1.2,
                                ),
                              ),
                              Text(
                                'เจ้าของรถเช่า',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: DslColors.secondaryText,
                                ),
                              ),
                              const SizedBox(height: DslColors.spacingXs),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: DslColors.success.withAlpha(26),
                                  borderRadius: BorderRadius.circular(
                                      DslColors.radiusFull),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.verified_rounded,
                                        color: DslColors.success, size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                      'ยืนยันแล้ว',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: DslColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                        color: DslColors.divider,
                        height: DslColors.spacingLg * 2),
                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ProfileStat(label: 'รถทั้งหมด', value: '12'),
                        _ProfileStat(label: 'การเช่า', value: '234'),
                        _ProfileStat(label: 'เรตติ้ง', value: '4.9★'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Contact info section
              _SettingsSection(
                title: 'ข้อมูลติดต่อ',
                items: [
                  _SettingsItem(
                    icon: Icons.phone_rounded,
                    iconBg: DslColors.success.withAlpha(26),
                    iconColor: DslColors.success,
                    label: 'เบอร์โทรศัพท์',
                    value: '+66 81-234-5678',
                    trailing: const Icon(Icons.edit_rounded,
                        color: DslColors.primary, size: 18),
                  ),
                  _SettingsItem(
                    icon: Icons.email_rounded,
                    iconBg: DslColors.primary.withAlpha(26),
                    iconColor: DslColors.primary,
                    label: 'อีเมล',
                    value: 'kittipong@email.com',
                    trailing: const Icon(Icons.edit_rounded,
                        color: DslColors.primary, size: 18),
                  ),
                  _SettingsItem(
                    icon: Icons.location_on_rounded,
                    iconBg: DslColors.secondary.withAlpha(26),
                    iconColor: DslColors.secondary,
                    label: 'ที่อยู่',
                    value: 'กรุงเทพมหานคร',
                    trailing: const Icon(Icons.edit_rounded,
                        color: DslColors.primary, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Notifications section
              _SettingsSectionWidget(
                title: 'การแจ้งเตือน',
                children: [
                  _SwitchTile(
                    icon: Icons.book_online_rounded,
                    iconColor: DslColors.primary,
                    label: 'การจองใหม่',
                    value: _notifyNewBooking,
                    onChanged: (v) =>
                        setState(() => _notifyNewBooking = v),
                  ),
                  _SwitchTile(
                    icon: Icons.payments_rounded,
                    iconColor: DslColors.success,
                    label: 'การชำระเงิน',
                    value: _notifyPayment,
                    onChanged: (v) =>
                        setState(() => _notifyPayment = v),
                  ),
                  _SwitchTile(
                    icon: Icons.build_rounded,
                    iconColor: DslColors.accent,
                    label: 'แจ้งซ่อม',
                    value: _notifyMaintenance,
                    onChanged: (v) =>
                        setState(() => _notifyMaintenance = v),
                  ),
                  _SwitchTile(
                    icon: Icons.local_offer_rounded,
                    iconColor: DslColors.secondary,
                    label: 'โปรโมชั่นและข่าวสาร',
                    value: _notifyPromotion,
                    onChanged: (v) =>
                        setState(() => _notifyPromotion = v),
                  ),
                ],
              ),
              const SizedBox(height: DslColors.spacingLg),

              // App settings
              _SettingsSectionWidget(
                title: 'การตั้งค่าแอป',
                children: [
                  _SwitchTile(
                    icon: Icons.dark_mode_rounded,
                    iconColor: DslColors.hint,
                    label: 'โหมดมืด',
                    value: _darkMode,
                    onChanged: (v) => setState(() => _darkMode = v),
                  ),
                  _SwitchTile(
                    icon: Icons.fingerprint_rounded,
                    iconColor: DslColors.primary,
                    label: 'ลายนิ้วมือ / Face ID',
                    value: _biometric,
                    onChanged: (v) =>
                        setState(() => _biometric = v),
                  ),
                ],
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Other settings
              _SettingsSection(
                title: 'อื่นๆ',
                items: [
                  _SettingsItem(
                    icon: Icons.help_outline_rounded,
                    iconBg: DslColors.primary.withAlpha(26),
                    iconColor: DslColors.primary,
                    label: 'ศูนย์ช่วยเหลือ',
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        color: DslColors.secondaryText, size: 16),
                  ),
                  _SettingsItem(
                    icon: Icons.privacy_tip_outlined,
                    iconBg: DslColors.secondary.withAlpha(26),
                    iconColor: DslColors.secondary,
                    label: 'นโยบายความเป็นส่วนตัว',
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        color: DslColors.secondaryText, size: 16),
                  ),
                  _SettingsItem(
                    icon: Icons.star_outline_rounded,
                    iconBg: DslColors.accent.withAlpha(40),
                    iconColor: DslColors.accent,
                    label: 'ให้คะแนนแอป',
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        color: DslColors.secondaryText, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: DslColors.spacingLg),

              // Logout button
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: Text(
                  'ออกจากระบบ',
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: DslColors.error,
                  side: const BorderSide(color: DslColors.error),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DslColors.radiusLg),
                  ),
                ),
              ),
              const SizedBox(height: DslColors.spacingXl),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.urbanist(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: DslColors.primaryText,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: DslColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String? value;
  final Widget? trailing;

  const _SettingsItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DslColors.spacingMd),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(DslColors.radiusSm),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: DslColors.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: DslColors.primaryText,
                    ),
                  ),
                  if (value != null)
                    Text(
                      value!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: DslColors.secondaryText,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: DslColors.secondaryText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: DslColors.spacingSm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: DslColors.spacingMd),
          decoration: BoxDecoration(
            color: DslColors.surface,
            borderRadius: BorderRadius.circular(DslColors.radiusMd),
            border: Border.all(color: DslColors.divider),
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (_, __) =>
                const Divider(color: DslColors.divider, height: 1),
            itemBuilder: (context, i) => items[i],
          ),
        ),
      ],
    );
  }
}

class _SettingsSectionWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSectionWidget(
      {required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: DslColors.secondaryText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: DslColors.spacingSm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: DslColors.spacingMd),
          decoration: BoxDecoration(
            color: DslColors.surface,
            borderRadius: BorderRadius.circular(DslColors.radiusMd),
            border: Border.all(color: DslColors.divider),
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: children.length,
            separatorBuilder: (_, __) =>
                const Divider(color: DslColors.divider, height: 1),
            itemBuilder: (context, i) => children[i],
          ),
        ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DslColors.spacingMd),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(26),
              borderRadius: BorderRadius.circular(DslColors.radiusSm),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: DslColors.spacingMd),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: DslColors.primaryText,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: DslColors.primary,
            activeTrackColor: DslColors.primary.withAlpha(80),
            inactiveThumbColor: DslColors.hint,
            inactiveTrackColor: DslColors.divider,
          ),
        ],
      ),
    );
  }
}
