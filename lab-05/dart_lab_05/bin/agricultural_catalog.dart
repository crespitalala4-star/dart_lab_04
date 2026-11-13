import 'dart:convert';
import 'dart:io';
import 'package:dart_lab_05/models/crop.dart';

void main() {
  try {
    final file = File('data/crops.json');
    final content = file.readAsStringSync();
    final List<dynamic> jsonList = jsonDecode(content);

    final crops = jsonList
        .map((item) => Crop.fromJson(item as Map<String, dynamic>))
        .toList();

    print('--- Agricultural Catalog ---');
    for (var crop in crops) {
      print(crop);
    }

    final total = crops.fold<double>(0, (sum, c) => sum + c.plantedArea);
    print('Total planted area: ${total.toStringAsFixed(2)} ha');

    final andes = crops.where((c) => c.region == 'Andes').toList();
    print('--- Andes only ---');
    for (var crop in andes) {
      print(crop);
    }

    // Guardar de vuelta a JSON para comprobar toJson()
    final output = jsonEncode(crops.map((c) => c.toJson()).toList());
    print('JSON output: $output');
  } on FileSystemException catch (e) {
    print('File error: ${e.message}');
  } on FormatException catch (e) {
    print('Invalid JSON: ${e.message}');
  }
}
