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
    // Colores adaptativos para dark mode
    final backgroundColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);
    final cardBackgroundColor = CupertinoColors.systemBackground.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryFillColor = CupertinoColors.systemGrey5.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBlue.resolveFrom(context),
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
                    // Card con estilo iOS grouped
                    Container(
                      decoration: BoxDecoration(
                        color: cardBackgroundColor,
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
                    const SizedBox(height: 24),
                    // Botón primario iOS - estilo sistema
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CupertinoButton(
                        color: CupertinoColors.systemBlue,
                        borderRadius: BorderRadius.circular(12),
                        onPressed: _handleSiguiente,
                        child: const Text(
                          'Siguiente',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Botón secundario iOS - estilo texto
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CupertinoButton(
                        color: secondaryFillColor,
                        borderRadius: BorderRadius.circular(12),
                        onPressed: _handleCancela,
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: labelColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
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
              activeColor: CupertinoColors.systemBlue,
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        // En dark mode usar surface con elevación, en light mode el primary
        backgroundColor: isDark ? colorScheme.surfaceContainer : colorScheme.primary,
        foregroundColor: isDark ? colorScheme.onSurface : colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).maybePop();
          },
        ),
        title: Text(
          'Adjunta tus archivos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: isDark ? colorScheme.onSurface : colorScheme.onPrimary,
          ),
        ),
        elevation: isDark ? 0 : 0,
        scrolledUnderElevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Card Material 3
                    Card(
                      elevation: 0,
                      color: colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: colorScheme.outlineVariant,
                          width: 1,
                        ),
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
                    const SizedBox(height: 24),
                    // Botón primario Material 3
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: _handleSiguiente,
                        style: FilledButton.styleFrom(
                          // En dark mode usar primaryContainer para mejor contraste
                          backgroundColor: isDark
                              ? colorScheme.primaryContainer
                              : colorScheme.primary,
                          foregroundColor: isDark
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onPrimary,
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
                      height: 56,
                      child: OutlinedButton(
                        onPressed: _handleCancela,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.onSurface,
                          side: BorderSide(
                            color: colorScheme.outline,
                            width: 1,
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
