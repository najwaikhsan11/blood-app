import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EligibilityCheckScreen extends StatefulWidget {
  const EligibilityCheckScreen({super.key});

  @override
  State<EligibilityCheckScreen> createState() => _EligibilityCheckScreenState();
}

class _EligibilityCheckScreenState extends State<EligibilityCheckScreen> {
  int _currentStep = 1; // 1: Data Diri, 2: Kesehatan, 3: Hasil

  // Form Step 1 Data
  String _usia = '22 Tahun';
  String _beratBadan = '58 Kg';
  String _jenisKelamin = 'Perempuan'; // 'Laki-laki' or 'Perempuan'
  String _golonganDarah = 'AB+';
  String _riwayatDonorTerakhir = '5 Februari 2026';

  // Form Step 2 Data
  bool _sedangSakit = false;
  bool _konsumsiObat = false;
  bool _penyakitKronis = false;
  bool _hamilMenyusui = false;
  bool _tindikTato = false;

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
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
          onPressed: () {
            if (_currentStep > 1 && _currentStep < 3) {
              setState(() {
                _currentStep--;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          'Cek Kelayakan Donor',
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
            _buildStepper(),
            Expanded(
              child: _buildCurrentStepContent(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Stepper UI ────────────────────────────────────────────────────────────
  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepItem(1, 'Data Diri'),
          _buildStepConnector(1),
          _buildStepItem(2, 'Kesehatan'),
          _buildStepConnector(2),
          _buildStepItem(3, 'Hasil'),
        ],
      ),
    );
  }

  Widget _buildStepItem(int stepNumber, String label) {
    final bool isActive = _currentStep == stepNumber;
    final bool isCompleted = _currentStep > stepNumber;

    Color circleColor = Colors.white;

    if (isActive || isCompleted) {
      circleColor = AppColors.primaryRed;
    }

    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: (isActive || isCompleted) ? AppColors.primaryRed : Colors.grey.shade400,
              width: 2,
            ),
          ),
          child: Text(
            '$stepNumber',
            style: TextStyle(
              color: (isActive || isCompleted) ? Colors.white : Colors.grey.shade400,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.primaryRed : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(int stepNumber) {
    final bool isCompleted = _currentStep > stepNumber;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 14),
        height: 2,
        color: isCompleted ? AppColors.primaryRed : Colors.grey.shade300,
      ),
    );
  }

