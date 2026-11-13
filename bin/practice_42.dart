class CropArea {
  final String name;
  final double plantedArea;

  CropArea({required String name, required this.plantedArea})
      : name = name.trim();

  CropArea.example() : name = 'Coffee', plantedArea = 125.0;
  CropArea.emptyExample() : name = 'Example', plantedArea = 1.0;

  double get areaInSquareMeters => plantedArea * 10000.0;
  String describe() => '$name: $plantedArea ha';
}

void main() {
  CropArea c1 = CropArea(name: '  Coffee  ', plantedArea: 1.0);
  CropArea c2 = CropArea(plantedArea: 2.5, name: 'Beans');
  CropArea c3 = CropArea(name: 'Rice', plantedArea: 3.0);

  for (final c in [c1, c2, c3]) {
    print('${c.describe()} - ${c.areaInSquareMeters} m2');
  }

  print(CropArea.example().describe());
}