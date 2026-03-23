import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayvers_agent/core/config/evn/env.dart';

class Constant {
  static String host = Env.hostprod;

  static String appName = "Barry";

  static const String inter = "Inter";

  static const String montreal = "Neue Montreal";

  static const String sora = "Sora";

  static const String satoshi = "Satoshi";

  static const String deviceToken = 'deviceToken';
  static const String role = 'agent';
  static const String topic = 'all';

  static const LatLng defaultLocation = LatLng(6.6018, 3.3515);

  static const String defaultApartmentImage =
      "https://storage.googleapis.com/zylag_bucket/stayVerse/apartments/default_apartment.png";

  static const String chatSupportUrl = "https://tawk.to/chat/68d1171589caa6192613d1f4/1j5oc4b5e";
  static const String aboutUsUrl = "https://www.stayversepro.com/";

}
