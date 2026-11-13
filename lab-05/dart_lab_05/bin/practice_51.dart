abstract interface class ReportFormatter {
  String format(String title, double area);
}

class CompactFormatter implements ReportFormatter {
  @override
  String format(String title, double area) {
    return '$title: ${area.toStringAsFixed(2)} ha';
  }
}

class VerboseFormatter implements ReportFormatter {
  @override
  String format(String title, double area) {
    return 'Observation $title reports ${area.toStringAsFixed(2)} hectares.';
  }
}

class ReportPrinter {
  final ReportFormatter formatter;
  ReportPrinter(this.formatter);

  void printReport(String title, double area) {
    print(formatter.format(title, area));
  }
}

void main() {
  ReportPrinter printer1 = ReportPrinter(CompactFormatter());
  printer1.printReport('Andes 2025', 125.0);

  ReportPrinter printer2 = ReportPrinter(VerboseFormatter());
  printer2.printReport('Andes 2025', 125.0);
}
