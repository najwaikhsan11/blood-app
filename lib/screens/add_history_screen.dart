import 'dart:convert';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/api_service.dart';

class AddHistoryScreen extends StatefulWidget {
  const AddHistoryScreen({super.key});

  @override
  State<AddHistoryScreen> createState() => _AddHistoryScreenState();
}

class _AddHistoryScreenState extends State<AddHistoryScreen> {
  String _jenisDonor = 'Donor Darah Lengkap';
  final TextEditingController _catatanController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _banyakDarahController = TextEditingController(text: '350 ml');

  bool _isInit = true;
  Map<String, dynamic>? _editItem;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        _editItem = args;
        _tanggalController.text = args['tanggal_donor'] ?? '';
        
        final ketStr = args['keterangan'];
        if (ketStr != null) {
          try {
            final Map<String, dynamic> ket = jsonDecode(ketStr);
            _lokasiController.text = ket['lokasi'] ?? '';
            _banyakDarahController.text = ket['banyak_darah'] ?? '350 ml';
            _jenisDonor = ket['jenis_donor'] ?? 'Donor Darah Lengkap';
            _catatanController.text = ket['catatan'] ?? '';
          } catch (_) {
            _lokasiController.text = ketStr;
          }
        }
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _catatanController.dispose();
    _tanggalController.dispose();
    _lokasiController.dispose();
    _banyakDarahController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final tanggal = _tanggalController.text.trim();
    final lokasi = _lokasiController.text.trim();
    final banyakDarah = _banyakDarahController.text.trim();
    final catatan = _catatanController.text.trim();

    if (tanggal.isEmpty || lokasi.isEmpty || banyakDarah.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Field bertanda * wajib diisi')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> result;
    if (_editItem != null) {
      result = await ApiService.updateRiwayat(
        _editItem!['_id'],
        tanggal: tanggal,
        lokasi: lokasi,
        banyakDarah: banyakDarah,
        jenisDonor: _jenisDonor,
        catatan: catatan,
      );
    } else {
      result = await ApiService.addRiwayat(
        tanggal: tanggal,
        lokasi: lokasi,
        banyakDarah: banyakDarah,
        jenisDonor: _jenisDonor,
        catatan: catatan,
      );
    }

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Riwayat berhasil disimpan')),
        );
        Navigator.of(context).pop(true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal menyimpan riwayat'),
            backgroundColor: AppColors.primaryRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editItem != null;
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
        title: Text(
          isEditing ? 'Ubah Riwayat Donor' : 'Tambah Riwayat Donor',
          style: const TextStyle(
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
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _tanggalController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                          });
                        }
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
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            final options = ['250 ml', '350 ml', '450 ml', '500 ml'];
                            return ListView(
                              shrinkWrap: true,
                              children: options.map((opt) => ListTile(
                                title: Text(opt),
                                onTap: () {
                                  setState(() {
                                    _banyakDarahController.text = opt;
                                  });
                                  Navigator.pop(context);
                                },
                              )).toList(),
                            );
                          }
                        );
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
                                  'Minimal Jarak antar donor darah adalah 3/4 bulan tergantung jenis kelamin pendonor.',
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
                onPressed: _isLoading ? null : _handleSave,
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
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
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
