import 'package:flutter/widgets.dart';
import 'package:stayverse/feature/search/view/component/search_map_view.dart';

class MapViewTab extends StatelessWidget {
  const MapViewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned.fill(child: SearchMapView()),
      ],
    );
  }
}
