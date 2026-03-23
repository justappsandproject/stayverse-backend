import 'package:equatable/equatable.dart';

class AutoCompleteResponse {
  final List<Suggestion>? suggestions;

  AutoCompleteResponse({
    this.suggestions,
  });

  AutoCompleteResponse copyWith({
    List<Suggestion>? suggestions,
  }) =>
      AutoCompleteResponse(
        suggestions: suggestions ?? this.suggestions,
      );

  factory AutoCompleteResponse.fromJson(Map<String, dynamic> json) =>
      AutoCompleteResponse(
        suggestions: json["suggestions"] == null
            ? []
            : List<Suggestion>.from(
                json["suggestions"]!.map((x) => Suggestion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "suggestions": suggestions == null
            ? []
            : List<dynamic>.from(suggestions!.map((x) => x.toJson())),
      };
}

class Suggestion extends Equatable {
  final PlacePrediction? placePrediction;

  const Suggestion({
    this.placePrediction,
  });

  Suggestion copyWith({
    PlacePrediction? placePrediction,
  }) =>
      Suggestion(
        placePrediction: placePrediction ?? this.placePrediction,
      );

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
        placePrediction: json["placePrediction"] == null
            ? null
            : PlacePrediction.fromJson(json["placePrediction"]),
      );

  Map<String, dynamic> toJson() => {
        "placePrediction": placePrediction?.toJson(),
      };

  @override
  List<Object?> get props => [placePrediction];
}

class PlacePrediction extends Equatable {
  final String? place;
  final String? placeId;
  final SecondaryText? text;
  final StructuredFormat? structuredFormat;
  final List<String>? types;

  const PlacePrediction({
    this.place,
    this.placeId,
    this.text,
    this.structuredFormat,
    this.types,
  });

  PlacePrediction copyWith({
    String? place,
    String? placeId,
    SecondaryText? text,
    StructuredFormat? structuredFormat,
    List<String>? types,
  }) =>
      PlacePrediction(
        place: place ?? this.place,
        placeId: placeId ?? this.placeId,
        text: text ?? this.text,
        structuredFormat: structuredFormat ?? this.structuredFormat,
        types: types ?? this.types,
      );

  factory PlacePrediction.fromJson(Map<String, dynamic> json) =>
      PlacePrediction(
        place: json["place"],
        placeId: json["placeId"],
        text:
            json["text"] == null ? null : SecondaryText.fromJson(json["text"]),
        structuredFormat: json["structuredFormat"] == null
            ? null
            : StructuredFormat.fromJson(json["structuredFormat"]),
        types: json["types"] == null
            ? []
            : List<String>.from(json["types"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "place": place,
        "placeId": placeId,
        "text": text?.toJson(),
        "structuredFormat": structuredFormat?.toJson(),
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
      };

  @override
  List<Object?> get props => [placeId];
}

class StructuredFormat {
  final MainText? mainText;
  final SecondaryText? secondaryText;

  StructuredFormat({
    this.mainText,
    this.secondaryText,
  });

  StructuredFormat copyWith({
    MainText? mainText,
    SecondaryText? secondaryText,
  }) =>
      StructuredFormat(
        mainText: mainText ?? this.mainText,
        secondaryText: secondaryText ?? this.secondaryText,
      );

  factory StructuredFormat.fromJson(Map<String, dynamic> json) =>
      StructuredFormat(
        mainText: json["mainText"] == null
            ? null
            : MainText.fromJson(json["mainText"]),
        secondaryText: json["secondaryText"] == null
            ? null
            : SecondaryText.fromJson(json["secondaryText"]),
      );

  Map<String, dynamic> toJson() => {
        "mainText": mainText?.toJson(),
        "secondaryText": secondaryText?.toJson(),
      };
}

class MainText {
  final String? text;
  final List<MainTextMatch>? matches;

  MainText({
    this.text,
    this.matches,
  });

  MainText copyWith({
    String? text,
    List<MainTextMatch>? matches,
  }) =>
      MainText(
        text: text ?? this.text,
        matches: matches ?? this.matches,
      );

  factory MainText.fromJson(Map<String, dynamic> json) => MainText(
        text: json["text"],
        matches: json["matches"] == null
            ? []
            : List<MainTextMatch>.from(
                json["matches"]!.map((x) => MainTextMatch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "matches": matches == null
            ? []
            : List<dynamic>.from(matches!.map((x) => x.toJson())),
      };
}

class MainTextMatch {
  final int? endOffset;

  MainTextMatch({
    this.endOffset,
  });

  MainTextMatch copyWith({
    int? endOffset,
  }) =>
      MainTextMatch(
        endOffset: endOffset ?? this.endOffset,
      );

  factory MainTextMatch.fromJson(Map<String, dynamic> json) => MainTextMatch(
        endOffset: json["endOffset"],
      );

  Map<String, dynamic> toJson() => {
        "endOffset": endOffset,
      };
}

class SecondaryText {
  final String? text;
  final List<TextMatch>? matches;

  SecondaryText({
    this.text,
    this.matches,
  });

  SecondaryText copyWith({
    String? text,
    List<TextMatch>? matches,
  }) =>
      SecondaryText(
        text: text ?? this.text,
        matches: matches ?? this.matches,
      );

  factory SecondaryText.fromJson(Map<String, dynamic> json) => SecondaryText(
        text: json["text"],
        matches: json["matches"] == null
            ? []
            : List<TextMatch>.from(
                json["matches"]!.map((x) => TextMatch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "matches": matches == null
            ? []
            : List<dynamic>.from(matches!.map((x) => x.toJson())),
      };
}

class TextMatch {
  final int? endOffset;
  final int? startOffset;

  TextMatch({
    this.endOffset,
    this.startOffset,
  });

  TextMatch copyWith({
    int? endOffset,
    int? startOffset,
  }) =>
      TextMatch(
        endOffset: endOffset ?? this.endOffset,
        startOffset: startOffset ?? this.startOffset,
      );

  factory TextMatch.fromJson(Map<String, dynamic> json) => TextMatch(
        endOffset: json["endOffset"],
        startOffset: json["startOffset"],
      );

  Map<String, dynamic> toJson() => {
        "endOffset": endOffset,
        "startOffset": startOffset,
      };
}
