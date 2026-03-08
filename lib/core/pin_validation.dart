/// Admin PIN format: digits only, at least 4 digits.
bool isValidAdminPinFormat(String pin) => RegExp(r'^\d{4,}$').hasMatch(pin);
