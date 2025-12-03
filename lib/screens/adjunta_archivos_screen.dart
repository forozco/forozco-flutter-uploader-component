import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/file_uploader_card.dart';

class AdjuntaArchivosScreen extends StatefulWidget {
  const AdjuntaArchivosScreen({super.key});

  @override
  State<AdjuntaArchivosScreen> createState() => _AdjuntaArchivosScreenState();
}

class _AdjuntaArchivosScreenState extends State<AdjuntaArchivosScreen> {
  int _currentNavIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPurple,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.white, size: 32),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Adjunta tus archivos',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  FileUploaderCard(
                    title: 'Comprobante de domicilio',
                    subtitle: 'Dato obligatorio*',
                    description: 'Adjunta tu comprobante, verifica que:',
                    requirements: const [
                      'No sea mayor a 3 meses',
                      'Sea legible',
                      'Coincida con la información registrada',
                    ],
                    onFilesChanged: (files) {
                      // Handle file changes here if needed
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleSiguiente,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPink,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Siguiente',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      onPressed: _handleCancela,
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.lightPink,
                        foregroundColor: AppColors.textDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          BottomNavBar(
            currentIndex: _currentNavIndex,
            onTap: (index) {
              setState(() {
                _currentNavIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }

  void _handleSiguiente() {
    // Navigate to next screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Continuando al siguiente paso...')),
    );
  }

  void _handleCancela() {
    // Cancel and go back
    Navigator.of(context).maybePop();
  }
}
