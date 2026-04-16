class LocationPrivacy {
  static String extractArea(String? fullAddress) {
    final address = (fullAddress ?? '').trim();
    if (address.isEmpty) return 'Location not available';

    final parts = address
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'Location not available';
    if (parts.length == 1) return parts.first;

    // Typical address ordering is street, area, city/state.
    return parts.length >= 3 ? parts[1] : parts.first;
  }
}
