class CropArea {
  String name = '';
  double plantedArea = 0.0;

  void showDescription() {
    print('$name: $plantedArea ha');
  }
}

void main() {
  CropArea coffee = CropArea();
  coffee.name = 'Coffee';
  coffee.plantedArea = 125.0;
  coffee.showDescription();

  CropArea beans = CropArea();
  beans.name = 'Beans';
  beans.plantedArea = 40.0;
  beans.showDescription();
}