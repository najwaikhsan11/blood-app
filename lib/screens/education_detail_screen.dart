import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../theme/app_colors.dart';
import '../services/api_service.dart';

class EducationDetailScreen extends StatelessWidget {
  const EducationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Receive arguments passed from EducationScreen
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String title = args?['title'] ?? 'Edukasi Darah';
    final String subtitle = args?['subtitle'] ?? '';
    final String content = args?['content'] ?? 'Tidak ada konten yang tersedia.';
    final IconData icon = args?['icon'] ?? Icons.article;
    final String? gambar = args?['gambar'];

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
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header Icon/Image ─────────────────────────────────────
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: (gambar != null && gambar.isNotEmpty)
                    ? Image.network(
                        ApiService.getImageUrl(gambar),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              icon,
                              size: 80,
                              color: AppColors.primaryRed.withOpacity(0.9),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Icon(
                          icon,
                          size: 80,
                          color: AppColors.primaryRed.withOpacity(0.9),
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              // ── Title & Subtitle ──────────────────────────────────────
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryRed,
                ),
              ),
              const SizedBox(height: 24),

              // ── Main Content ──────────────────────────────────────────
              HtmlWidget(
                content,
                textStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
