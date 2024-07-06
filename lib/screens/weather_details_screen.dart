import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_application/model/weather_model.dart';
import 'package:weather_application/provider/shared_prefs_provider.dart';
import 'package:weather_application/provider/weather_provider.dart';
import 'package:weather_application/screens/home_screen.dart';
import 'package:weather_application/utils/messages.dart';

class WeatherDetailsScreen extends StatefulWidget {
  const WeatherDetailsScreen({
    super.key,
    this.icon = '',
    this.cityName = '',
    this.temp = 0.0,
    this.des = '',
    this.humidity = 0,
    this.windSpeed = 0.0,
  });

  final String icon;
  final String cityName;
  final double temp;
  final String des;
  final int humidity;
  final double windSpeed;

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  late SharedprefsProvider provider;
  late WeatherProvider provider1;
  late final String currentCity;
  WeatherModel? wm;

  @override
  void initState() {
    super.initState();
    getCity();
  }

  void getCity() async {
    provider = Provider.of<SharedprefsProvider>(context, listen: false);
    provider1 = Provider.of<WeatherProvider>(context, listen: false);
    currentCity = await provider.getPrefs(widget.cityName);
    print(currentCity);
    wm = await provider1.fetchData(currentCity);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final des = wm != null ? wm!.weather![0].description! : '';
    final des1 =
        wm != null ? des[0].toUpperCase() + des.substring(1) : widget.des;
    final windSpeed = wm != null ? wm!.wind!.speed! * 3.6 : 0.0;
    final windSpeed1 = wm != null
        ? '${windSpeed.toStringAsFixed(2)}\nkm/hr'
        : '${widget.windSpeed.toStringAsFixed(2)}\nkm/hr';
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              wm = await provider1.fetchData(currentCity);
              setState(() {});
              successMssg('Refresh successfully done!!!');
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  height: 125,
                  width: width > 500 ? 400 : double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.lightBlue.shade200,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 180,
                        width: 100,
                        child: CachedNetworkImage(
                          imageUrl: wm != null
                              ? 'https://openweathermap.org/img/wn/${wm!.weather![0].icon!}@2x.png'
                              : widget.icon,
                          placeholder: (context, url) {
                            return const SizedBox(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return const Icon(
                              Icons.error,
                              size: 50,
                            );
                          },
                        ),
                      ),
                      Text(
                        '$des1\nIn ${wm != null ? wm!.name! : widget.cityName}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(136, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  height: 200,
                  width: width > 500 ? 400 : double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.lightBlue.shade200,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.thermostat,
                            size: 50,
                            color: Color.fromARGB(92, 0, 0, 0),
                          ),
                        ),
                        Center(
                          child: Text(
                            '${wm != null ? wm!.main!.temp! : widget.temp}°C',
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(136, 0, 0, 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.lightBlue.shade200,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Icon(
                                Icons.wind_power,
                                size: 30,
                                color: Color.fromARGB(92, 0, 0, 0),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                windSpeed1,
                                style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(136, 0, 0, 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.lightBlue.shade200,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Icon(
                                Icons.water_drop,
                                size: 30,
                                color: Color.fromARGB(92, 0, 0, 0),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                wm != null
                                    ? '${wm!.main!.humidity!}\nPercent'
                                    : '${widget.humidity}\nPercent',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(136, 0, 0, 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => const HomeScreen(),
                      ),
                    );
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('isSuccessfullySearched', false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue.shade200,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Search'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 45),
                const Text(
                  'Made by Sumit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Data Provided By openweathermap.org',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
