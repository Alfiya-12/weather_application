import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_application/screens/homeScreen.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF09203F),Color(0xFF537895)])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Discover the \nweather in your city",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: 200,
                height: 230,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://cdn4.iconfinder.com/data/icons/the-weather-is-nice-today/64/weather_2-512.png',
                        ))),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 10,right: 10,top: 80),
                child: Text(
                  "  Stay informed and prepared with\naccurate forecasts at your fingertips",
                  style: TextStyle(
                    fontSize: 18,color: Colors.white,wordSpacing: 4
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.yellow[600])),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const homeScreen(),
                      ));
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 20,),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
