import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String _jenisKelamin = 'Perempuan'; // 'Laki-laki' or 'Perempuan'
  bool _agreeToTerms = false;
  String? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daftar Akun',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              
              // Privacy Information Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryRed.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user_outlined, color: AppColors.primaryRed, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Data Anda aman dan hanya digunakan untuk keperluan pelayanan donor darah.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.7),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields
              _buildLabel('Nama Lengkap'),
              _buildTextField(_nameController, 'Masukkan nama lengkap', Icons.person_outline),
              
              _buildLabel('Email'),
              _buildTextField(_emailController, 'Masukkan email aktif', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
              
              _buildLabel('No. Telepon'),
              _buildTextField(_phoneController, '08xxxxxxxxxx', Icons.phone_outlined, keyboardType: TextInputType.phone),
              
              _buildLabel('Tanggal Lahir'),
              _buildDatePicker(),
              
              _buildLabel('Jenis Kelamin'),
              Row(
                children: [
                  Expanded(child: _buildGenderButton('Laki - laki', Icons.male)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildGenderButton('Perempuan', Icons.female)),
                ],
              ),
              
              _buildLabel('Kata Sandi'),
              _buildTextField(_passwordController, 'Buat kata sandi', Icons.lock_outline, obscureText: true, isPassword: true),
              const Padding(
                padding: EdgeInsets.only(top: 8.0, left: 4),
                child: Text(
                  'Minimal 8 karakter dengan kombinasi huruf dan angka',
                  style: TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ),
              
              _buildLabel('Konfirmasi Kata Sandi'),
              _buildTextField(_confirmPasswordController, 'Ulangi kata sandi', Icons.lock_outline, obscureText: true, isPassword: true),
              
              const SizedBox(height: 24),
              
              // Terms and Conditions Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (val) => setState(() => _agreeToTerms = val!),
                    activeColor: AppColors.primaryRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                        children: [
                          const TextSpan(text: 'Saya setuju dengan '),
                          TextSpan(
                            text: 'Syarat & Ketentuan',
                            style: const TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' dan '),
                          TextSpan(
                            text: 'Kebijakan Privasi',
                            style: const TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Register Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signup_success');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'Daftar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              
              // Login Link
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sudah punya akun? ', style: TextStyle(fontSize: 13, color: Colors.black87)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Masuk di sini',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 4),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool obscureText = false, bool isPassword = false, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
        prefixIcon: Icon(icon, size: 20, color: Colors.black38),
        suffixIcon: isPassword ? const Icon(Icons.visibility_off_outlined, size: 20, color: Colors.black38) : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () {
        // Show date picker logic here
        setState(() => _selectedDate = "1 Januari 1990");
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 20, color: Colors.black38),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedDate ?? 'Pilih tanggal lahir',
                style: TextStyle(
                  fontSize: 13,
                  color: _selectedDate == null ? Colors.black38 : Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black38),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderButton(String label, IconData icon) {
    bool isSelected = _jenisKelamin == label;
    return GestureDetector(
      onTap: () => setState(() => _jenisKelamin = label),
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
}
