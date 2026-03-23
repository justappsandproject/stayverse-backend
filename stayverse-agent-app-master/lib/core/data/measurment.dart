enum Measurement {
  m,
  km;
}

extension DoubleExt on double {
  double toMeasurement(Measurement measurement, {int roundOff = 2}) =>
      switch (measurement) {
        Measurement.m => double.parse(toStringAsFixed(roundOff)),
        Measurement.km => double.parse((this / 1000).toStringAsFixed(roundOff))
      };
}
