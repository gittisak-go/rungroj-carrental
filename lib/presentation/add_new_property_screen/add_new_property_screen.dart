import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/dsl_colors.dart';

/// Page 7: Add New Property — A form to input new property details and upload photos
class AddNewPropertyScreen extends StatefulWidget {
  const AddNewPropertyScreen({super.key});

  @override
  State<AddNewPropertyScreen> createState() => _AddNewPropertyScreenState();
}

class _AddNewPropertyScreenState extends State<AddNewPropertyScreen> {
  final _carNameController = TextEditingController();
  final _plateController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelYearController = TextEditingController();

  String _selectedTransmission = 'อัตโนมัติ';
  String _selectedFuel = 'เบนซิน';
  String _selectedSeats = '5';
  String _selectedCategory = 'Sedan';

  final List<String> _transmissions = ['อัตโนมัติ', 'ธรรมดา'];
  final List<String> _fuels = ['เบนซิน', 'ดีเซล', 'ไฟฟ้า', 'ไฮบริด'];
  final List<String> _seatCounts = ['2', '4', '5', '7', '8'];
  final List<String> _categories = [
    'Sedan',
    'SUV',
    'MPV',
    'Sports',
    'Luxury',
    'Van'
  ];

  @override
  void dispose() {
    _carNameController.dispose();
    _plateController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _brandController.dispose();
    _modelYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DslColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DslColors.spacingLg,
                vertical: DslColors.spacingMd,
              ),
              decoration: const BoxDecoration(
                color: DslColors.surface,
                border: Border(
                  bottom: BorderSide(color: DslColors.divider, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: DslColors.primaryText, size: 20),
                  ),
                  Text(
                    'ลงประกาศเช่ารถ',
                    style: GoogleFonts.urbanist(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: DslColors.primaryText,
                      height: 1.2,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline_rounded,
                        color: DslColors.secondaryText, size: 22),
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(DslColors.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Photo upload section
                    _SectionHeader(title: 'รูปภาพรถยนต์'),
                    const SizedBox(height: DslColors.spacingMd),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: DslColors.surface,
                        borderRadius:
                            BorderRadius.circular(DslColors.radiusLg),
                        border: Border.all(
                            color: DslColors.divider,
                            width: 2,
                            style: BorderStyle.solid),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x260066FF),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                'https://dimg.dreamflow.cloud/v1/image/luxury+white+sedan+car+side+view+modern+studio+lighting',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: DslColors.surface,
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      color: DslColors.primary)),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: DslColors.surface,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add_photo_alternate_rounded,
                                      color: DslColors.secondaryText, size: 40),
                                  const SizedBox(height: DslColors.spacingSm),
                                  Text(
                                    'แตะเพื่ออัปโหลดรูปภาพ',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: DslColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: DslColors.spacingMd,
                            right: DslColors.spacingMd,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: DslColors.primary,
                                  borderRadius: BorderRadius.circular(
                                      DslColors.radiusFull),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.add_photo_alternate_rounded,
                                        color: Colors.white, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      'เพิ่มรูปภาพ',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingXl),

                    // Car info section
                    _SectionHeader(title: 'ข้อมูลรถยนต์'),
                    const SizedBox(height: DslColors.spacingMd),
                    _FormField(
                      label: 'ชื่อรุ่นรถ',
                      hint: 'เช่น Toyota Camry 2.5V',
                      controller: _carNameController,
                      icon: Icons.directions_car_rounded,
                    ),
                    const SizedBox(height: DslColors.spacingMd),
                    Row(
                      children: [
                        Expanded(
                          child: _FormField(
                            label: 'ยี่ห้อ',
                            hint: 'Toyota',
                            controller: _brandController,
                            icon: Icons.local_offer_rounded,
                          ),
                        ),
                        const SizedBox(width: DslColors.spacingMd),
                        Expanded(
                          child: _FormField(
                            label: 'ปีรถ',
                            hint: '2023',
                            controller: _modelYearController,
                            icon: Icons.calendar_today_rounded,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DslColors.spacingMd),
                    _FormField(
                      label: 'ทะเบียนรถ',
                      hint: 'กข 1234 กรุงเทพมหานคร',
                      controller: _plateController,
                      icon: Icons.badge_rounded,
                    ),
                    const SizedBox(height: DslColors.spacingXl),

                    // Specs section
                    _SectionHeader(title: 'ข้อมูลจำเพาะ'),
                    const SizedBox(height: DslColors.spacingMd),

                    // Category chips
                    Text(
                      'ประเภทรถ',
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: DslColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingSm),
                    Wrap(
                      spacing: DslColors.spacingSm,
                      runSpacing: DslColors.spacingSm,
                      children: _categories.map((c) {
                        final selected = c == _selectedCategory;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = c),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? DslColors.primary
                                  : DslColors.surface,
                              borderRadius: BorderRadius.circular(
                                  DslColors.radiusFull),
                              border: Border.all(
                                color: selected
                                    ? DslColors.primary
                                    : DslColors.divider,
                              ),
                            ),
                            child: Text(
                              c,
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: selected
                                    ? Colors.white
                                    : DslColors.secondaryText,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: DslColors.spacingMd),

                    // Transmission + fuel
                    Row(
                      children: [
                        Expanded(
                          child: _DropdownField(
                            label: 'เกียร์',
                            value: _selectedTransmission,
                            items: _transmissions,
                            onChanged: (v) =>
                                setState(() => _selectedTransmission = v!),
                          ),
                        ),
                        const SizedBox(width: DslColors.spacingMd),
                        Expanded(
                          child: _DropdownField(
                            label: 'เชื้อเพลิง',
                            value: _selectedFuel,
                            items: _fuels,
                            onChanged: (v) =>
                                setState(() => _selectedFuel = v!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DslColors.spacingMd),
                    _DropdownField(
                      label: 'จำนวนที่นั่ง',
                      value: _selectedSeats,
                      items: _seatCounts,
                      onChanged: (v) =>
                          setState(() => _selectedSeats = v!),
                    ),
                    const SizedBox(height: DslColors.spacingXl),

                    // Pricing section
                    _SectionHeader(title: 'ราคาเช่า'),
                    const SizedBox(height: DslColors.spacingMd),
                    _FormField(
                      label: 'ราคาต่อวัน (บาท)',
                      hint: '3,200',
                      controller: _priceController,
                      icon: Icons.payments_rounded,
                      keyboardType: TextInputType.number,
                      suffix: Text(
                        'บาท/วัน',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: DslColors.secondaryText,
                        ),
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingXl),

                    // Description
                    _SectionHeader(title: 'รายละเอียดเพิ่มเติม'),
                    const SizedBox(height: DslColors.spacingMd),
                    TextField(
                      controller: _descController,
                      maxLines: 4,
                      style: GoogleFonts.poppins(
                        color: DslColors.primaryText,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'อธิบายจุดเด่นของรถ สภาพรถ อุปกรณ์เสริม...',
                        hintStyle: GoogleFonts.poppins(
                            color: DslColors.hint, fontSize: 14),
                        filled: true,
                        fillColor: DslColors.surface,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(DslColors.radiusMd),
                          borderSide:
                              const BorderSide(color: DslColors.divider),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(DslColors.radiusMd),
                          borderSide:
                              const BorderSide(color: DslColors.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(DslColors.radiusMd),
                          borderSide: const BorderSide(
                              color: DslColors.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingXl),

                    // Submit button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DslColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(DslColors.radiusLg),
                        ),
                        elevation: 0,
                        shadowColor: const Color(0x260066FF),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_rounded, size: 20),
                          const SizedBox(width: DslColors.spacingSm),
                          Text(
                            'ลงประกาศ',
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingMd),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: DslColors.secondaryText,
                        side: const BorderSide(color: DslColors.divider),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(DslColors.radiusLg),
                        ),
                      ),
                      child: Text(
                        'บันทึกเป็นร่าง',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: DslColors.spacingXl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: DslColors.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: DslColors.spacingSm),
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: DslColors.primaryText,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: DslColors.secondaryText,
          ),
        ),
        const SizedBox(height: DslColors.spacingXs),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(
              color: DslColors.primaryText, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.poppins(color: DslColors.hint, fontSize: 14),
            prefixIcon: Icon(icon, color: DslColors.secondaryText, size: 20),
            suffixText: null,
            suffix: suffix,
            filled: true,
            fillColor: DslColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DslColors.radiusMd),
              borderSide: const BorderSide(color: DslColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DslColors.radiusMd),
              borderSide: const BorderSide(color: DslColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DslColors.radiusMd),
              borderSide:
                  const BorderSide(color: DslColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: DslColors.secondaryText,
          ),
        ),
        const SizedBox(height: DslColors.spacingXs),
        DropdownButtonFormField<String>(
          initialValue: value,
          onChanged: onChanged,
          dropdownColor: DslColors.surface,
          style: GoogleFonts.poppins(
              color: DslColors.primaryText, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: DslColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DslColors.radiusMd),
              borderSide: const BorderSide(color: DslColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DslColors.radiusMd),
              borderSide: const BorderSide(color: DslColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DslColors.radiusMd),
              borderSide:
                  const BorderSide(color: DslColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
          ),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
