/// Port for auth operations. Use cases depend on this; data layer implements.
abstract interface class IAuthRepo {
  /// Changes admin PIN. Returns true if successful, false if current PIN invalid.
  Future<bool> changeAdminPin({
    required String currentPin,
    required String newPin,
  });
}
