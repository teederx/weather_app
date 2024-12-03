import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/pages/temp_settings/providers/temp_settings_provider.dart';
import 'package:weather_app/pages/temp_settings/providers/temp_settings_state.dart';

class ShowTemperature extends ConsumerWidget {
  const ShowTemperature({
    super.key,
    required double temperature,
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
  })  : _temperature = temperature,
        _fontSize = fontSize,
        _fontWeight = fontWeight;

  final double _temperature;
  final double _fontSize;
  final FontWeight _fontWeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tempUnit = ref.watch(tempSettingsProvider);

    final currentTemperature = switch (tempUnit) {
      Celsius() => '${_temperature.toStringAsFixed(2)}\u2103',
      Fahrenheit() =>
        '${((_temperature * 9 / 5) + 32).toStringAsFixed(2)}\u2109',
    };
    //'\u2103'unicode for celsius symbol
    //'\u2109' unicode for farrenheit
    return Text(
      currentTemperature,
      style: TextStyle(
        fontSize: _fontSize,
        fontWeight: _fontWeight,
      ),
    );
  }
}
