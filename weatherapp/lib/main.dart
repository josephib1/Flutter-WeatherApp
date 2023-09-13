import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(
      title: "Weather App",
      initialRoute: '/',
      routes: {
        '/': (context) => const CityInputPage(),
      },
    ));

class CityInputPage extends StatefulWidget {
  const CityInputPage({super.key});

  @override
  _CityInputPageState createState() => _CityInputPageState();
}

class _CityInputPageState extends State<CityInputPage> {
  final TextEditingController _cityController = TextEditingController();

  void _submitCity() {
    String cityName = _cityController.text;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WeatherPage(cityName: cityName)),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter City'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City Name',
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitCity,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherPage extends StatefulWidget {
  final String cityName;

  const WeatherPage({super.key, required this.cityName});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  var temp;
  var description;
  var icon;
  var humidity;
  var windSpeed;

  Future getWeather(String cityName) async {
    String apiKey = "";
    Uri apiUrl = Uri.parse(
        "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$cityName&aqi=no");

    http.Response response = await http.get(apiUrl);
    var results = jsonDecode(response.body);
    setState(() {
      temp = results['current']['temp_c'];
      description = results['current']['condition']['text'];
      icon = results['current']['condition']['icon'];
      humidity = results['current']['humidity'];
      windSpeed = results['current']['wind_kph'];
    });
  }

  @override
  void initState() {
    super.initState();
    getWeather(widget.cityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Info'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: const Color.fromARGB(255, 2, 183, 255),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Currently in ${widget.cityName}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  temp != null ? '${temp.toString()}°' : "Loading",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.network(icon.toString()),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.thermometerHalf),
                    title: const Text("Temperature"),
                    trailing: Text(temp != null ? "$temp\u00B0" : "loading"),
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.cloud),
                    title: const Text("Weather"),
                    trailing: Text(description != null
                        ? description.toString()
                        : "loading"),
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.sun),
                    title: const Text("Humidity"),
                    trailing: Text(
                        humidity != null ? humidity.toString() : "loading"),
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.wind),
                    title: const Text("Wind Speed"),
                    trailing: Text(
                        windSpeed != null ? windSpeed.toString() : "loading"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
