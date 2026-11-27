# BookHub

<div align="center">
  <img src="assets/images/splash_icon_2.png" alt="BookHub" width="220"/>

  **Tu biblioteca personal para leer archivos PDF desde tu dispositivo**

  [![Flutter](https://img.shields.io/badge/Flutter-3.50-blue?logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.14-0175C2?logo=dart&logoColor=white)](https://dart.dev)
  [![License](https://img.shields.io/badge/license-Private-lightgrey)](#licencia)

</div>

---

## Sobre el proyecto

**BookHub** es una aplicación multiplataforma desarrollada con Flutter para gestionar y leer documentos PDF de forma sencilla. Permite construir una biblioteca local, guardar el progreso de lectura y continuar exactamente desde la última página visitada.

La interfaz incluye una presentación moderna, soporte para temas claro y oscuro y una experiencia de lectura basada en una vista de libro con efecto de página.

## Características

- Importación de archivos PDF desde el dispositivo.
- Biblioteca personal con el nombre de cada documento.
- Continuación automática desde la última página abierta.
- Indicador de progreso y página actual.
- Navegación con botones anterior y siguiente.
- Vista de lectura con efecto de cambio de página.
- Zoom habilitado dentro del lector.
- Interacción mediante toque para pasar páginas.
- Alternancia entre tema claro y oscuro.
- Eliminación de un PDF de la biblioteca.
- Eliminación opcional del archivo PDF del dispositivo.
- Manejo de archivos ausentes y errores al abrir documentos.

## Vista general

| Biblioteca | Lector |
|---|---|
| Visualiza tus documentos, progreso y opciones de gestión. | Lee el PDF con navegación, zoom y recuperación automática de progreso. |

La aplicación utiliza dos pantallas principales:

- **Pantalla de inicio:** presentación animada de la aplicación.
- **Biblioteca:** administración de libros importados.
- **Lector:** visualización y navegación del documento PDF.

## Tecnologías

| Tecnología | Uso |
|---|---|
| [Flutter](https://flutter.dev/) | Desarrollo de la interfaz multiplataforma |
| [Riverpod](https://riverpod.dev/) | Gestión de estado |
| [pdfrx](https://pub.dev/packages/pdfrx) | Renderizado y carga de documentos PDF |
| [page_flip_view](https://pub.dev/packages/page_flip_view) | Efecto de páginas |
| [file_picker](https://pub.dev/packages/file_picker) | Selección de archivos PDF |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | Persistencia de la biblioteca y preferencias |
| [Hive](https://pub.dev/packages/hive) | Dependencia disponible en el proyecto |

## Cómo funciona

1. Toca **Importar PDF**.
2. Selecciona un documento con formato PDF.
3. El archivo aparece en tu biblioteca.
4. Abre el PDF para empezar a leer.
5. El progreso se guarda automáticamente al cambiar de página.
6. La próxima vez que abras el documento continuará desde la última página.

La biblioteca conserva el identificador, título, ruta del archivo, página actual y número total de páginas mediante `SharedPreferences`.

> Los PDFs se mantienen fuera del almacenamiento interno de la aplicación. El libro debe conservarse en la ubicación donde fue seleccionado para poder abrirlo posteriormente.

## Requisitos

- Flutter SDK `3.50.0` o compatible
- Dart SDK `3.14.0` o compatible
- Un dispositivo o emulador disponible
- Android Studio o VS Code con la extensión de Flutter

## Instalación y ejecución

Clona el repositorio:

```bash
git clone https://github.com/HeribertoBR/BookHub.git
cd BookHub
```

Instala las dependencias:

```bash
flutter pub get
```

Verifica que haya un dispositivo disponible:

```bash
flutter devices
```

Ejecuta la aplicación:

```bash
flutter run
```

Para ejecutar específicamente en un dispositivo Android conectado:

```bash
flutter run -d <device-id>
```

## Pruebas

Ejecuta las pruebas existentes con:

```bash
flutter test
```

Las pruebas cubren:

- Cálculo del porcentaje de lectura.
- Compatibilidad con libros guardados sin número de páginas.
- Cambio entre los temas claro y oscuro.

## Estructura del proyecto

```text
lib/
├── data/
│   └── models/
│       └── book.dart                 # Modelo y progreso de lectura
├── features/
│   ├── library/
│   │   └── library_page.dart         # Biblioteca e importación de PDFs
│   └── reader/
│       └── reader_page.dart          # Lector y navegación
├── screens/
│   └── splash_screen.dart            # Pantalla de presentación
├── services/
│   ├── storage_services.dart         # Persistencia de libros
│   └── theme_controller.dart         # Gestión del tema
└── main.dart                         # Configuración principal

assets/
└── images/
    ├── splash_icon.png
    └── splash_icon_2.png

test/
└── widget_test.dart
```

## Progreso y almacenamiento

Cada libro guarda la siguiente información:

| Campo | Descripción |
|---|---|
| `id` | Identificador único del libro |
| `title` | Nombre del archivo seleccionado |
| `path` | Ruta local del documento |
| `lastPage` | Última página abierta |
| `totalPages` | Número total de páginas |

El porcentaje de lectura se calcula a partir de la página actual y el total de páginas disponibles.

## Permisos

La selección de documentos se realiza mediante `file_picker`. En Android pueden requerirse permisos adicionales según la versión del sistema y el proveedor de almacenamiento usado para seleccionar el archivo.

## Posibles mejoras

- Búsqueda dentro de la biblioteca.
- Favoritos y categorías.
- Marcadores.
- Restauración automática del último documento.
- Exportación y respaldo de datos.
- Vista de miniaturas.
- Información y metadatos del PDF.
- Sincronización en la nube.

## Contribuciones

Las contribuciones son bienvenidas:

1. Haz un fork del repositorio.
2. Crea una rama con tu mejora:

   ```bash
   git checkout -b feature/nueva-funcionalidad
   ```

3. Realiza tus cambios y ejecuta las pruebas.
4. Abre un pull request describiendo claramente la propuesta.

## Licencia

Este repositorio no contiene actualmente un archivo de licencia. Si se desea distribuir la aplicación públicamente, primero debe agregarse una licencia adecuada.

---

<div align="center">
  Desarrollado con Flutter para disfrutar tus lecturas desde tu dispositivo.
</div>
