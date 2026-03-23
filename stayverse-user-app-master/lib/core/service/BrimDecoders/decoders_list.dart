import 'package:stayverse/core/service/brimPlace/model/data/autocomplete_response.dart';
import 'package:stayverse/core/service/brimPlace/model/data/reverse_geo_code_response.dart';
import 'package:stayverse/core/service/brimPlace/model/data/route_response.dart';

class BrimDecoratorsList {
  static final decorators = {
    AutoCompleteResponse: (data) => AutoCompleteResponse.fromJson(data),
    ReverseGeoResponse: (data) => ReverseGeoResponse.fromJson(data),
    Suggestion: (data) => Suggestion.fromJson(data),
    RouteResponse: (data) => RouteResponse.fromJson(data)
  };
}
