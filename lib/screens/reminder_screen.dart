import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import '../services/api_service.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool _isLoading = true;
  String _remainingDaysText = '-';
  String _estimationDateText = 'Belum ada riwayat donor';
  
  // Settings loaded from SharedPreferences
  bool _isReminderOn = true;
  String _reminderDays = '3 Hari Sebelum';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    _isReminderOn = prefs.getBool('isReminderOn') ?? true;
    _reminderDays = prefs.getString('reminderDays') ?? '3 Hari Sebelum';

    final res = await ApiService.getDonorDetail();
    if (res['success'] == true) {
      final data = res['data'];
      final riwayat = data['riwayat'] as List? ?? [];
      
      if (riwayat.isNotEmpty) {
        final sortedRiwayat = List.from(riwayat);
        sortedRiwayat.sort((a, b) {
          final t1 = a['tanggal_donor'] ?? '';
          final t2 = b['tanggal_donor'] ?? '';
          return t2.compareTo(t1);
        });

        final latestTgl = sortedRiwayat.first['tanggal_donor'];
        if (latestTgl != null) {
          try {
            final parsed = DateTime.parse(latestTgl);
            final isFemale = (data['jenis_kelamin'] ?? '').toLowerCase() == 'perempuan';
            final diffDays = isFemale ? 120 : 90;
            final nextDate = parsed.add(Duration(days: diffDays));
            final now = DateTime.now();
            
            if (nextDate.isAfter(now)) {
              final remainingDays = nextDate.difference(now).inDays;
              _remainingDaysText = "$remainingDays Hari Lagi";
              _estimationDateText = "Estimasi tanggal: ${nextDate.day} ${_monthName(nextDate.month)} ${nextDate.year}";
            } else {
              _remainingDaysText = "Siap Donor";
              _estimationDateText = "Anda sudah siap untuk mendonorkan darah!";
            }
          } catch (_) {
            _remainingDaysText = "-";
            _estimationDateText = "Format tanggal salah";
          }
        }
      } else {
        _remainingDaysText = "Siap Donor";
        _estimationDateText = "Belum ada riwayat donor, Anda siap donor kapan saja.";
      }
    } else {
      _remainingDaysText = "-";
      _estimationDateText = "Gagal mengambil data";
    }

    setState(() {
      _isLoading = false;
    });
  }

  String _monthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
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
          'Peringatan Donor',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              AppColors.primaryRed.withOpacity(0.15),
              AppColors.primaryRed.withOpacity(0.25),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryRed))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ── Alarm Clock Icon ────────────────────────────────
                            Center(
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryRed.withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.alarm,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // ── Main Text ───────────────────────────────────────
                            const Text(
                              'Donor berikutnya',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _remainingDaysText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryRed,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _estimationDateText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 40),

                            // ── Info Card 1 ─────────────────────────────────────
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.notifications_none, color: Colors.black87, size: 20),
                                      SizedBox(width: 12),
                                      Text(
                                        'Kenapa ada peringatan donor?',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Donor darah secara rutin setiap 3 bulan (pria) atau 4 bulan (wanita) bermanfaat bagi kesehatan Anda dan membantu menyelamatkan nyawa orang lain.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // ── Settings Card ───────────────────────────────────
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                leading: const Icon(Icons.notifications_none, color: Colors.black87),
                                title: const Text(
                                  'Atur Peringatan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  _isReminderOn
                                      ? 'Aktif • $_reminderDays sebelum jadwal'
                                      : 'Nonaktif',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right, color: Colors.black87),
                                onTap: () async {
                                  await Navigator.of(context).pushNamed('/reminder_settings');
                                  _loadData();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Submit Button ─────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ElevatedButton(
                        onPressed: () {
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
                          'Selesai',
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
      ),
    );
  }
}
