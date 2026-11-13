class CropArea {
  final String name;
  final double plantedArea;

  CropArea({required String name, required this.plantedArea})
      : name = name.trim() {
    if (this.name.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Name is required.');
    }
    if (!plantedArea.isFinite || plantedArea <= 0) {
      throw ArgumentError.value(
        plantedArea,
        'plantedArea',
        'Area must be positive and finite.',
      );
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
        crops = List.unmodifiable(crops) {
    if (this.municipality.isEmpty) {
      throw ArgumentError.value(municipality, 'municipality', 'Municipality is required.');
    }
    if (year < 2000 || year > 2100) {
      throw ArgumentError.value(year, 'year', 'Year must be between 2000 and 2100.');
    }
    if (crops.isEmpty) {
      throw ArgumentError.value(crops, 'crops', 'At least one crop is required.');
    }
  }

  double get totalArea => crops.fold(0.0, (sum, c) => sum + c.plantedArea);
  double get averageArea => totalArea / crops.length;
  CropArea get largestCrop => crops.reduce((a, b) => a.plantedArea >= b.plantedArea ? a : b);

  void printSummary() {
    print('$municipality - $year');
    print('Total: $totalArea | Average: ${averageArea.toStringAsFixed(2)}');
    print('Largest: ${largestCrop.name} (${largestCrop.plantedArea}) - ${(largestCrop.plantedArea / totalArea * 100).toStringAsFixed(1)}%');
  }
}

class ObservationCatalog {
  final Map<String, AgriculturalRecord> _records = {};

  String _buildKey(String municipality, int year) {
    return '${municipality.trim().toLowerCase()}-$year';
  }

  bool add(AgriculturalRecord record) {
    final key = _buildKey(record.municipality, record.year);
    if (_records.containsKey(key)) return false;
    _records[key] = record;
    return true;
  }

  AgriculturalRecord? find(String municipality, int year) {
    return _records[_buildKey(municipality, year)];
  }

  List<AgriculturalRecord> listAll() => _records.values.toList();

  bool remove(String municipality, int year) {
    return _records.remove(_buildKey(municipality, year)) != null;
  }

  int get count => _records.length;
}

void main() {
  final catalog = ObservationCatalog();
  catalog.add(AgriculturalRecord(
    municipality: 'Andes',
    year: 2025,
    crops: [
      CropArea(name: 'Coffee', plantedArea: 125),
      CropArea(name: 'Beans', plantedArea: 75),
      CropArea(name: 'Rice', plantedArea: 50),
    ],
  ));
  catalog.find('Andes', 2025)?.printSummary();
  print('Total records: ${catalog.count}');
}