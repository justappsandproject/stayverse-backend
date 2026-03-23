import 'package:stayverse/core/brimEngine/bootLoaders/app_boot_loaders.dart';
import 'package:stayverse/core/brimEngine/bootLoaders/brim_boot_loader.dart';

final Map<Type, BrimBootLoader> bootLoaders = {
  AppBootLoaders: AppBootLoaders(),
  
};
