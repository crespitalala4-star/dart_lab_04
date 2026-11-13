class CropArea {
  final String name;
  final double plantedArea;
  CropArea({required String name, required this.plantedArea})
      : name = name.trim() {
    if (this.name.isEmpty) throw ArgumentError.value(name, 'name', 'Name is required.');
    if (!plantedArea.isFinite || plantedArea <= 0) {
      throw ArgumentError.value(plantedArea, 'plantedArea', 'Area must be positive and finite.');
    }
  }
}

class AgriculturalRecord {
  final String municipality;
  final int year;
  final List<CropArea> crops;

  AgriculturalRecord({
    required String municipality,
    required this.year,
    required List<CropArea> crops,
  })  : municipality = municipality.trim(),
        crops = List<CropArea>.unmodifiable(crops) {
    if (this.municipality.isEmpty) throw ArgumentError.value(municipality, 'municipality', 'Municipality is required.');
    if (year < 2000 || year > 2100) throw ArgumentError.value(year, 'year', 'Invalid year.');
    if (this.crops.isEmpty) throw ArgumentError.value(crops, 'crops', 'At least one crop is required.');
    Set<String> names = <String>{};
    for (final crop in this.crops) {
      if (!names.add(crop.name.toLowerCase())) {
        throw ArgumentError.value(crop.name, 'crop', 'Duplicate crop name.');
      }
    }
    if (!totalArea.isFinite) throw ArgumentError('Total area must be finite.');
  }

  double get totalArea {
    double total = 0.0;
    for (final c in crops) total += c.plantedArea;
    return total;
  }

  double get averageArea => totalArea / crops.length;

  CropArea get largestCrop {
    CropArea largest = crops.first;
    for (final c in crops.skip(1)) {
      if (c.plantedArea > largest.plantedArea) largest = c;
    }
    return largest;
  }

  double get largestShare => largestCrop.plantedArea / totalArea * 100;

  void printSummary() {
    print('Municipality: $municipality');
    print('Year: $year');
    print('Total area: ${totalArea.toStringAsFixed(2)} ha');
    print('Number of crops: ${crops.length}');
    print('Average area: ${averageArea.toStringAsFixed(2)} ha');
    print('Largest crop: ${largestCrop.name}');
    print('Largest share: ${largestShare.toStringAsFixed(2)}%');
    print('All crops:');
    for (final crop in crops) {
      final share = crop.plantedArea / totalArea * 100;
      print('- ${crop.name}: ${crop.plantedArea.toStringAsFixed(2)} ha (${share.toStringAsFixed(2)}%)');
    }
  }
}

void main() {
  AgriculturalRecord record = AgriculturalRecord(
    municipality: 'Andes',
    year: 2025,
    crops: [
      CropArea(name: 'Coffee', plantedArea: 125.0),
      CropArea(name: 'Plantain', plantedArea: 75.0),
      CropArea(name: 'Avocado', plantedArea: 50.0),
    ],
  );
  record.printSummary();
}
