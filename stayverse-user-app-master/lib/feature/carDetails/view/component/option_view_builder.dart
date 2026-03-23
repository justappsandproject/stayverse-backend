import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/service/brimPlace/model/data/autocomplete_response.dart' show Suggestion;

class OptionViewBuilder extends StatelessWidget {
  final BoxConstraints constraints;
  final Iterable<Suggestion> options;
  final void Function(Suggestion) onSelected;
  
  const OptionViewBuilder({
    super.key,
    required this.constraints,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        child: SizedBox(
          width: constraints.maxWidth,
          child: ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: options.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final suggestion = options.elementAt(index);
              return ListTile(
                title: Text(
                  suggestion.placePrediction?.structuredFormat?.mainText?.text ?? '',
                  style: $styles.text.h1.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  suggestion.placePrediction?.structuredFormat?.secondaryText?.text ?? '',
                  style: $styles.text.h1.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  onSelected(suggestion);
                },
              );
            },
          ),
        ),
      ),
    ).paddingOnly(top: 5);
  }
}