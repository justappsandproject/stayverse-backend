import 'package:stayverse/core/commonLibs/common_libs.dart';

class DraggableDash extends StatelessWidget {
  const DraggableDash({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.33.sw,
      height: 5.h,
      decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.circular(10)),
    );
  }
}
