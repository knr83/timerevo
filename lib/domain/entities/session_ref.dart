/// Minimal reference to an open session. Use case only needs to check existence.
class SessionRef {
  const SessionRef({required this.id});

  final int id;
}
