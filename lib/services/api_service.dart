import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://darah-api.lemnidev.com';
  // static const String baseUrl = 'http://localhost:5000';

  static SharedPreferences? _prefs;

  static String getImageUrl(String? gambarPath) {
    if (gambarPath == null || gambarPath.isEmpty) return '';
    if (gambarPath.startsWith('http://') || gambarPath.startsWith('https://')) {
      return gambarPath;
    }
    final cleanBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final cleanPath = gambarPath.startsWith('/') ? gambarPath : '/$gambarPath';

    if (!cleanPath.contains('/public/')) {
      return '$cleanBaseUrl/public/edukasi$cleanPath';
    }

    return '$cleanBaseUrl$cleanPath';
  }

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool hasToken() {
    return _prefs?.getString('token') != null;
  }

  // Save authentication details
  static Future<void> saveSession(String token, Map<String, dynamic> pendonor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('id_pendonor', pendonor['_id'] ?? '');
    await prefs.setString('id_user', pendonor['id_user'] ?? '');
    await prefs.setString('nama_pendonor', pendonor['nama_pendonor'] ?? '');
    await prefs.setString('email', pendonor['email'] ?? '');
    await prefs.setString('status_verifikasi', pendonor['status_verifikasi'] ?? '');
    await prefs.setString('golongan_darah', pendonor['golongan_darah'] ?? '-');
    await prefs.setString('rhesus', pendonor['rhesus'] ?? '');
  }

  // Clear session on logout
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> logout() async {
    await clearSession();
  }

  // Get authentication token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get stored pendonor ID
  static Future<String?> getPendonorId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id_pendonor');
  }

  // Get stored profile info
  static Future<Map<String, String>> getStoredProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id_pendonor': prefs.getString('id_pendonor') ?? '',
      'id_user': prefs.getString('id_user') ?? '',
      'nama_pendonor': prefs.getString('nama_pendonor') ?? '',
      'email': prefs.getString('email') ?? '',
      'status_verifikasi': prefs.getString('status_verifikasi') ?? '',
    };
  }

  // Common headers builder
  static Future<Map<String, String>> _headers() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Auth - Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/pendonor/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final token = data['token'];
        final pendonor = data['pendonor'];
        await saveSession(token, pendonor);
        return {'success': true, 'message': data['message'] ?? 'Login berhasil'};
      } else {
        return {'success': false, 'message': data['error'] ?? 'Login gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi internet bermasalah: $e'};
    }
  }

  // Auth - Register
  static Future<Map<String, dynamic>> register({
    required String nama,
    required String email,
    required String phone,
    required String dob,
    required String gender,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/pendonor/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama_pendonor': nama,
          'email': email,
          'no_telepon': phone,
          'tanggal_lahir': dob,
          'jenis_kelamin': gender,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Registrasi berhasil',
          'id_user': data['pendonor'] != null ? data['pendonor']['id_user'] : null
        };
      } else {
        return {'success': false, 'message': data['error'] ?? 'Registrasi gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi internet bermasalah: $e'};
    }
  }

  // Get Detail Profile (Includes Riwayat and Hasil Pemeriksaan)
  static Future<Map<String, dynamic>> getDonorDetail() async {
    try {
      final id = await getPendonorId();
      if (id == null || id.isEmpty) {
        return {'success': false, 'message': 'Sesi telah berakhir, silakan login kembali'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/pendonor/$id/detail'),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        final errorMsg = jsonDecode(response.body)['error'] ?? 'Gagal memuat profil';
        return {'success': false, 'message': errorMsg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi internet bermasalah: $e'};
    }
  }

  // Update Profile
  static Future<Map<String, dynamic>> updateProfile({
    required String nama,
    required String email,
    required String phone,
    required String dob,
    required String gender,
    required String bloodType,
    required String rhesus,
  }) async {
    try {
      final id = await getPendonorId();
      if (id == null || id.isEmpty) {
        return {'success': false, 'message': 'Sesi telah berakhir, silakan login kembali'};
      }

      final response = await http.put(
        Uri.parse('$baseUrl/pendonor/$id'),
        headers: await _headers(),
        body: jsonEncode({
          'nama_pendonor': nama,
          'email': email,
          'no_telepon': phone,
          'tanggal_lahir': dob,
          'jenis_kelamin': gender,
          'golongan_darah': bloodType,
          'rhesus': rhesus,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Update local session info
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('nama_pendonor', nama);
        await prefs.setString('email', email);
        await prefs.setString('golongan_darah', bloodType);
        await prefs.setString('rhesus', rhesus);
        return {'success': true, 'message': 'Profil berhasil diperbarui'};
      } else {
        return {'success': false, 'message': data['error'] ?? 'Gagal memperbarui profil'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi internet bermasalah: $e'};
    }
  }

  // Riwayat - Get List
  static Future<Map<String, dynamic>> getRiwayat() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/riwayat'),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        final errorMsg = jsonDecode(response.body)['error'] ?? 'Gagal memuat riwayat';
        return {'success': false, 'message': errorMsg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi internet bermasalah: $e'};
    }
  }

  // Riwayat - Add New
  static Future<Map<String, dynamic>> addRiwayat({
    required String tanggal,
    required String lokasi,
    required String banyakDarah,
    required String jenisDonor,
    required String catatan,
  }) async {
    try {
      // We package the extra fields as a JSON string or concatenated text inside "keterangan"
      final keteranganMap = {
        'lokasi': lokasi,
        'banyak_darah': banyakDarah,
        'jenis_donor': jenisDonor,
        'catatan': catatan,
      };
      final keteranganString = jsonEncode(keteranganMap);

      final response = await http.post(
        Uri.parse('$baseUrl/riwayat'),
        headers: await _headers(),
        body: jsonEncode({
          'tanggal_donor': tanggal,
          'keterangan': keteranganString,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['error'] ?? 'Gagal menambahkan riwayat'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi internet bermasalah: $e'};
    }
  }

  // Riwayat - Update Existing
  static Future<Map<String, dynamic>> updateRiwayat(
    String id, {
    required String tanggal,
    required String lokasi,
    required String banyakDarah,
    required String jenisDonor,
    required String catatan,
  }) async {
    try {
      final keteranganMap = {
        'lokasi': lokasi,
        'banyak_darah': banyakDarah,
        'jenis_donor': jenisDonor,
        'catatan': catatan,
      };
      final keteranganString = jsonEncode(keteranganMap);

      final response = await http.put(
        Uri.parse('$baseUrl/riwayat/$id'),
        headers: await _headers(),
        body: jsonEncode({
          'tanggal_donor': tanggal,
          'keterangan': keteranganString,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['error'] ?? 'Gagal memperbarui riwayat'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi internet bermasalah: $e'};
    }
  }

  // Riwayat - Delete
  static Future<Map<String, dynamic>> deleteRiwayat(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/riwayat/$id'),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Riwayat berhasil dihapus'};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['error'] ?? 'Gagal menghapus riwayat'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi internet bermasalah: $e'};
    }
  }

  // Edukasi - Get List
  static Future<Map<String, dynamic>> getEdukasi() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/edukasi'),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        final errorMsg = jsonDecode(response.body)['error'] ?? 'Gagal memuat edukasi';
        return {'success': false, 'message': errorMsg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi internet bermasalah: $e'};
    }
  }

  // Alat - Get List
  static Future<Map<String, dynamic>> getAlat() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/alat'),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        final errorMsg = jsonDecode(response.body)['error'] ?? 'Gagal memuat daftar alat';
        return {'success': false, 'message': errorMsg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Koneksi internet bermasalah: $e'};
    }
  }
}
