import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/adaptive_app_bar.dart';
import '../widgets/adaptive_bottom_nav.dart';
import '../widgets/adaptive_button.dart';
import '../widgets/adaptive_dialog.dart';
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
    return Platform.isIOS ? _buildCupertinoScreen() : _buildMaterialScreen();
  }

  Widget _buildCupertinoScreen() {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.primaryPurple,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Icon(
            CupertinoIcons.back,
            color: AppColors.white,
          ),
        ),
        middle: const Text(
          'Adjunta tus archivos',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
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
                        const SizedBox(height: 20),
                        AdaptivePrimaryButton(
                          text: 'Siguiente',
                          onPressed: _handleSiguiente,
                        ),
                        const SizedBox(height: 12),
                        AdaptiveSecondaryButton(
                          text: 'Cancelar',
                          onPressed: _handleCancela,
                        ),
                        const SizedBox(height: 16),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            AdaptiveBottomNav(
              currentIndex: _currentNavIndex,
              onTap: (index) {
                setState(() {
                  _currentNavIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialScreen() {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: AdaptiveAppBar(
        title: 'Adjunta tus archivos',
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        child: Column(
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
                        setState(() {
                          _uploadedFiles = files;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    AdaptivePrimaryButton(
                      text: 'Siguiente',
                      onPressed: _handleSiguiente,
                    ),
                    const SizedBox(height: 12),
                    AdaptiveSecondaryButton(
                      text: 'Cancelar',
                      onPressed: _handleCancela,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            AdaptiveBottomNav(
              currentIndex: _currentNavIndex,
              onTap: (index) {
                setState(() {
                  _currentNavIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSiguiente() {
    if (_uploadedFiles.isEmpty) {
      AdaptiveDialog.showMessage(
        context: context,
        title: 'Archivos requeridos',
        message: 'Por favor adjunta al menos un archivo para continuar.',
      );
      return;
    }

    final fileNames = _uploadedFiles.map((f) => f.name).join(', ');
    AdaptiveDialog.showMessage(
      context: context,
      title: 'Archivos adjuntados',
      message: 'Archivos: $fileNames',
    );
  }

  void _handleCancela() async {
    final confirmed = await AdaptiveDialog.showConfirmation(
      context: context,
      title: 'Cancelar registro',
      message: '¿Estás seguro de que deseas cancelar? Se perderán los archivos adjuntados.',
      confirmText: 'Sí, cancelar',
      cancelText: 'No, continuar',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).maybePop();
    }
  }
}
