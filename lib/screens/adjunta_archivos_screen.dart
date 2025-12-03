import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
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
    if (Platform.isIOS) {
      return _buildIOSScreen();
    }
    return _buildAndroidScreen();
  }

  // ==================== iOS Native UI ====================
  Widget _buildIOSScreen() {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.primaryPurple,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).maybePop();
          },
          child: const Icon(
            CupertinoIcons.back,
            color: CupertinoColors.white,
          ),
        ),
        middle: const Text(
          'Adjunta tus archivos',
          style: TextStyle(
            color: CupertinoColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Card con estilo iOS
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FileUploaderCard(
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
                    ),
                    const SizedBox(height: 20),
                    // Botón primario iOS
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        onPressed: _handleSiguiente,
                        child: const Text(
                          'Siguiente',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Botón secundario iOS
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        color: AppColors.lightPink,
                        onPressed: _handleCancela,
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            color: AppColors.textDark,
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
            // Tab Bar iOS nativo
            CupertinoTabBar(
              currentIndex: _currentNavIndex,
              activeColor: AppColors.primaryPurple,
              inactiveColor: CupertinoColors.systemGrey,
              onTap: (index) {
                HapticFeedback.selectionClick();
                setState(() {
                  _currentNavIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.calendar),
                  label: 'Calendario',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.add_circled),
                  label: 'Registro',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.question_circle),
                  label: 'Ayuda',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Android Native UI ====================
  Widget _buildAndroidScreen() {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).maybePop();
          },
        ),
        title: const Text(
          'Adjunta tus archivos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Card Material
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FileUploaderCard(
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
                    ),
                    const SizedBox(height: 20),
                    // Botón primario Material 3
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: _handleSiguiente,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryPink,
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
                    // Botón secundario Material 3
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton.tonal(
                        onPressed: _handleCancela,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.lightPink,
                          foregroundColor: AppColors.textDark,
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
            // Navigation Bar Material 3
            NavigationBar(
              selectedIndex: _currentNavIndex,
              onDestinationSelected: (index) {
                HapticFeedback.selectionClick();
                setState(() {
                  _currentNavIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Inicio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_today_outlined),
                  selectedIcon: Icon(Icons.calendar_today),
                  label: 'Calendario',
                ),
                NavigationDestination(
                  icon: Icon(Icons.add_box_outlined),
                  selectedIcon: Icon(Icons.add_box),
                  label: 'Registro',
                ),
                NavigationDestination(
                  icon: Icon(Icons.help_outline),
                  selectedIcon: Icon(Icons.help),
                  label: 'Ayuda',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleSiguiente() {
    HapticFeedback.mediumImpact();
    if (_uploadedFiles.isEmpty) {
      _showMessage('Por favor adjunta al menos un archivo');
      return;
    }

    final fileNames = _uploadedFiles.map((f) => f.name).join(', ');
    _showMessage('Archivos: $fileNames');
  }

  void _handleCancela() {
    HapticFeedback.lightImpact();
    Navigator.of(context).maybePop();
  }

  void _showMessage(String message) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
