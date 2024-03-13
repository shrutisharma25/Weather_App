class Forecast {
  String time;
  final Map<String, dynamic> values;
  String? error; // Optional error message

  Forecast({required this.time, required this.values, this.error});
}