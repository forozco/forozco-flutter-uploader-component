# FileUploaderCard

## Descripcion

`FileUploaderCard` es un widget que proporciona una interfaz completa para la seleccion y gestion de archivos. Incluye una zona de carga con borde punteado, visualizacion de archivos seleccionados y opciones de configuracion flexibles.

## Instalacion

### Dependencias requeridas

Agrega las siguientes dependencias en tu archivo `pubspec.yaml`:

```yaml
dependencies:
  file_picker: ^8.0.0
  flutter_svg: ^2.0.10
```

### Assets requeridos

Asegurate de incluir el icono SVG en tu proyecto:

```yaml
flutter:
  assets:
    - assets/icons/
```

El archivo `assets/icons/Carga.svg` debe estar presente en tu proyecto.

## Uso basico

### Importacion

```dart
import 'package:uploader/widgets/file_uploader_card.dart';
```

### Implementacion minima

```dart
FileUploaderCard(
  title: 'Comprobante de domicilio',
)
```

### Implementacion completa

```dart
FileUploaderCard(
  title: 'Comprobante de domicilio',
  subtitle: 'Dato obligatorio*',
  description: 'Adjunta tu comprobante, verifica que:',
  requirements: const [
    'No sea mayor a 3 meses',
    'Sea legible',
    'Coincida con la informacion registrada',
  ],
  uploadSectionTitle: 'Subir archivos',
  maxFileSizeMB: 5,
  allowedExtensions: const ['jpg', 'jpeg', 'png', 'gif', 'pdf'],
  allowMultiple: true,
  onFilesChanged: (files) {
    // Manejar cambios en los archivos
  },
)
```

## Propiedades

| Propiedad | Tipo | Requerido | Default | Descripcion |
|-----------|------|-----------|---------|-------------|
| `title` | `String` | Si | - | Titulo principal del card |
| `subtitle` | `String?` | No | `null` | Subtitulo (ej: "Dato obligatorio*") |
| `description` | `String?` | No | `null` | Descripcion antes de los requisitos |
| `requirements` | `List<String>?` | No | `null` | Lista de requisitos mostrados con bullets |
| `uploadSectionTitle` | `String` | No | `'Subir archivos'` | Titulo de la seccion de carga |
| `maxFileSizeMB` | `int` | No | `5` | Tamano maximo por archivo en MB |
| `allowedExtensions` | `List<String>` | No | `['jpg', 'jpeg', 'png', 'gif', 'pdf']` | Extensiones de archivo permitidas |
| `allowMultiple` | `bool` | No | `true` | Permitir seleccion de multiples archivos |
| `onFilesChanged` | `Function(List<UploadedFile>)?` | No | `null` | Callback cuando cambia la lista de archivos |
| `initialFiles` | `List<UploadedFile>?` | No | `null` | Archivos iniciales precargados |

## Modelo UploadedFile

El callback `onFilesChanged` retorna una lista de objetos `UploadedFile` con la siguiente estructura:

```dart
class UploadedFile {
  final String name;      // Nombre del archivo
  final String size;      // Tamano formateado (ej: "2.5MB")
  final String? path;     // Ruta local del archivo
  final double progress;  // Progreso de carga (0.0 a 1.0)
  final bool isUploading; // Indica si esta en proceso de carga
}
```

## Manejo de archivos

### Almacenar archivos en el estado

Para tener acceso a los archivos en todo momento, almacenalos en el estado del widget padre:

```dart
class _MyScreenState extends State<MyScreen> {
  List<UploadedFile> _uploadedFiles = [];

  @override
  Widget build(BuildContext context) {
    return FileUploaderCard(
      title: 'Documentos',
      onFilesChanged: (files) {
        setState(() {
          _uploadedFiles = files;
        });
      },
    );
  }
}
```

### Acceder a la informacion de los archivos

```dart
void processFiles() {
  for (var file in _uploadedFiles) {
    print('Nombre: ${file.name}');
    print('Tamano: ${file.size}');
    print('Ruta: ${file.path}');
  }
}
```

### Validar antes de continuar

```dart
void onSubmit() {
  if (_uploadedFiles.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor adjunta al menos un archivo')),
    );
    return;
  }

  // Procesar archivos...
}
```

### Pasar archivos a otra pantalla

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NextScreen(files: _uploadedFiles),
  ),
);
```

## Ejemplo completo

```dart
import 'package:flutter/material.dart';
import 'package:uploader/widgets/file_uploader_card.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  List<UploadedFile> _uploadedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subir documentos')),
      body: Padding(
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
                'Coincida con la informacion registrada',
              ],
              maxFileSizeMB: 10,
              allowedExtensions: const ['pdf', 'jpg', 'png'],
              onFilesChanged: (files) {
                setState(() {
                  _uploadedFiles = files;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadedFiles.isEmpty ? null : _handleSubmit,
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    // Los archivos estan disponibles en _uploadedFiles
    final fileNames = _uploadedFiles.map((f) => f.name).join(', ');
    print('Archivos seleccionados: $fileNames');
  }
}
```

## Componentes internos

El widget `FileUploaderCard` utiliza internamente los siguientes componentes:

- `UploadDropzone`: Zona de carga con borde punteado e icono
- `FileUploadItem`: Item individual que muestra el archivo seleccionado con opcion de eliminar

Estos componentes tambien pueden ser utilizados de forma independiente si se requiere mayor personalizacion.

## Personalizacion de tema

Los colores del componente se definen en `lib/theme/app_theme.dart`:

```dart
class AppColors {
  static const Color primaryPurple = Color(0xFF582E73);
  static const Color primaryPink = Color(0xFFD4447C);
  static const Color lightPink = Color(0xFFFCE4EC);
  static const Color backgroundGray = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF333333);
  static const Color textGray = Color(0xFF757575);
  static const Color borderGray = Color(0xFFE0E0E0);
  static const Color white = Colors.white;
}
```

Modifica estos valores para adaptar el componente a tu esquema de colores.
