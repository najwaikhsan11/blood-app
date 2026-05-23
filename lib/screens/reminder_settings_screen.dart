import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';

class ReminderSettingsScreen extends StatefulWidget {
  const ReminderSettingsScreen({super.key});

  @override
  State<ReminderSettingsScreen> createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {
  bool _isReminderOn = true;
  String _reminderDays = '3 Hari Sebelum';
  String _notificationTime = '08:00';
  bool _pushNotificationOn = true;
  bool _emailNotificationOn = true;
  bool _smsNotificationOn = false;
  
  // Maps day index (0=Sen..6=Min) to selection state
  final List<bool> _selectedDays = [false, false, false, false, false, true, false]; 
  final List<String> _dayLabels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isReminderOn = prefs.getBool('isReminderOn') ?? true;
      _reminderDays = prefs.getString('reminderDays') ?? '3 Hari Sebelum';
      _notificationTime = prefs.getString('notificationTime') ?? '08:00';
      _pushNotificationOn = prefs.getBool('pushNotificationOn') ?? true;
      _emailNotificationOn = prefs.getBool('emailNotificationOn') ?? true;
      _smsNotificationOn = prefs.getBool('smsNotificationOn') ?? false;
      
      final savedDaysStr = prefs.getStringList('selectedDays');
      if (savedDaysStr != null && savedDaysStr.length == 7) {
        for (int i = 0; i < 7; i++) {
          _selectedDays[i] = savedDaysStr[i] == 'true';
        }
      }
    });
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
          'Pengaturan Peringatan',
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
                    // ── Nyalakan Pengingat ────────────────────────────────────
                    _buildSectionTitle('Nyalakan Pengingat'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Dapatkan notifikasi sebelum jadwal donor Anda.',
                            style: TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                        ),
                        Switch(
                          value: _isReminderOn,
                          onChanged: (val) {
                            setState(() {
                              _isReminderOn = val;
                            });
                          },
                          activeColor: AppColors.primaryRed,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Waktu Pengingat ───────────────────────────────────────
                    _buildSectionTitle('Waktu Pengingat'),
                    _buildDropdownContainer(
                      label: 'Ingatkan saya',
                      value: _reminderDays,
                      items: ['1 Hari Sebelum', '2 Hari Sebelum', '3 Hari Sebelum', '1 Minggu Sebelum'],
                      onChanged: (val) {
                        setState(() => _reminderDays = val!);
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Kami akan mengirim notifikasi H-3 sebelum\njadwal donor Anda.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),

                    // ── Waktu Notifikasi ──────────────────────────────────────
                    _buildSectionTitle('Waktu Notifikasi'),
                    _buildDropdownContainer(
                      label: 'Jam Notifikasi',
                      value: _notificationTime,
                      items: ['07:00', '08:00', '09:00', '10:00'],
                      onChanged: (val) {
                        setState(() => _notificationTime = val!);
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pilih waktu terbaik untuk mengingatkan Anda.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),

                    // ── Metode Notifikasi ─────────────────────────────────────
                    _buildSectionTitle('Metode Notifikasi'),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          _buildSwitchTile(
                            icon: Icons.notifications_none,
                            title: 'Notifikasi Push',
                            value: _pushNotificationOn,
                            onChanged: (val) => setState(() => _pushNotificationOn = val),
                          ),
                          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                          _buildSwitchTile(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            value: _emailNotificationOn,
                            onChanged: (val) => setState(() => _emailNotificationOn = val),
                          ),
                          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                          _buildSwitchTile(
                            icon: Icons.chat_bubble_outline,
                            title: 'SMS',
                            value: _smsNotificationOn,
                            onChanged: (val) => setState(() => _smsNotificationOn = val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Hari Pengingat ────────────────────────────────────────
                    _buildSectionTitle('Hari Pengingat'),
                    const Text(
                      'Pilih hari dalam seminggu (opsional)',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDays[index] = !_selectedDays[index];
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _selectedDays[index] ? AppColors.primaryRed : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _selectedDays[index] ? AppColors.primaryRed : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              _dayLabels[index],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _selectedDays[index] ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 32),

                    // ── Informasi Tambahan ────────────────────────────────────
                    _buildSectionTitle('Informasi Tambahan'),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryRed.withOpacity(0.1)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.verified_user_outlined, color: AppColors.primaryRed, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: const Text(
                              'Kami tidak akan membagikan data Anda ke pihak lain. Semua pengingat bersifat pribadi dan aman.',
                              style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            
            // ── Bottom Action Button ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isReminderOn', _isReminderOn);
                  await prefs.setString('reminderDays', _reminderDays);
                  await prefs.setString('notificationTime', _notificationTime);
                  await prefs.setBool('pushNotificationOn', _pushNotificationOn);
                  await prefs.setBool('emailNotificationOn', _emailNotificationOn);
                  await prefs.setBool('smsNotificationOn', _smsNotificationOn);
                  await prefs.setStringList('selectedDays', _selectedDays.map((d) => d.toString()).toList());

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Pengaturan berhasil disimpan!'),
                        backgroundColor: AppColors.primaryRed,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                    Navigator.of(context).pop(true);
                  }
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
                  'Simpan Perubahan',
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDropdownContainer({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
              items: items.map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryRed,
          ),
        ],
      ),
    );
  }
}
