class WeatherModel {
  final DateTime date;
  final double temperature;
  final String description;

  WeatherModel({required this.date, required this.temperature, required this.description});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['dt_txt']);
    final temperature = json['main']['temp'];
    final description = json['weather'][0]['description'];

    return WeatherModel(
      date: date,
      temperature: temperature,
      description: description,
    );
  }
}
