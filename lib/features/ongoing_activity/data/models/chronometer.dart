class Chronometer {

  Duration value;
  static const Duration _interval = Duration(seconds: 1);
  Chronometer({required this.value});

  Stream<Duration> tick() {
    return Stream.periodic(_interval, (x) {
      value += _interval;
      return value;
    });
  }
}
