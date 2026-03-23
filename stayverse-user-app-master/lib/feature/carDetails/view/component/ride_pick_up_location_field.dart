import 'dart:async';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/service/brimPlace/brim_place.dart';
import 'package:stayverse/core/service/brimPlace/model/data/autocomplete_response.dart';
import 'package:stayverse/core/util/app/debouncer.dart';
import 'package:stayverse/core/util/textField/app_text_field.dart';
import 'package:stayverse/feature/carDetails/view/component/option_view_builder.dart';

class RidePickUpLocationField extends ConsumerStatefulWidget {
  final TextEditingController pickUpController;
  final void Function(String placeId, String address)? onLocationSelected;
  const RidePickUpLocationField(
      {super.key,
      required this.pickUpController,
      required this.onLocationSelected});

  @override
  ConsumerState<RidePickUpLocationField> createState() =>
      _RidePickUpLocationFieldState();
}

class _RidePickUpLocationFieldState
    extends ConsumerState<RidePickUpLocationField> {
  final _debouncer = DebouncerService(interval: 200.milliseconds);

  @override
  void dispose() {
    _debouncer.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RawAutocomplete<Suggestion>(
          textEditingController: widget.pickUpController,
          focusNode: FocusNode(),
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<Suggestion>.empty();
            }
            final List<Suggestion> debouncedSuggestions =
                await Future<List<Suggestion>>.delayed(Duration.zero, () {
              final completer = Completer<List<Suggestion>>();
              _debouncer.call(() async {
                final suggestions =
                    await BrimPlace.getPlaces(textEditingValue.text);
                completer.complete(suggestions ?? []);
              }, false);
              return completer.future;
            });
            return debouncedSuggestions;
          },
          displayStringForOption: (Suggestion suggestion) =>
              suggestion.placePrediction?.structuredFormat?.mainText?.text ??
              '',
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return AppTextField(
              hintText: 'Enter Location',
              textInputType: TextInputType.text,
              controller: controller,
              focusNode: focusNode,
              prefixWidget: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 20,
                    color: Color(0XFFFBC036),
                  ),
                ],
              ),
              textInputAction: TextInputAction.done,
              borderRadius: BorderRadius.circular(12),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              disableBorderColor: const Color(0xFFEAEAEA),
              enabledBorderColor: const Color(0xFFEAEAEA),
              focusedBorderColor: const Color(0XFFAAADB7),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return OptionViewBuilder(
              onSelected: onSelected,
              options: options,
              constraints: constraints,
            );
          },
          onSelected: (Suggestion suggestion) {
            final placeId = suggestion.placePrediction?.placeId ?? '';
            final address =
                suggestion.placePrediction?.structuredFormat?.mainText?.text ??
                    '';
            widget.pickUpController.text = address;
            widget.onLocationSelected?.call(placeId, address);
          },
        );
      },
    );
  }

  // void _onSuggestionSelected(Suggestion suggestion) {
  //   closKeyPad(context);
  //   final placeId = suggestion.placePrediction?.placeId ?? '';
  //   final locationText =
  //       suggestion.placePrediction?.structuredFormat?.mainText?.text ?? '';

  //   ref.read(advertProvider.notifier).updatePlaceId(placeId);

  //   ref.read(advertProvider.notifier).locationController.text = locationText;
  // }
}
