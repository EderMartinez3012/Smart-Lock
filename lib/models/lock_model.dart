class Lock {
  final String id;
  final String name;
  final String location;
  final bool isConnected;

  Lock({
    required this.id,
    required this.name,
    required this.location,
    this.isConnected = true,
  });
}