  // ── Content Router ────────────────────────────────────────────────────────
  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return const SizedBox();
    }
  }

  // ── Step 1: Data Diri ─────────────────────────────────────────────────────
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: const Text(
                    'Lengkapi data diri Anda untuk\nmengetahui apakah Anda layak.',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
                Icon(Icons.assignment_ind_outlined, color: AppColors.primaryRed, size: 40),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Data Diri',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryRed),
          ),
          const SizedBox(height: 16),

          // Usia
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Usia', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              _buildDropdownSmall(
                value: _usia,
                items: ['20 Tahun', '21 Tahun', '22 Tahun', '23 Tahun', '24 Tahun'],
                onChanged: (val) => setState(() => _usia = val!),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Berat Badan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Berat Badan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              _buildDropdownSmall(
                value: _beratBadan,
                items: ['50 Kg', '55 Kg', '58 Kg', '60 Kg', '65 Kg'],
                onChanged: (val) => setState(() => _beratBadan = val!),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Jenis Kelamin
          const Text('Jenis Kelamin', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildGenderButton('Laki-laki', Icons.male),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGenderButton('Perempuan', Icons.female),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Golongan Darah
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Golongan Darah', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              _buildDropdownSmall(
                value: _golonganDarah,
                items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                onChanged: (val) => setState(() => _golonganDarah = val!),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Riwayat Donor Terakhir
          const Text('Riwayat Donor Terakhir', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: Colors.black54, size: 18),
                    const SizedBox(width: 12),
                    Text(_riwayatDonorTerakhir, style: const TextStyle(fontSize: 13)),
                  ],
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          _buildActionButton('Selanjutnya', _nextStep),
        ],
      ),
    );
  }

  Widget _buildDropdownSmall({required String value, required List<String> items, required void Function(String?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 20),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val, style: const TextStyle(fontSize: 13, color: Colors.black87)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildGenderButton(String label, IconData icon) {
    bool isSelected = _jenisKelamin == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _jenisKelamin = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? AppColors.primaryRed : Colors.black54, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryRed : Colors.black54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Step 2: Kesehatan ─────────────────────────────────────────────────────
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: const Text(
                    'Lengkapi data kesehatan Anda saat ini\nuntuk mengetahui apakah Anda layak.',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
                Icon(Icons.health_and_safety_outlined, color: AppColors.primaryRed, size: 40),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Kondisi Kesehatan Saat ini',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryRed),
          ),
          const SizedBox(height: 16),

          _buildRadioQuestion('Apakah Anda sedang sakit?\n(flu, demam, batuk, dll)', _sedangSakit, (val) => setState(() => _sedangSakit = val)),
          _buildRadioQuestion('Apakah Anda sedang mengonsumsi\nobat tertentu?', _konsumsiObat, (val) => setState(() => _konsumsiObat = val)),
          _buildRadioQuestion('Apakah Anda memiliki riwayat penyakit\nkronis? (jantung, diabetes, tekanan\ndarah tinggi, dll)', _penyakitKronis, (val) => setState(() => _penyakitKronis = val)),
          _buildRadioQuestion('Apakah Anda sedang hamil atau\nmenyusui?', _hamilMenyusui, (val) => setState(() => _hamilMenyusui = val)),
          _buildRadioQuestion('Apakah Anda melakukan tindik,\ntato, atau akupuntur dalam\n6 bulan terakhir?', _tindikTato, (val) => setState(() => _tindikTato = val)),

          const SizedBox(height: 40),
          _buildActionButton('Cek Sekarang', _nextStep),
        ],
      ),
    );
  }

  Widget _buildRadioQuestion(String question, bool currentValue, void Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              question,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ),
          Row(
            children: [
              _buildCustomRadio(label: 'Ya', value: true, groupValue: currentValue, onChanged: onChanged),
              const SizedBox(width: 12),
              _buildCustomRadio(label: 'Tidak', value: false, groupValue: currentValue, onChanged: onChanged),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomRadio({required String label, required bool value, required bool groupValue, required void Function(bool) onChanged}) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primaryRed : Colors.grey.shade400,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // ── Step 3: Hasil ─────────────────────────────────────────────────────────
  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Result Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              children: [
                const Icon(Icons.shield_outlined, color: Colors.green, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Layak Donor',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Anda memenuhi syarat awal\nuntuk donor darah.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Terima kasih telah berkontribusi untuk membantu\nsesama melalui donor darah.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          const Text(
            'Ringkasan Hasil Evaluasi',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryRed),
          ),
          const SizedBox(height: 16),

          _buildResultItem('Usia', '22 Tahun (Memenuhi)'),
          _buildResultItem('Berat Badan', '58 Kg (Memenuhi)'),
          _buildResultItem('Jarak Donor Terakhir', '4 Bulan (Memenuhi)'),
          _buildResultItem('Kondisi Kesehatan', 'Baik (Memenuhi)'),
          _buildResultItem('Obat - obatan', 'Tidak ada (Memenuhi)'),
          _buildResultItem('Riwayat Penyakit', 'Tidak ada (Memenuhi)'),
          _buildResultItem('Kehamilan / Menyusui', 'Tidak (Memenuhi)'),
          _buildResultItem('Tindik / Tato / Akupuntur', '> 6 Bulan (Memenuhi)'),

          const SizedBox(height: 24),
          // Warning box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: AppColors.primaryRed, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Penting untuk diingat',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Hasil ini hanya evaluasi awal. Keputusan akhir tetap berada pada petugas medis saat donor darah.',
                        style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          _buildActionButton('Simpan Hasil', () {
            Navigator.of(context).pop();
          }),
        ],
      ),
    );
  }

  Widget _buildResultItem(String title, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 18),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
          Text(status, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
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
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
