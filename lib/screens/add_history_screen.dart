import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AddHistoryScreen extends StatefulWidget {
  const AddHistoryScreen({super.key});

  @override
  State<AddHistoryScreen> createState() => _AddHistoryScreenState();
}

class _AddHistoryScreenState extends State<AddHistoryScreen> {
  String _jenisDonor = 'Donor Darah Lengkap';
  final TextEditingController _catatanController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController(text: '7 Mei 2026');
  final TextEditingController _lokasiController = TextEditingController(text: 'PMI Kota Bandung');
  final TextEditingController _banyakDarahController = TextEditingController(text: '500 ml');

  @override
  void dispose() {
    _catatanController.dispose();
    _tanggalController.dispose();
    _lokasiController.dispose();
    _banyakDarahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tambah Riwayat Donor',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Info Banner ───────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.chat_bubble_outline, color: AppColors.primaryRed, size: 24),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Lengkapi data donor Anda sesuai kondisi saat melakukan donor darah',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Form Fields ───────────────────────────────────
                    _buildLabel('Tanggal Donor *'),
                    _buildTextField(
                      controller: _tanggalController,
                      readOnly: true,
                      suffixIcon: Icons.keyboard_arrow_down,
                      prefixIcon: Icons.calendar_today_outlined,
                      onTap: () {
                        // Show Date Picker
                      },
                    ),

                    const SizedBox(height: 16),
                    _buildLabel('Lokasi Donor *'),
                    _buildTextField(
                      controller: _lokasiController,
                    ),

                    const SizedBox(height: 16),
                    _buildLabel('Banyak Darah *'),
                    _buildTextField(
                      controller: _banyakDarahController,
                      readOnly: true,
                      suffixIcon: Icons.keyboard_arrow_down,
                      onTap: () {
                        // Show Dropdown
                      },
                    ),

                    const SizedBox(height: 16),
                    _buildLabel('Jenis Donor'),
                    Row(
                      children: [
                        _buildRadioOption('Donor Darah Lengkap'),
                      ],
                    ),
                    Row(
                      children: [
                        _buildRadioOption('Donor Apheresis'),
                      ],
                    ),

                    const SizedBox(height: 16),
                    _buildLabel('Catatan (Opsional)'),
                    TextField(
                      controller: _catatanController,
                      maxLines: 4,
                      maxLength: 200,
                      decoration: InputDecoration(
                        hintText: 'Contoh: kondisi saat donor, dll',
                        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryRed),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Warning Banner ────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: AppColors.primaryRed, size: 24),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Peringatan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Minimal Jarak antar donor darah adalah 3 bulan untuk pria dan 4 bulan untuk wanita',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // ── Submit Button ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  // Save logic
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 0,
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    bool readOnly = false,
    IconData? suffixIcon,
    IconData? prefixIcon,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.black54, size: 20) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.black54, size: 20) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryRed),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _jenisDonor = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _jenisDonor,
              activeColor: AppColors.primaryRed,
              onChanged: (String? newValue) {
                setState(() {
                  _jenisDonor = newValue!;
                });
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
