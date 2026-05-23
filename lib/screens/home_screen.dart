import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  String _userName = '';
  String _userId = '';
  String _bloodType = '-';
  String _rhesus = '-';
  String _nextDonationMsg = 'Belum ada riwayat donor';

  String get _bloodTypeDisplay {
    if (_bloodType == '-') return '-';
    final sign = _rhesus.toLowerCase() == 'positif' || _rhesus == '+'
        ? '+'
        : (_rhesus.toLowerCase() == 'negatif' || _rhesus == '-' ? '-' : '');
    if (_bloodType.endsWith('+') || _bloodType.endsWith('-')) {
      return _bloodType;
    }
    return '$_bloodType$sign';
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final stored = await ApiService.getStoredProfile();
    setState(() {
      _userName = stored['nama_pendonor'] ?? '';
      _userId = stored['id_user'] ?? '';
    });

    final res = await ApiService.getDonorDetail();
    if (res['success'] == true) {
      final data = res['data'];
      setState(() {
        _userName = data['nama_pendonor'] ?? _userName;
        _userId = data['id_user'] ?? _userId;
        final hasil = data['hasil'];
        if (hasil != null) {
          _bloodType = hasil['golongan_darah'] ?? '-';
          _rhesus = hasil['rhesus'] ?? '-';
        }
        
        final riwayat = data['riwayat'] as List?;
        if (riwayat != null && riwayat.isNotEmpty) {
          DateTime? latestDate;
          for (var item in riwayat) {
            final tgl = item['tanggal_donor'];
            if (tgl != null) {
              try {
                final parsed = DateTime.parse(tgl);
                if (latestDate == null || parsed.isAfter(latestDate)) {
                  latestDate = parsed;
                }
              } catch (_) {
                // Ignore parsing errors for custom string formats
              }
            }
          }
          
          if (latestDate != null) {
            final isFemale = (data['jenis_kelamin'] ?? '').toLowerCase() == 'perempuan';
            final diffDays = isFemale ? 120 : 90;
            final nextDate = latestDate.add(Duration(days: diffDays));
            final now = DateTime.now();
            if (nextDate.isAfter(now)) {
              final remainingDays = nextDate.difference(now).inDays;
              _nextDonationMsg = "Dapat dilakukan pada ${nextDate.year}-${nextDate.month.toString().padLeft(2, '0')}-${nextDate.day.toString().padLeft(2, '0')} ($remainingDays Hari Lagi)";
            } else {
              _nextDonationMsg = "Anda sudah memenuhi syarat waktu untuk donor berikutnya!";
            }
          }
        }
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 1.0],
            colors: [
              Colors.white,
              Color(0xFFD65B5B), // Soft red gradient at bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header (Beranda & Notification)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Beranda',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.black87),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/reminder');
                      },
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryRed,
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Greeting
                            Text(
                              'Halo, $_userName 👋',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'ID: $_userId',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryRed,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Jaga kesehatanmu, setetes darah\nsangat berarti bagi sesama.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Blood Type Card
                            Container(
                              padding: const EdgeInsets.all(24.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Golongan Darah Saya',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _bloodTypeDisplay,
                                        style: const TextStyle(
                                          fontSize: 64,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryRed,
                                          height: 1.0,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Icon(
                                        Icons.water_drop,
                                        size: 70,
                                        color: AppColors.primaryRed.withOpacity(0.9),
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 4,
                                            offset: const Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Rhesus $_rhesus',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                      // Action Grid
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              Icons.medical_information_outlined, 
                              'Hasil Pemeriksaan',
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed('/result');
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildActionCard(
                              Icons.calendar_month_outlined, 
                              'Riwayat Donor',
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed('/history');
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              Icons.fact_check_outlined, 
                              'Cek Kelayakan\nDonor',
                              onTap: () {
                                Navigator.of(context).pushNamed('/eligibility_check');
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildActionCard(
                              Icons.menu_book_outlined, 
                              'Edukasi Darah',
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed('/education');
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Reminder Card
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/reminder');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, color: AppColors.primaryRed, size: 24),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Peringatan Donor',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _nextDonationMsg,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: AppColors.primaryRed),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              
              // Custom Bottom Navigation Bar
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
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
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: AppColors.primaryRed),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ),
    );
  }

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
          setState(() {
            _selectedIndex = index;
          });
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
