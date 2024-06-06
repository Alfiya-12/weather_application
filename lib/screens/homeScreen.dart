import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_application/constants.dart' as k;

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  bool isLoaded = false;
  num? temp;
  num? press;
  num? hum;
  num? cover;
  num? mintemp;
  num? maxtemp;
  String cityname = '';
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    'https://w0.peakpx.com/wallpaper/263/425/HD-wallpaper-clouds-sky-cloudy-dark-weather-samsung-galaxy-s4-s5-note-sony-xperia-z-z1-z2-z3-htc-one-lenovo-vibe-background.jpg',
                  ))

              ),
          child: Visibility(
            visible: isLoaded,
            replacement: const Center(
              child: CircularProgressIndicator(color: Colors.white,)),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.06,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        20,
                      ),
                    ),
                  ),
                  child: Center(
                    child: TextFormField(
                      onFieldSubmitted: (String s) {
                        setState(() {
                          cityname = s;
                          getCityWeather(s);
                          isLoaded = false;
                          controller.clear();
                        });
                      },
                      controller: controller,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search city',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 25,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.pin_drop,
                        color: Colors.red,
                        size: 40,
                      ),
                      Text(
                        cityname,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '${temp?.toInt()}ºC',
                  style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 150,
                ),
                Container(
                    width: 500,
                    height: 300,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20)),
                    child: GridView(
                      padding: const EdgeInsets.all(10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.sunny,
                              color: Colors.white,
                            ),
                            Text(
                              'Min Temp:\n ${mintemp?.toInt()} ºC',
                              style:
                                  const TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.sunny,
                              color: Colors.white,
                            ),
                            Text(
                              'Max Temp:\n ${maxtemp?.toInt()} ºC',
                              style:
                                  const TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.water_drop,
                              color: Colors.white,
                            ),
                            Text(
                              'Humidity: \n${hum?.toInt()}%',
                              style:
                                  const TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.cloud,
                              color: Colors.white,
                            ),
                            Text(
                              'Cloud Cover:\n${cover?.toInt()}%',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ))
              ],
            ),
            ),
          ),
        ),

    );
  }

  getCurrentLocation() async {
    var p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        forceAndroidLocationManager: true);
    if (p != null) {
      print("Lat:${p.latitude},Long:${p.longitude}");
      getCurrentCityWeather(p);
    } else {
      print("data unavailable");
    }
  }

  getCurrentCityWeather(Position position) async {
    var client = http.Client();
    var uri =
        '${k.domain}lat=${position.latitude}&lon=${position.longitude}&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = json.decode(data);
      updateUI(decodeData);
      setState(() {
        isLoaded = true;
      });
      print(data);
    } else {
      print(response.statusCode);
    }
  }

  getCityWeather(String cityname) async {
    var client = http.Client();
    var uri = '${k.domain}q=$cityname&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = json.decode(data);
      updateUI(decodeData);
      setState(() {
        isLoaded = true;
      });
      print(data);
    } else {
      print(response.statusCode);
    }
  }

  updateUI(var decodeData) {
    setState(() {
      if (decodeData == null) {
        temp = 0;
        press = 0;
        hum = 0;
        cover = 0;
        cityname = 'Not available';
        mintemp = 0;
        maxtemp = 0;
      } else {
        temp = decodeData['main']['temp'] - 273;
        press = decodeData['main']['pressure'];
        hum = decodeData['main']['humidity'];
        cover = decodeData['clouds']['all'];
        cityname = decodeData['name'];
        maxtemp = decodeData['main']['temp_max'] - 273;
        mintemp = decodeData['main']['temp_min'] - 273;
      }
    });
  }
}
