import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'upload_dropzone.dart';
import 'file_upload_item.dart';

/// Modelo para representar un archivo subido
class UploadedFile {
  final String name;
  final String size;
  final String? path;
  final double progress;
  final bool isUploading;

  UploadedFile({
    required this.name,
    required this.size,
    this.path,
    this.progress = 1.0,
    this.isUploading = false,
  });
}

/// Widget reutilizable para subir archivos
///
/// Ejemplo de uso:
/// ```dart
/// FileUploaderCard(
///   title: 'Comprobante de domicilio',
///   subtitle: 'Dato obligatorio*',
///   description: 'Adjunta tu comprobante, verifica que:',
///   requirements: [
///     'No sea mayor a 3 meses',
///     'Sea legible',
///     'Coincida con la información registrada',
///   ],
///   onFilesChanged: (files) {
///     print('Archivos: $files');
///   },
/// )
/// ```
class FileUploaderCard extends StatefulWidget {
  /// Título principal del card
  final String title;

  /// Subtítulo (ej: "Dato obligatorio*")
  final String? subtitle;

  /// Descripción antes de los requisitos
  final String? description;

  /// Lista de requisitos a mostrar con bullets
  final List<String>? requirements;

  /// Título de la sección de subir archivos
  final String uploadSectionTitle;

  /// Tamaño máximo por archivo en MB
  final int maxFileSizeMB;

  /// Tipos de archivo permitidos (extensiones)
  final List<String> allowedExtensions;

  /// Permitir múltiples archivos
  final bool allowMultiple;

  /// Callback cuando cambian los archivos
  final Function(List<UploadedFile>)? onFilesChanged;

  /// Archivos iniciales
  final List<UploadedFile>? initialFiles;

  const FileUploaderCard({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.requirements,
    this.uploadSectionTitle = 'Subir archivos',
    this.maxFileSizeMB = 5,
    this.allowedExtensions = const ['jpg', 'jpeg', 'png', 'gif', 'pdf'],
    this.allowMultiple = true,
    this.onFilesChanged,
    this.initialFiles,
  });

  @override
  State<FileUploaderCard> createState() => _FileUploaderCardState();
}

class _FileUploaderCardState extends State<FileUploaderCard> {
  late List<UploadedFile> _uploadedFiles;

  @override
  void initState() {
    super.initState();
    _uploadedFiles = widget.initialFiles ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildIOSCard(context);
    }
    return _buildAndroidCard(context);
  }

  // ==================== iOS Native UI ====================
  Widget _buildIOSCard(BuildContext context) {
    // Colores adaptativos para dark mode
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: labelColor,
              letterSpacing: -0.5,
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              widget.subtitle!,
              style: TextStyle(
                fontSize: 15,
                color: secondaryLabelColor,
              ),
            ),
          ],
          if (widget.description != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.description!,
              style: TextStyle(
                fontSize: 15,
                color: labelColor,
              ),
            ),
          ],
          if (widget.requirements != null && widget.requirements!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...widget.requirements!.map((req) => _buildIOSBulletPoint(req)),
          ],
          const SizedBox(height: 24),
          Text(
            widget.uploadSectionTitle,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: labelColor,
            ),
          ),
          const SizedBox(height: 12),
          UploadDropzone(
            onTap: _handleFileSelection,
            maxFileSizeMB: widget.maxFileSizeMB,
            allowedExtensions: widget.allowedExtensions,
          ),
          if (_uploadedFiles.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._uploadedFiles.map((file) => FileUploadItem(
              fileName: file.name,
              fileSize: file.size,
              progress: file.progress,
              isUploading: file.isUploading,
              onRemove: () => _removeFile(file),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildIOSBulletPoint(String text) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7, right: 10),
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: secondaryLabelColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: labelColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Android Native UI ====================
  Widget _buildAndroidCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              widget.subtitle!,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (widget.description != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.description!,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
          if (widget.requirements != null && widget.requirements!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...widget.requirements!.map((req) => _buildAndroidBulletPoint(context, req)),
          ],
          const SizedBox(height: 24),
          Text(
            widget.uploadSectionTitle,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          UploadDropzone(
            onTap: _handleFileSelection,
            maxFileSizeMB: widget.maxFileSizeMB,
            allowedExtensions: widget.allowedExtensions,
          ),
          if (_uploadedFiles.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._uploadedFiles.map((file) => FileUploadItem(
              fileName: file.name,
              fileSize: file.size,
              progress: file.progress,
              isUploading: file.isUploading,
              onRemove: () => _removeFile(file),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildAndroidBulletPoint(BuildContext context, String text) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, right: 12),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleFileSelection() async {
    HapticFeedback.selectionClick();
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: widget.allowMultiple,
      );

      if (!mounted) return;

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          for (var file in result.files) {
            final sizeInMB = (file.size / (1024 * 1024)).toStringAsFixed(1);
            _uploadedFiles.add(UploadedFile(
              name: file.name,
              size: '${sizeInMB}MB',
              path: file.path,
              progress: 1.0,
              isUploading: false,
            ));
          }
        });
        HapticFeedback.lightImpact();
        widget.onFilesChanged?.call(_uploadedFiles);
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Error al seleccionar archivo: $e');
    }
  }

  void _showError(String message) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
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

  void _removeFile(UploadedFile file) {
    setState(() {
      _uploadedFiles.remove(file);
    });
    widget.onFilesChanged?.call(_uploadedFiles);
  }
}
