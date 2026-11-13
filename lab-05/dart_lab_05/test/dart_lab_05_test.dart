import 'package:dart_lab_05/models/crop.dart';
import 'package:test/test.dart';

void main() {
  test('Crop fromJson and toJson', () {
    final crop = Crop.fromJson({
      'id': 'C1',
      'name': 'Coffee',
      'plantedArea': 125.0,
      'region': 'Andes',
    });

    expect(crop.name, 'Coffee');
    expect(crop.plantedArea, 125.0);
    expect(crop.toJson()['region'], 'Andes');
    expect(crop.toString(), 'Coffee (Andes): 125.0 ha');
  });
}