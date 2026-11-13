class AreaCounter {
  double _totalArea = 0.0;
  double get totalArea => _totalArea;

  bool addArea(double area) {
    if (!area.isFinite || area <= 0) return false;
    double next = _totalArea + area;
    if (!next.isFinite) return false;
    _totalArea = next;
    return true;
  }

  void reset() => _totalArea = 0.0;
}

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

void main() {
  AreaCounter c1 = AreaCounter();
  AreaCounter c2 = AreaCounter();
  print(c1.addArea(25.0)); // true
  print(c1.addArea(-3.0)); // false
  print(c1.addArea(0.0)); // false
  print(c1.addArea(double.nan)); // false
  print(c1.addArea(50.0)); // true
  print(c1.totalArea); // 75.0
  print(c2.totalArea); // 0.0 - independiente
  c1.reset();
  print(c1.totalArea); // 0.0
}