import 'package:flutter_animate/flutter_animate.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/feature/search/model/data/map_data.dart';
import 'package:stayverse/feature/search/view/component/map_item_card.dart';

class SearchResultDialog {
  static PersistentBottomSheetController? _bottomSheetController;

  static void showSearchResult(
    GlobalKey<ScaffoldState> scaffoldState,
    MapData mapData,
  ) {
    _bottomSheetController = scaffoldState.currentState?.showBottomSheet(
      (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: MapItemCard(
            data: mapData,
          ).animate().scaleXY(
                begin: 0.8,
                end: 1.0,
                duration: 500.ms,
                curve: Curves.elasticOut,
              ),
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  static void closeSearchResult() {
    _bottomSheetController?.close();
    _bottomSheetController = null;
  }
}
