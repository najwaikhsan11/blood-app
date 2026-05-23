import 'dart:convert';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedIndex = 2; // "Riwayat" tab is active
  bool _isLoading = true;
  List<dynamic> _historyList = [];
  String _totalDonor = '0x';
  String _lastDonorDate = '-';
  String _nextDonationDays = '-';
  String _nextDonationDate = '-';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final res = await ApiService.getDonorDetail();
    if (res['success'] == true) {
      final data = res['data'];
      final riwayat = data['riwayat'] as List? ?? [];
      
      final sortedRiwayat = List.from(riwayat);
      sortedRiwayat.sort((a, b) {
        final t1 = a['tanggal_donor'] ?? '';
        final t2 = b['tanggal_donor'] ?? '';
        return t2.compareTo(t1);
      });

      setState(() {
        _historyList = sortedRiwayat;
        _totalDonor = '${_historyList.length}x';
        
        if (_historyList.isNotEmpty) {
          final latestTgl = _historyList.first['tanggal_donor'];
          if (latestTgl != null) {
            try {
              final parsed = DateTime.parse(latestTgl);
              _lastDonorDate = "${parsed.day} ${_monthName(parsed.month)} ${parsed.year}";
              
              final isFemale = (data['jenis_kelamin'] ?? '').toLowerCase() == 'perempuan';
              final diffDays = isFemale ? 120 : 90;
              final nextDate = parsed.add(Duration(days: diffDays));
              final now = DateTime.now();
              if (nextDate.isAfter(now)) {
                final remainingDays = nextDate.difference(now).inDays;
                _nextDonationDays = "$remainingDays Hari";
                _nextDonationDate = "Estimasi: ${nextDate.day} ${_monthName(nextDate.month)} ${nextDate.year}";
              } else {
                _nextDonationDays = "0 Hari";
                _nextDonationDate = "Siap Donor Sekarang";
              }
            } catch (_) {
              _lastDonorDate = latestTgl;
            }
          }
        } else {
          _lastDonorDate = '-';
          _nextDonationDays = '-';
          _nextDonationDate = 'Belum ada riwayat';
        }
        
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
                      'Riwayat Donor',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Spacer to balance back button
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

                          // ── Info Banner ───────────────────────────────────
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.bloodtype, color: AppColors.primaryRed, size: 24),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Data riwayat donor di bawah ini diinput secara mandiri oleh Anda',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ── Tambah Riwayat Button ─────────────────────────
                          ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.of(context).pushNamed('/add_history');
                              if (result == true) {
                                _loadData();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              '+ Tambah Riwayat Donor',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ── Ringkasan Card ────────────────────────────────
                          const Text(
                            'Ringkasan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildSummaryItem(
                                  icon: Icons.bloodtype,
                                  value: _totalDonor,
                                  label: 'Total Donor',
                                ),
                                Container(width: 1, height: 40, color: AppColors.primaryRed.withOpacity(0.2)),
                                _buildSummaryItem(
                                  icon: Icons.calendar_today_outlined,
                                  value: _lastDonorDate,
                                  label: 'Donor Terakhir',
                                ),
                                Container(width: 1, height: 40, color: AppColors.primaryRed.withOpacity(0.2)),
                                _buildSummaryItem(
                                  icon: Icons.access_time,
                                  value: _nextDonationDays,
                                  label: 'Menuju Donor\nBerikutnya',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ── Daftar Riwayat Donor ──────────────────────────
                          const Text(
                            'Daftar Riwayat Donor',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          if (_historyList.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.0),
                                child: Text(
                                  'Belum ada riwayat donor.',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                            )
                          else
                            ..._historyList.map((item) {
                              final dateStr = item['tanggal_donor'] ?? '';
                              String dateFormatted = dateStr;
                              try {
                                final parsed = DateTime.parse(dateStr);
                                dateFormatted = "${parsed.day} ${_monthName(parsed.month)} ${parsed.year}";
                              } catch (_) {}

                              String lokasi = '-';
                              String banyakDarah = '-';
                              final ketStr = item['keterangan'];
                              if (ketStr != null) {
                                try {
                                  final Map<String, dynamic> ket = jsonDecode(ketStr);
                                  lokasi = ket['lokasi'] ?? '-';
                                  banyakDarah = ket['banyak_darah'] ?? '-';
                                } catch (_) {
                                  lokasi = ketStr;
                                }
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _buildHistoryCard(
                                  date: dateFormatted,
                                  location: lokasi,
                                  amount: banyakDarah,
                                  onTap: () async {
                                    final res = await Navigator.of(context).pushNamed(
                                      '/history_detail',
                                      arguments: item,
                                    );
                                    if (res == true) {
                                      _loadData();
                                    }
                                  },
                                ),
                              );
                            }).toList(),

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  // ── Helper: Summary Item ──────────────────────────────────────────────────
  Widget _buildSummaryItem({required IconData icon, required String value, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.black87, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // ── Helper: History Card ──────────────────────────────────────────────────
  Widget _buildHistoryCard({
    required String date,
    required String location,
    required String amount,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Placeholder
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bloodtype,
                color: AppColors.primaryRed,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Banyak Darah: $amount',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black87),
          ],
        ),
      ),
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
          // Already here
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
}
