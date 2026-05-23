import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/api_service.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  int _selectedIndex = 3; // "Edukasi" tab is active
  bool _isLoading = false;
  List<Map<String, dynamic>> _apiTopics = [];

  final List<Map<String, dynamic>> _topics = [
    {
      'title': 'Sistem Golongan Darah ABO',
      'subtitle': 'Memahami golongan darah A, B, AB dan O',
      'icon': Icons.water_drop,
      'content': 'Sistem golongan darah ABO adalah sistem penggolongan darah yang paling penting dalam transfusi darah pada manusia. Sistem ini didasarkan pada ada tidaknya dua antigen, yaitu antigen A dan antigen B, di permukaan sel darah merah.\n\nGolongan darah A memiliki antigen A.\nGolongan darah B memiliki antigen B.\nGolongan darah AB memiliki kedua antigen A dan B.\nGolongan darah O tidak memiliki kedua antigen tersebut.'
    },
    {
      'title': 'Rhesus (Rh)',
      'subtitle': 'Apa itu Rhesus positif dan negatif ?',
      'icon': Icons.add_circle_outline,
      'content': 'Faktor Rhesus (Rh) adalah protein turunan (antigen) yang dapat ditemukan di permukaan sel darah merah. Jika sel darah merah memiliki antigen ini, berarti golongan darah Anda adalah Rh positif (+). Jika tidak, berarti Rh negatif (-).\n\nMengetahui faktor Rh sangat penting, terutama pada saat transfusi darah dan selama kehamilan, untuk mencegah komplikasi.'
    },
    {
      'title': 'Kompatibilitas Tranfusi',
      'subtitle': 'Golongan darah yang cocok untuk tranfusi',
      'icon': Icons.sync_alt,
      'content': 'Golongan darah O- (negatif) disebut sebagai donor universal karena dapat mendonorkan darahnya ke semua golongan darah.\n\nGolongan darah AB+ (positif) disebut sebagai resipien universal karena dapat menerima transfusi darah dari semua golongan darah.\n\nKecocokan transfusi harus selalu dicek silang (cross-match) sebelum prosedur dilakukan untuk memastikan keselamatan pasien.'
    },
    {
      'title': 'Manfaat Donor Darah',
      'subtitle': 'Manfaat bagi pendonor dan penerima',
      'icon': Icons.favorite_border,
      'content': 'Bagi Penerima: Dapat menyelamatkan nyawa pasien yang mengalami kecelakaan, operasi besar, kanker, atau penyakit kelainan darah.\n\nBagi Pendonor: Membantu menjaga kesehatan jantung, merangsang pembentukan sel darah merah baru, membakar kalori, dan memberikan manfaat psikologis karena membantu sesama.'
    },
    {
      'title': 'Proses Donor Darah',
      'subtitle': 'Tahapan dan prosedur donor darah',
      'icon': Icons.medical_services_outlined,
      'content': '1. Registrasi: Mengisi formulir pendaftaran dan kuisioner medis.\n2. Pemeriksaan Kesehatan: Pengecekan berat badan, tekanan darah, denyut nadi, dan kadar hemoglobin (Hb).\n3. Pengambilan Darah: Proses pengambilan darah (sekitar 350-500ml) yang berlangsung 10-15 menit.\n4. Pemulihan: Istirahat sejenak sambil menikmati makanan ringan dan minuman yang disediakan sebelum kembali beraktivitas.'
    },
    {
      'title': 'Tips Sebelum Donor',
      'subtitle': 'Persiapan agar donor lancar dan aman',
      'icon': Icons.check_circle_outline,
      'content': '1. Tidur cukup minimal 7-8 jam sebelum mendonorkan darah.\n2. Makan makanan bergizi, terutama yang kaya zat besi seperti daging merah atau bayam.\n3. Minum banyak air putih, minimal 3-4 gelas ekstra.\n4. Hindari konsumsi alkohol minimal 24 jam sebelum donor.\n5. Hindari makanan berlemak tinggi karena dapat mempengaruhi kualitas plasma darah.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      _isLoading = true;
    });
    final res = await ApiService.getEdukasi();
    if (res['success'] == true && res['data'] != null && res['data'] is List) {
      final List<dynamic> list = res['data'];
      setState(() {
        _apiTopics = list.map<Map<String, dynamic>>((item) {
          return {
            'title': item['judul'] ?? '',
            'subtitle': item['sumber'] != null && item['sumber'].toString().isNotEmpty
                ? 'Sumber: ${item['sumber']}'
                : 'Edukasi Darah',
            'content': item['isi_materi'] ?? '',
            'icon': Icons.article_outlined,
            'gambar': item['gambar'] ?? '',
          };
        }).toList();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _displayTopics {
    if (_apiTopics.isNotEmpty) {
      return _apiTopics;
    }
    return _topics;
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Edukasi Darah',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ── Scrollable Content ────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),

                    // ── Info Banner ───────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline, color: AppColors.primaryRed, size: 24),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Pelajari lebih banyak tentang golongan darah dan donor darah',
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

                    // ── Topics List ───────────────────────────────────
                    _isLoading
                        ? const Center(child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(color: AppColors.primaryRed),
                          ))
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _displayTopics.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final topic = _displayTopics[index];
                              return _buildTopicCard(
                                icon: topic['icon'],
                                gambar: topic['gambar'],
                                title: topic['title'],
                                subtitle: topic['subtitle'],
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/education_detail',
                                    arguments: topic,
                                  );
                                },
                              );
                            },
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

  Widget _buildTopicCard({
    required IconData icon,
    String? gambar,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image or Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              child: (gambar != null && gambar.isNotEmpty)
                  ? Image.network(
                      ApiService.getImageUrl(gambar),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          icon,
                          size: 28,
                          color: AppColors.primaryRed,
                        );
                      },
                    )
                  : Icon(
                      icon,
                      size: 28,
                      color: AppColors.primaryRed,
                    ),
            ),
            const SizedBox(width: 16),
            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Arrow
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
          Navigator.of(context).pushReplacementNamed('/history');
        } else if (index == 3) {
          // Already here
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
