class Forecast {
  String time;
  String values;
  String? error; // Optional error message

  Forecast({required this.time, required this.values, this.error});
}