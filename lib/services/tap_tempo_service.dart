class TapTempoService {
  final List<DateTime> _taps = [];
  final List<Duration> _intervals = [];

  int? registerTap([DateTime? at]) {
    final now = at ?? DateTime.now();

    if (_taps.isNotEmpty) {
      final interval = now.difference(_taps.last);
      if (interval > const Duration(seconds: 2) || interval.isNegative) {
        reset();
      } else {
        _intervals.add(interval);
        if (_intervals.length > 4) {
          _intervals.removeAt(0);
        }
      }
    }

    _taps.add(now);
    if (_taps.length > 5) {
      _taps.removeAt(0);
    }

    if (_intervals.isEmpty) {
      return null;
    }

    final averageMs =
        _intervals
            .map((interval) => interval.inMicroseconds)
            .reduce((value, element) => value + element) /
        _intervals.length /
        1000;
    return (60000 / averageMs).round().clamp(30, 300);
  }

  void reset() {
    _taps.clear();
    _intervals.clear();
  }
}
