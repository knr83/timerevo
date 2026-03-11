import 'package:drift/drift.dart';

import '../../common/utils/pin_hash.dart';
import '../../common/utils/utc_clock.dart';
import '../../domain/ports/auth_repo_port.dart';
import '../db/app_db.dart';
import 'repo_guard.dart';

class AuthRepo implements IAuthRepo {
  AuthRepo(this._db);

  final AppDb _db;

  @override
  Future<bool> changeAdminPin({
    required String currentPin,
    required String newPin,
  }) => updateAdminPin(currentPin: currentPin, newPin: newPin);

  Future<void> ensureDefaultAdmin({
    String username = 'admin',
    String pin = '0000',
  }) async {
    final existing =
        await (_db.select(_db.users)
              ..where((u) => u.username.equals(username))
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) return;

    return guardRepoCall(() async {
      final now = UtcClock.nowMs();
      final passwordHash = await PinHash.hashForUser(pin);
      await _db
          .into(_db.users)
          .insert(
            UsersCompanion.insert(
              username: username,
              passwordHash: passwordHash,
              role: 'ADMIN',
              createdAt: now,
            ),
          );
    });
  }

  Future<bool> verifyAdminPin({
    String username = 'admin',
    required String pin,
  }) async {
    final user =
        await (_db.select(_db.users)
              ..where(
                (u) =>
                    u.username.equals(username) &
                    u.role.equals('ADMIN') &
                    u.isActive.equals(1),
              )
              ..limit(1))
            .getSingleOrNull();

    if (user == null) return false;
    return PinHash.verifyForUser(pin, user.passwordHash);
  }

  Future<bool> updateAdminPin({
    String username = 'admin',
    required String currentPin,
    required String newPin,
  }) async {
    final user =
        await (_db.select(_db.users)
              ..where(
                (u) =>
                    u.username.equals(username) &
                    u.role.equals('ADMIN') &
                    u.isActive.equals(1),
              )
              ..limit(1))
            .getSingleOrNull();
    if (user == null) return false;

    final ok = await PinHash.verifyForUser(currentPin, user.passwordHash);
    if (!ok) return false;

    final newHash = await PinHash.hashForUser(newPin);
    return guardRepoCall(() async {
      final rows =
          await (_db.update(_db.users)..where((u) => u.id.equals(user.id)))
              .write(UsersCompanion(passwordHash: Value(newHash)));
      return rows > 0;
    });
  }
}
