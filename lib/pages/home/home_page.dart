import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/constants/constants.dart';
import 'package:weather_app/extensions/async_value_xx.dart';
import 'package:weather_app/models/current_weather/app_weather.dart';
import 'package:weather_app/models/current_weather/current_weather.dart';
import 'package:weather_app/models/custom_error/custom_error.dart';
import 'package:weather_app/pages/home/providers/theme_provider.dart';
import 'package:weather_app/pages/home/providers/theme_state.dart';
import 'package:weather_app/pages/home/providers/weather_provider.dart';
import 'package:weather_app/pages/search/search_page.dart';
import 'package:weather_app/pages/temp_settings/temp_settings_page.dart';
import 'package:weather_app/services/providers/weather_api_services_provider.dart';
import 'package:weather_app/widgets/error_dialog.dart';

import 'widgets/show_weather.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? city;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getInitialLocation();
  }

  void showGeolocationError(String errorMsg) {
    Future.delayed(
      Duration.zero,
      () {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$errorMsg using $kDefaultLocation'),
          ),
        );
      },
    );
  }

  Future<bool> getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      showGeolocationError('Location services are disabled.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        showGeolocationError('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      showGeolocationError(
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  void getInitialLocation() async {
    final bool permitted = await getLocationPermission();

    if (permitted) {
      try {
        setState(() {
          loading = true;
        });

        final pos = await Geolocator.getCurrentPosition();
        city = await ref
            .read(weatherApiServicesProvider)
            .getReverseGeocoding(pos.latitude, pos.longitude);
      } catch (e) {
        city = kDefaultLocation;
      } finally {
        setState(() {
          loading = false;
        });
      }
    } else {
      //if we don't have the user's permission use default location
      city = kDefaultLocation;
    }
    ref.read(weatherProvider.notifier).fetchWeather(city: city!);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<CurrentWeather?>>(
      weatherProvider,
      (prev, next) {
        next.whenOrNull(
            error: (e, str) => errorDialog(
                  context,
                  (e as CustomError).errMsg,
                ),
            data: (currentWeather) {
              if (currentWeather == null) {
                return;
              }
              final weather = AppWeather.fromCurrentWeather(currentWeather);
              if (weather.temp < kWarmOrNot) {
                ref.read(themeProvider.notifier).changeTheme(const DarkTheme());
              } else {
                ref
                    .read(themeProvider.notifier)
                    .changeTheme(const LightTheme());
              }
            });
      },
    );

    final weatherState = ref.watch(weatherProvider);
    print(weatherState.toStr);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            onPressed: () async {
              city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
              print(city);

              if (city != null) {
                ref.read(weatherProvider.notifier).fetchWeather(city: city!);
              }
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TempSettingsPage(),
                ),
              );
            },
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ShowWeather(weatherState: weatherState),
      floatingActionButton: FloatingActionButton(
        onPressed: city == null
            ? null
            : () {
                ref.read(weatherProvider.notifier).fetchWeather(city: city!);
              },
        child: const Icon(Icons.refresh_rounded),
      ),
    );
  }
}
