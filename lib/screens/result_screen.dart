import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/api_service.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int _selectedIndex = 1; // "Hasil" tab is active
  bool _isLoading = true;
  String _nama = '';
  String _idUser = '';
  String _gender = '';
  String _age = '';
  String _goldar = '-';
  String _rhesus = '-';
  String _tanggalWaktu = '-';
  String _idAlat = '-';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  String get _displayGoldar {
    if (_goldar == '-' || _goldar.isEmpty) return '-';
    String suffix = '';
    if (_rhesus.toLowerCase().contains('positif') || _rhesus == '+') {
      suffix = '+';
    } else if (_rhesus.toLowerCase().contains('negatif') || _rhesus == '-') {
      suffix = '-';
    }
    if (_goldar.endsWith('+') || _goldar.endsWith('-')) {
      return _goldar;
    }
    return '$_goldar$suffix';
  }

  void _loadData() async {
    final stored = await ApiService.getStoredProfile();
    setState(() {
      _nama = stored['nama_pendonor'] ?? '';
      _idUser = stored['id_user'] ?? '';
    });

    final res = await ApiService.getDonorDetail();
    if (res['success'] == true) {
      final data = res['data'];
      
      String tempGoldar = '-';
      String tempRhesus = '-';
      String tempIdAlat = '-';
      String tempTanggalWaktu = '-';

      final hasil = data['hasil'];
      if (hasil != null && hasil['golongan_darah'] != null && hasil['golongan_darah'] != '-') {
        tempGoldar = hasil['golongan_darah'];
        tempRhesus = hasil['rhesus'] ?? '-';
        tempIdAlat = hasil['id_alat'] ?? '-';
        
        final tglPem = hasil['tanggal_pemeriksaan'];
        if (tglPem != null) {
          try {
            final parsed = DateTime.parse(tglPem);
            tempTanggalWaktu = "${parsed.day} ${_monthName(parsed.month)} ${parsed.year}";
          } catch (_) {
            tempTanggalWaktu = tglPem;
          }
        }
        if (hasil['nama_alat'] != null) {
          tempIdAlat = hasil['nama_alat'];
        }
      }

      String deviceName = tempIdAlat;
      if (tempIdAlat != '-' && tempIdAlat.length == 24) {
        final alatRes = await ApiService.getAlat();
        if (alatRes['success'] == true && alatRes['data'] != null) {
          final List<dynamic> alats = alatRes['data'];
          for (var a in alats) {
            if (a['_id'] == tempIdAlat && a['nama_alat'] != null) {
              deviceName = a['nama_alat'];
              break;
            }
          }
        }
      }

      setState(() {
        _nama = data['nama_pendonor'] ?? _nama;
        _idUser = data['id_user'] ?? _idUser;
        _gender = data['jenis_kelamin'] ?? '';
        final tglLahir = data['tanggal_lahir'];
        if (tglLahir != null) {
          try {
            final dob = DateTime.parse(tglLahir);
            final age = DateTime.now().year - dob.year;
            _age = "$age Tahun";
          } catch (_) {
            _age = '';
          }
        }

        _goldar = tempGoldar;
        _rhesus = tempRhesus;
        _tanggalWaktu = tempTanggalWaktu;
        _idAlat = deviceName;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _monthName(int month) {
    const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── App Bar ──────────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Hasil Pemeriksaan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // Spacer to balance the back button
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ── Scrollable Content ────────────────────────────────────
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primaryRed))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),

                          // ── Patient Info Card ─────────────────────────────
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                // Avatar
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Patient details
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _nama,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'ID: $_idUser',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${_age.isNotEmpty ? "$_age, " : ""}$_gender',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ── Blood Type Result Card ────────────────────────
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 28, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Golongan Darah',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      _displayGoldar,
                                      style: const TextStyle(
                                        fontSize: 72,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryRed,
                                        height: 1.0,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.water_drop,
                                      size: 64,
                                      color: AppColors.primaryRed.withOpacity(0.9),
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 4,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Rhesus',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _rhesus,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ── Detail Info Card ──────────────────────────────
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildDetailRow(
                                  icon: Icons.calendar_today_outlined,
                                  label: 'Tanggal & Waktu',
                                  value: _tanggalWaktu,
                                  showDivider: true,
                                ),
                                _buildDetailRow(
                                  icon: Icons.devices_outlined,
                                  label: 'Nama Alat',
                                  value: _idAlat,
                                  showDivider: false,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ── Save Button ───────────────────────────────────
                          ElevatedButton(
                            onPressed: _onSimpanSelesai,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Simpan & Selesai',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
            ),

            // ── Bottom Navigation Bar ─────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(0, Icons.home, 'Beranda'),
                  _buildNavItem(1, Icons.description_outlined, 'Hasil'),
                  _buildNavItem(2, Icons.calendar_today_outlined, 'Riwayat'),
                  _buildNavItem(3, Icons.local_hospital_outlined, 'Edukasi'),
                  _buildNavItem(4, Icons.person_outline, 'Profile'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper: detail row ────────────────────────────────────────────────────
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primaryRed),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, indent: 20, endIndent: 20),
      ],
    );
  }

  // ── Helper: nav item ──────────────────────────────────────────────────────
  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == _selectedIndex) return;

        if (index == 0) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (index == 1) {
          Navigator.of(context).pushReplacementNamed('/result');
        } else if (index == 2) {
          Navigator.of(context).pushReplacementNamed('/history');
        } else if (index == 3) {
          Navigator.of(context).pushReplacementNamed('/education');
        } else if (index == 4) {
          Navigator.of(context).pushReplacementNamed('/profile');
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      child: isSelected
          ? Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 24),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.black54, size: 24),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ── Action: Simpan & Selesai ──────────────────────────────────────────────
  void _onSimpanSelesai() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Hasil pemeriksaan berhasil disimpan!'),
        backgroundColor: AppColors.primaryRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.of(context).pushReplacementNamed('/home');
    });
  }
}
