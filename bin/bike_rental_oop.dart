import 'dart:io';

// ---------- Bicycle ----------
class Bicycle {
  final String id;
  final String description;
  final double hourlyRate;
  bool _isAvailable = true;

  Bicycle({
    required String id,
    required String description,
    required this.hourlyRate,
  })  : id = id.trim(),
        description = description.trim() {
    if (this.id.isEmpty) {
      throw ArgumentError.value(id, 'id', 'Id is required.');
    }
    if (this.description.isEmpty) {
      throw ArgumentError.value(
          description, 'description', 'Description is required.');
    }
    if (!hourlyRate.isFinite || hourlyRate <= 0) {
      throw ArgumentError.value(
          hourlyRate, 'hourlyRate', 'Rate must be positive and finite.');
    }
  }

  bool get isAvailable => _isAvailable;

  // Solo lo puede llamar RentalManager, no desde afuera a lo loco
  void _markRented() => _isAvailable = false;
  void _markAvailable() => _isAvailable = true;

  String describe() =>
      '$id - $description - \$${hourlyRate.toStringAsFixed(2)}/h - ${isAvailable ? 'Available' : 'Rented'}';
}

// ---------- Rental ----------
class Rental {
  final Bicycle bicycle;
  final String customerName;
  double? _hours;
  double? _totalCost;

  Rental({required this.bicycle, required String customerName})
      : customerName = customerName.trim() {
    if (this.customerName.isEmpty) {
      throw ArgumentError.value(
          customerName, 'customerName', 'Customer name is required.');
    }
  }

  bool get isActive => _hours == null;
  double get hours => _hours ?? 0;
  double get totalCost => _totalCost ?? 0;

  bool finish(double hours) {
    if (!isActive) return false;
    if (!hours.isFinite || hours <= 0) return false;
    _hours = hours;
    _totalCost = hours * bicycle.hourlyRate;
    return true;
  }

  String describe() {
    if (isActive) {
      return '${bicycle.id} rented to $customerName - ACTIVE';
    }
    return '${bicycle.id} rented to $customerName - ${hours.toStringAsFixed(2)}h - \$${totalCost.toStringAsFixed(2)}';
  }
}

// ---------- Manager ----------
class RentalManager {
  final Map<String, Bicycle> _bicycles = {};
  final List<Rental> _rentals = [];

  List<Bicycle> get bicycles =>
      List<Bicycle>.unmodifiable(_bicycles.values.toList());
  List<Rental> get rentals => List<Rental>.unmodifiable(_rentals);

  List<Bicycle> get availableBicycles =>
      List<Bicycle>.unmodifiable(
          _bicycles.values.where((b) => b.isAvailable).toList());

  List<Rental> get activeRentals =>
      List<Rental>.unmodifiable(_rentals.where((r) => r.isActive).toList());

  List<Rental> get finishedRentals =>
      List<Rental>.unmodifiable(_rentals.where((r) => !r.isActive).toList());

  double get totalIncome {
    double total = 0;
    for (final r in finishedRentals) {
      total += r.totalCost;
    }
    return total;
  }

  bool addBicycle(Bicycle bike) {
    String key = bike.id.toLowerCase();
    if (_bicycles.containsKey(key)) return false;
    _bicycles[key] = bike;
    return true;
  }

  Bicycle? findBicycle(String id) => _bicycles[id.trim().toLowerCase()];

  // Devuelve null si no se pudo iniciar
  Rental? startRental(String bikeId, String customerName) {
    Bicycle? bike = findBicycle(bikeId);
    if (bike == null) {
      print('Bicycle not found.');
      return null;
    }
    if (!bike.isAvailable) {
      print('Bicycle already rented.');
      return null;
    }
    if (customerName.trim().isEmpty) {
      print('Customer name is required.');
      return null;
    }
    Rental rental = Rental(bicycle: bike, customerName: customerName);
    bike._markRented();
    _rentals.add(rental);
    print('Rental started.');
    return rental;
  }

