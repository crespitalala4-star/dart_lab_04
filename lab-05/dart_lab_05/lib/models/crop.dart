class Crop {
  final String id;
  final String name;
  final double plantedArea;
  final String region;

  Crop({
    required this.id,
    required this.name,
    required this.plantedArea,
    required this.region,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'] as String,
      name: json['name'] as String,
      plantedArea: (json['plantedArea'] as num).toDouble(),
      region: json['region'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'plantedArea': plantedArea,
      'region': region,
    };
  }

  @override
  String toString() => '$name ($region): $plantedArea ha';
}