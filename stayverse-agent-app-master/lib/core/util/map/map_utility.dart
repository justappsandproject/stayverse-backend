// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';

class MapUtility {
  final mapLogger = BrimLogger.load(MapUtility);
  MapUtility._internal();

  static final MapUtility _instance = MapUtility._internal();

  static final MapUtility instance = _instance;

  String? _mapStyle;
  BitmapDescriptor? _currentLocationMarkerIcon;
  BitmapDescriptor? _destinationLocationMarkerIcon;
  BitmapDescriptor? _apartmentLocationMarkerIcon;

  factory MapUtility() {
    return _instance;
  }

  Future<void> loadMapAssest() async {
    unawaited(loadMapStyle());
    unawaited(loadDestinationMarkerIcon());
    unawaited(loadCurrentLocationMarkerIcon());
    unawaited(loadApartmentLocationMarkerIcon());
  }

  Future<String?> loadMapStyle() async {
    if (_mapStyle != null) {
      return Future.value(_mapStyle);
    }
    try {
      _mapStyle = await rootBundle.loadString(AppAsset.mapStyle);

      return _mapStyle;
    } catch (e) {
      mapLogger.e('Error Occurred Loading Style ===>>> $e');
      return null;
    }
  }

  Future<void> loadApartmentLocationMarkerIcon() async {
    try {
      _apartmentLocationMarkerIcon ??= await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(45, 45)),
          AppAsset.apartmentMarker);
    } catch (e) {
      mapLogger.e('Error Occurred loadApartmentLocationMarkerIcon ===>>> $e');
    }
  }

  Future<void> loadDestinationMarkerIcon() async {
    try {
      _destinationLocationMarkerIcon ??= await BitmapDescriptor.asset(
          const ImageConfiguration(size: Size(30, 30)), AppAsset.example);
    } catch (e) {
      mapLogger.e('Error Occurred loadDestinationMarkerIcon  ===>>> $e');
    }
  }

  Future<void> loadCurrentLocationMarkerIcon() async {
    try {
      _currentLocationMarkerIcon ??= await BitmapDescriptor.asset(
          const ImageConfiguration(size: Size(20, 30)), AppAsset.example);
    } catch (e) {
      mapLogger.e('Error Occurred loadCurrentLocationMarkerIcon ===>>> $e');
    }
  }

  String? get mapStyle => _mapStyle;
  BitmapDescriptor? get currentLocationMarkerIcon => _currentLocationMarkerIcon;

  BitmapDescriptor? get destinationLocationMarkerIcon =>
      _destinationLocationMarkerIcon;

  BitmapDescriptor? get apartmentLocationMarkerIcon =>
      _apartmentLocationMarkerIcon;

  Future<BitmapDescriptor> creatPriceBitMapMarker(String price) async {
    final TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: price,
        style: const TextStyle(
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    painter.layout();

    final Paint backgroundPaint = Paint()
      ..color = Random().nextInt(10) == 5 ? Colors.amber : Colors.black
      ..style = PaintingStyle.fill;

    final double width = painter.width + 40;
    final double height = painter.height + 20;
    const double arrowHeight = 10.0;
    final double totalHeight = height + arrowHeight;

    final pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Path bubblePath = Path();

    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, height),
      const Radius.circular(15),
    );
    bubblePath.addRRect(rRect);

    const double arrowWidth = 12.0;
    final double arrowX = width / 2;

    bubblePath.moveTo(arrowX - arrowWidth, height);
    bubblePath.lineTo(arrowX, height + arrowHeight);
    bubblePath.lineTo(arrowX + arrowWidth, height);
    bubblePath.close();

    // Draw the entire bubble
    canvas.drawPath(bubblePath, backgroundPaint);

    // Draw text
    painter.paint(
      canvas,
      Offset((width - painter.width) / 2, (height - painter.height) / 2),
    );

    final img = await pictureRecorder.endRecording().toImage(
          width.toInt(),
          (totalHeight).toInt(), // Use total height including arrow
        );
    final data = await img.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
}

class MapHelpers {
  static MapUtility get utility => MapUtility.instance;

  static BitmapDescriptor? get currentLocationMarkerIcon =>
      MapUtility.instance.currentLocationMarkerIcon;

  static BitmapDescriptor? get destinationLocationMarkerIcon =>
      MapUtility.instance.destinationLocationMarkerIcon;

  static BitmapDescriptor? get apartmentLocationMarkerIcon =>
      MapUtility.instance.apartmentLocationMarkerIcon;
}