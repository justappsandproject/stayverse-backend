import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';

class LinearImageLoadingProgress extends StatelessWidget {
  final ImageChunkEvent? loadingProgress;
  
  const LinearImageLoadingProgress({
    super.key,
    this.loadingProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LinearProgressIndicator(
        minHeight: 2,
        value: loadingProgress?.expectedTotalBytes != null
            ? loadingProgress!.cumulativeBytesLoaded /
                (loadingProgress!.expectedTotalBytes ?? 1)
            : null,
        color: context.color.primary,
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }
}
