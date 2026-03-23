import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayverse/core/config/evn/env.dart';

class Constant {
  static String host = Env.hostprod;

  static String appName = "Barry";

  static const String inter = "Inter";

  static const String montreal = "Neue Montreal";

  static const String sora = "Sora";

  static const String satoshi = "Satoshi";

  static const String role = "user";

  static const String deviceToken = 'deviceToken';

  static const String topic = "all";

  static const LatLng defaultLocation = LatLng(6.6018, 3.3515);

  static const double cautionFeePercentage = 50000;

  static const String defaultApartmentImage =
      "https://storage.googleapis.com/zylag_bucket/stayVerse/apartments/default_apartment.png";

  static const String androidId = "com.stayverse.agent.app";

  static const String iosId = "6751253554";
}
