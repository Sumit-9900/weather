import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_application/provider/weather_provider.dart';
import 'package:weather_application/widgets/search_city.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SearchCity(),
              Consumer<WeatherProvider>(
                builder: (context, value, child) {
                  if (value.isLoading) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
