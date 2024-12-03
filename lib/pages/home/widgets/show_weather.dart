// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/models/current_weather/app_weather.dart';
import 'package:weather_app/models/custom_error/custom_error.dart';
import 'package:weather_app/pages/home/widgets/format_text.dart';
import 'package:weather_app/pages/home/widgets/select_city.dart';
import 'package:weather_app/pages/home/widgets/show_temperature.dart';

import '../../../models/current_weather/current_weather.dart';
import 'show_icon.dart';

class ShowWeather extends ConsumerWidget {
  const ShowWeather({
    super.key,
    required this.weatherState,
  });
  final AsyncValue<CurrentWeather?> weatherState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return weatherState.when(
      skipError: true,
      data: (weather) {
        print('*** is data callback');

        if (weather == null) {
          return const SelectCity();
        }

        final appWeather = AppWeather.fromCurrentWeather(weather);

        return ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Text(
              appWeather.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(DateTime.now()).format(context),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '(${appWeather.country})',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowTemperature(
                  temperature: appWeather.temp,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Column(
                  children: [
                    ShowTemperature(
                      temperature: appWeather.tempMax,
                      fontSize: 16,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ShowTemperature(
                      temperature: appWeather.tempMin,
                      fontSize: 16,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Spacer(),
                ShowIcon(icon: appWeather.icon),
                Expanded(
                  flex: 3,
                  child: FormatText(description: appWeather.description),
                ),
                const Spacer(),
              ],
            ),
          ],
        );
      },
      error: (error, str) {
        print('*** in error callback');
        if (weatherState.value == null) {
          return const SelectCity();
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              (error as CustomError).errMsg,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
