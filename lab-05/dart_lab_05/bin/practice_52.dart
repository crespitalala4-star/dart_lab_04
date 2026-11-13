class CropArea {
  final String name;
  final double plantedArea;

  CropArea({required String name, required this.plantedArea})
      : name = name.trim() {
    if (this.name.isEmpty) {
      throw FormatException('Crop name must not be empty.');
    }
    if (!plantedArea.isFinite || plantedArea <= 0) {
      throw FormatException('Planted area must be positive and finite.');
    }
  }
}

void main() {
  String? note;
  print(note ?? 'No note available');

  CropArea crop = CropArea(name: ' Coffee ', plantedArea: 125.0);
  print(crop.name);

  try {
    CropArea bad = CropArea(name: '', plantedArea: 12.5);
    print(bad.name);
  } on FormatException catch (error) {
    print('Invalid crop: ${error.message}');
  }

  for (var area in ['abc', '-3', '0', 'Infinity', '12.5']) {
    double? value = double.tryParse(area);
    if (value == null || !value.isFinite || value <= 0) {
      print('$area -> Enter a positive finite area.');
    } else {
      print('$area -> Accepted area: $value');
    }
  }
}