  bool finishRental(String bikeId, double hours) {
    Bicycle? bike = findBicycle(bikeId);
    if (bike == null) {
      print('Bicycle not found.');
      return false;
    }
    for (final r in _rentals) {
      if (r.bicycle.id.toLowerCase() == bikeId.trim().toLowerCase() &&
          r.isActive) {
        if (!r.finish(hours)) {
          print('Invalid hours.');
          return false;
        }
        bike._markAvailable();
        print('Rental finished. Cost: \$${r.totalCost.toStringAsFixed(2)}');
        return true;
      }
    }
    print('No active rental for this bicycle.');
    return false;
  }
}

// ---------- Lectores ----------
String? readRequiredText(String prompt) {
  while (true) {
    stdout.write(prompt);
    String? line = stdin.readLineSync();
    if (line == null) return null;
    if (line.trim().isNotEmpty) return line.trim();
    print('Value is required.');
  }
}

double? readPositiveDouble(String prompt) {
  while (true) {
    stdout.write(prompt);
    String? line = stdin.readLineSync();
    if (line == null) return null;
    double? value = double.tryParse(line.trim());
    if (value != null && value.isFinite && value > 0) return value;
    print('Enter a positive number.');
  }
}

int? readIntInRange(String prompt, int min, int max) {
  while (true) {
    stdout.write(prompt);
    String? line = stdin.readLineSync();
    if (line == null) return null;
    int? value = int.tryParse(line.trim());
    if (value != null && value >= min && value <= max) return value;
    print('Enter a number between $min and $max.');
  }
}

// ---------- Main / Menú ----------
void main() {
  RentalManager manager = RentalManager();

  // Datos de prueba para que el profe vea que funciona
  manager.addBicycle(
      Bicycle(id: 'B1', description: 'Mountain bike', hourlyRate: 5.0));
  manager.addBicycle(
      Bicycle(id: 'B2', description: 'City bike', hourlyRate: 3.5));

  while (true) {
    print('================================');
    print('        BIKE RENTAL OOP');
    print('================================');
    print('1. Register bicycle');
    print('2. List available bicycles');
    print('3. Start rental');
    print('4. Finish rental');
    print('5. Show active rentals');
    print('6. Show finished rentals');
    print('7. Show total income');
    print('0. Exit');

    int? option = readIntInRange('Option: ', 0, 7);
    if (option == null || option == 0) {
      print('Goodbye!');
      return;
    }

    switch (option) {
      case 1:
        String? id = readRequiredText('Bicycle id: ');
        if (id == null) return;
        String? desc = readRequiredText('Description: ');
        if (desc == null) return;
        double? rate = readPositiveDouble('Hourly rate: ');
        if (rate == null) return;
        try {
          bool ok = manager.addBicycle(
              Bicycle(id: id, description: desc, hourlyRate: rate));
          print(ok ? 'Bicycle registered.' : 'Bicycle already exists.');
        } catch (e) {
          print('Invalid bicycle: $e');
        }
      case 2:
        if (manager.availableBicycles.isEmpty) {
          print('No bicycles available.');
        } else {
          for (final b in manager.availableBicycles) {
            print(b.describe());
          }
        }
      case 3:
        String? bikeId = readRequiredText('Bicycle id: ');
        if (bikeId == null) return;
        String? customer = readRequiredText('Customer name: ');
        if (customer == null) return;
        manager.startRental(bikeId, customer);
      case 4:
        String? bikeId2 = readRequiredText('Bicycle id: ');
        if (bikeId2 == null) return;
        double? hours = readPositiveDouble('Hours: ');
        if (hours == null) return;
        manager.finishRental(bikeId2, hours);
      case 5:
        if (manager.activeRentals.isEmpty) {
          print('No active rentals.');
        } else {
          for (final r in manager.activeRentals) {
            print(r.describe());
          }
        }
      case 6:
        if (manager.finishedRentals.isEmpty) {
          print('No finished rentals.');
        } else {
          for (final r in manager.finishedRentals) {
            print(r.describe());
          }
        }
      case 7:
        print(
            'Total income: \$${manager.totalIncome.toStringAsFixed(2)}');
    }
  }
}
