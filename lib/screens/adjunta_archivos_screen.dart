import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<UploadedFile> _uploadedFiles = [];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundGray,
        appBar: AppBar(
          backgroundColor: AppColors.primaryPurple,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.white, size: 32),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).maybePop();
            },
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
          scrolledUnderElevation: 0,
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
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
                          setState(() {
                            _uploadedFiles = files;
                          });
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
                            elevation: 0,
                            shadowColor: Colors.transparent,
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
                            elevation: 0,
                            shadowColor: Colors.transparent,
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
                  HapticFeedback.selectionClick();
                  setState(() {
                    _currentNavIndex = index;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSiguiente() {
    HapticFeedback.mediumImpact();
    if (_uploadedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor adjunta al menos un archivo'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    final fileNames = _uploadedFiles.map((f) => f.name).join(', ');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Archivos: $fileNames'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleCancela() {
    HapticFeedback.lightImpact();
    Navigator.of(context).maybePop();
  }
}
