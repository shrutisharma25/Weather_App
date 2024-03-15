class GetWeatherImage {
  String getWeatherImage(double temperature) {
    if (temperature < 0) {
      return "assets/images/snow.png";
    } else if (temperature >= 0 && temperature < 15) {
      return "assets/images/lightrain.png";
    } else if (temperature >= 15 && temperature < 25) {
      return "assets/images/heavyrain.png";
    } else if (temperature >= 25 && temperature <= 35) {
      return "assets/images/cloudsunny.png";
    } else {
      return "assets/images/clear.png";
    }
  }
}

