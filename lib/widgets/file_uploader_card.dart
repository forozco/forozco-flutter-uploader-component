import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/app_theme.dart';
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.subtitle!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textGray,
              ),
            ),
          ],
          if (widget.description != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.description!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
          ],
          if (widget.requirements != null && widget.requirements!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...widget.requirements!.map((req) => _buildBulletPoint(req)),
          ],
          const SizedBox(height: 24),
          Text(
            widget.uploadSectionTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
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

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.textDark,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleFileSelection() async {
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
        widget.onFilesChanged?.call(_uploadedFiles);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar archivo: $e')),
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
