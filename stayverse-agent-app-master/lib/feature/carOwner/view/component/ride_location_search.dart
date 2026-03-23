import 'dart:async';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/service/brimPlace/brim_place.dart';
import 'package:stayvers_agent/core/service/brimPlace/model/data/autocomplete_response.dart'
    show Suggestion;
import 'package:stayvers_agent/core/util/app/debouncer.dart';
import 'package:stayvers_agent/core/util/app/helper.dart';
import 'package:stayvers_agent/core/util/textField/app_text_field.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/component/option_view_builder.dart';
import 'package:stayvers_agent/shared/app_icons.dart';

import '../../controller/ride_advert_controller.dart';

class RideLocationSearch extends ConsumerStatefulWidget {
  final ProviderMode mode;
  const RideLocationSearch({super.key, required this.mode});

  @override
  ConsumerState<RideLocationSearch> createState() => _RideLocationSearchState();
}

class _RideLocationSearchState extends ConsumerState<RideLocationSearch> {
  final _debouncer = DebouncerService(interval: 200.milliseconds);

  @override
  void dispose() {
    _debouncer.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final advertProvider = widget.mode == ProviderMode.create
        ? createRideAdvertProvider
        : editRideAdvertProvider;
    return LayoutBuilder(
      builder: (context, constraints) {
        return RawAutocomplete<Suggestion>(
          textEditingController:
              ref.read(advertProvider.notifier).locationController,
          focusNode: ref.read(advertProvider.notifier).locationFocusNode,
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
                  AppIcon(AppIcons.location, size: 25),
                ],
              ),
              textInputAction: TextInputAction.done,
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
            _onSuggestionSelected(suggestion);
          },
        );
      },
    );
  }

  void _onSuggestionSelected(Suggestion suggestion) {
    closKeyPad(context);
    final placeId = suggestion.placePrediction?.placeId ?? '';
    final locationText =
        suggestion.placePrediction?.structuredFormat?.mainText?.text ?? '';

        final advertProvider = widget.mode == ProviderMode.create 
        ? createRideAdvertProvider 
        : editRideAdvertProvider;

    ref.read(advertProvider.notifier).updatePlaceId(placeId);

    ref.read(advertProvider.notifier).locationController.text =
        locationText;
  }
}
