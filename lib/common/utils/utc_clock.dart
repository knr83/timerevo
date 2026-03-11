class UtcClock {
  static int nowMs() => DateTime.now().toUtc().millisecondsSinceEpoch;
}
