import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:stayvers_agent/auth/model/dataSource/network/auth_network_respository.dart';
import 'package:stayvers_agent/auth/model/dataSource/network/auth_network_service.dart';
import 'package:stayvers_agent/core/brimEngine/brim_engine.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/config/deviceInfo/app_device_information.dart';
import 'package:stayvers_agent/core/interceptor/bearer_token_inteceptor.dart';
import 'package:stayvers_agent/core/interceptor/content_type_interceptor.dart';
import 'package:stayvers_agent/core/interceptor/user_agent_inteceport.dart';
import 'package:stayvers_agent/core/route/navigation_service.dart';
import 'package:stayvers_agent/core/service/hepatic_touch_service.dart';
import 'package:stayvers_agent/core/service/storage/brim_storage.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/core/util/style/app_style.dart';
import 'package:stayvers_agent/feature/Reviews/model/data_source/network/review_repository_network.dart';
import 'package:stayvers_agent/feature/Reviews/model/data_source/network/review_service_network.dart';
import 'package:stayvers_agent/feature/carOwner/model/dataSource/network/ride_network_respository.dart';
import 'package:stayvers_agent/feature/carOwner/model/dataSource/network/ride_network_service.dart';
import 'package:stayvers_agent/feature/chefOwner/model/dataSoruce/network/chef_profile_network_repository.dart';
import 'package:stayvers_agent/feature/chefOwner/model/dataSoruce/network/chef_profile_network_service.dart';
import 'package:stayvers_agent/feature/dashBoard/model/dataSource/dashboard_network_repository.dart';
import 'package:stayvers_agent/feature/dashBoard/model/dataSource/dashboard_network_service.dart';
import 'package:stayvers_agent/feature/discover/model/dataSource/network/discover_network_repository.dart';
import 'package:stayvers_agent/feature/discover/model/dataSource/network/discover_network_service.dart';
import 'package:stayvers_agent/feature/profile/model/dataSource/network/profile_network_repository.dart';
import 'package:stayvers_agent/feature/profile/model/dataSource/network/profile_network_service.dart';
import 'package:stayvers_agent/feature/wallet/model/dataSource/wallet_network_repository.dart';
import 'package:stayvers_agent/feature/wallet/model/dataSource/wallet_network_service.dart';

import '../../feature/apartmentOwner/model/dataSource/network/apartment_network_respository.dart';
import '../../feature/apartmentOwner/model/dataSource/network/apartment_network_service.dart';

final GetIt locator = GetIt.instance;

final logger = BrimLogger.load('Locator');

void injectDependency() {
  locator
    ..registerSingleton<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>())
    ..registerSingleton<NavigationService>(NavigationService())
    ..registerSingleton<BrimEngine>(BrimEngine())
    ..registerSingleton<ImagePicker>(ImagePicker())
    ..registerLazySingleton<HapticsFeedbackService>(
        () => HapticsFeedbackService())
    ..registerSingleton<ContentTypeInterceptor>(ContentTypeInterceptor())
    ..registerSingleton<BearerTokenInterceptor>(BearerTokenInterceptor())
    ..registerSingleton<UserAgentInterceptor>(UserAgentInterceptor())
    ..registerSingleton<PrettyDioLogger>(PrettyDioLogger(
      enabled: false,
      responseBody: false,
      request: false,
      requestHeader: false,
      responseHeader: false,
      requestBody: false,
    ))
    ..registerSingleton<Dio>(Dio())
    ..registerLazySingleton<BrimDeviceInfo>(() => BrimDeviceInfo())
    ..registerSingleton<AuthNetworkRepository>(
        AuthNetworkRepository(dio: dioConfig()))
    ..registerSingleton<AuthNetworkService>(AuthNetworkService(locator.get()))
    ..registerSingleton<ApartmentNetworkRespository>(
        ApartmentNetworkRespository(dio: dioConfig()))
    ..registerSingleton<ApartmentNetworkService>(
        ApartmentNetworkService(locator.get()))
    ..registerSingleton<RideNetworkRespository>(
        RideNetworkRespository(dio: dioConfig()))
    ..registerSingleton<RideNetworkService>(RideNetworkService(locator.get()))
    ..registerSingleton<ProfileNetworkRepository>(
        ProfileNetworkRepository(dio: dioConfig()))
    ..registerSingleton<ProfileNetworkService>(
        ProfileNetworkService(locator.get()))
    ..registerSingleton<ChefNetworkRepository>(
        ChefNetworkRepository(dio: dioConfig()))
    ..registerSingleton<ChefNetworkService>(ChefNetworkService(locator.get()))
    ..registerSingleton<DiscoverNetworkRepository>(
        DiscoverNetworkRepository(dio: dioConfig()))
    ..registerSingleton<DiscoverNetworkService>(
        DiscoverNetworkService(locator.get()))
    ..registerSingleton<DashboardNetworkRepository>(
        DashboardNetworkRepository(dio: dioConfig()))
    ..registerSingleton<DashboardNetworkService>(
        DashboardNetworkService(locator.get()))
    ..registerSingleton<WalletNetworkRepository>(
        WalletNetworkRepository(dio: dioConfig()))
    ..registerSingleton<WalletNetworkService>(WalletNetworkService(locator.get()))
    ..registerSingleton<ReviewNetworkRepository>(
        ReviewNetworkRepository(dio: dioConfig()))
    ..registerSingleton<ReviewNetworkService>(
        ReviewNetworkService(locator.get()));
    
}

AppStyle get $styles => BrimEngine.style;

GlobalKey<NavigatorState> get $appKey =>
    locator.get<GlobalKey<NavigatorState>>();

BrimStorage get $brimStorage => BrimStorage.instance;

NavigationService get $navigate => locator.get<NavigationService>();

Dio dioConfig() {
  Dio dio = locator<Dio>()
    ..interceptors.add(locator<PrettyDioLogger>())
    ..interceptors.add(locator<ContentTypeInterceptor>())
    ..interceptors.add(locator<BearerTokenInterceptor>())
    ..interceptors.add(locator<UserAgentInterceptor>())
    ..options.baseUrl = Constant.host
    ..options.receiveTimeout = const Duration(seconds: 80)
    ..options.connectTimeout = const Duration(seconds: 80)
    ..options.sendTimeout = const Duration(seconds: 80);

  return dio;
}
