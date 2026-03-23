import 'package:dio/dio.dart';
import 'package:stayverse/core/config/evn/env.dart';
import 'package:stayverse/core/service/brimPlace/model/data/autocomplete_response.dart';
import 'package:stayverse/core/service/brimPlace/model/data/place_details_response.dart';
import 'package:stayverse/core/service/brimPlace/model/data/reverse_geo_code_response.dart';
import 'package:stayverse/core/service/brimPlace/model/data/route_headers.dart';
import 'package:stayverse/core/service/brimPlace/model/data/route_request.dart';
import 'package:stayverse/core/service/brimPlace/model/data/route_response.dart';
import 'package:stayverse/core/util/app/helper.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BrimPlace {
  static final _log = BrimLogger.load('BrimPlace');

  static Future<List<Suggestion>?> getPlaces(String query,
      {LatLng? centerSearch, int? spreadRadius}) async {
    if (isEmpty(query)) return null;

    try {
      Response response = await Dio().post(_BrimPlaceApis.autoCompletePlaceApi,
          data: {
            "input": query.trim(),
            "locationBias": {
              "circle": {
                "center": {
                  "latitude": centerSearch?.latitude ?? 6.5244,
                  "longitude": centerSearch?.longitude ?? 3.3792
                },
                "radius": spreadRadius ?? 50000.0
              }
            },
            "includedRegionCodes": ["ng"]
          },
          options: Options(headers: {
            "X-Goog-Api-Key": Env.gooleApiKey,
            "Content-Type": "application/json"
          }));

      if (response.statusCode == 200) {
        if (response.data == null) return null;
        return dataToModel<AutoCompleteResponse>(data: response.data)
            .suggestions;
      }

      return null;
    } catch (e) {
      _log.i(e.toString());
      return null;
    }
  }

  static Future<ReverseGeoResponse?> getAddress(
    LatLng? coordinates,
  ) async {
    if (coordinates == null) return null;

    try {
      Response response = await Dio().get(
        _BrimPlaceApis.geocodeApi,
        queryParameters: {
          'latlng': '${coordinates.latitude},${coordinates.longitude}',
          'key': Env.gooleApiKey,
        },
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        return dataToModel<ReverseGeoResponse>(data: response.data);
      }

      return null;
    } catch (e) {
      _log.i(e.toString());
      return null;
    }
  }

  static Future<PlaceDetailsResponse?> getLatLngFromPlaceId(
      String placeId) async {
    try {
      Response response = await Dio().get(
        _BrimPlaceApis.placeDetailsApi,
        queryParameters: {
          'place_id': placeId,
          'key': Env.gooleApiKey,
        },
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        return PlaceDetailsResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      _log.i(e.toString());
      return null;
    }
  }

  static Future<RouteResponse?> getRoutes(
      RoutesRequest routeRequest, RouteHeaders routeHeaders) async {
    try {
      Response response = await Dio().post(_BrimPlaceApis.routeApi,
          data: routeRequest.toJson(),
          options: Options(headers: routeHeaders.toHeaders()));

      if (response.statusCode == 200) {
        final responseData = dataToModel<RouteResponse>(data: response.data);

        return responseData;
      }

      return null;
    } catch (e) {
      _log.i(e.toString());
      return null;
    }
  }
}

class _BrimPlaceApis {
  static const String geocodeApi =
      'https://maps.googleapis.com/maps/api/geocode/json';

  static const String autoCompletePlaceApi =
      'https://places.googleapis.com/v1/places:autocomplete';

  static const String routeApi =
      'https://routes.googleapis.com/directions/v2:computeRoutes';

  static const placeDetailsApi =
      "https://maps.googleapis.com/maps/api/place/details/json";
}
