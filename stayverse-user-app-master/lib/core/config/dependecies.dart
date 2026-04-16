import 'package:stayverse/auth/model/dataSource/network/auth_network_respository.dart';
import 'package:stayverse/auth/model/dataSource/network/auth_network_service.dart';
import 'package:stayverse/core/brimEngine/brim_engine.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/core/config/deviceInfo/app_device_information.dart';
import 'package:stayverse/core/interceptor/bearer_token_inteceptor.dart';
import 'package:stayverse/core/interceptor/content_type_interceptor.dart';
import 'package:stayverse/core/interceptor/user_agent_inteceport.dart';
import 'package:stayverse/core/route/navigation_service.dart';
import 'package:stayverse/core/service/hepatic_touch_service.dart';
import 'package:stayverse/core/service/storage/brim_storage.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/core/util/style/app_style.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:stayverse/feature/apartmentDetails/model/dataSource/aparment_network_service.dart';
import 'package:stayverse/feature/apartmentDetails/model/dataSource/apartment_network_repository.dart';
import 'package:stayverse/feature/bookings/model/dataSource/network/booking_service_network.dart';
import 'package:stayverse/feature/bookings/model/dataSource/network/bookings_repository_network.dart';
import 'package:stayverse/feature/dashboard/model/dataSource/dashboard_network_repository.dart';
import 'package:stayverse/feature/dashboard/model/dataSource/dashboard_network_service.dart';
import 'package:stayverse/feature/favourite/model/dataSource/network/favourite_network_repository.dart';
import 'package:stayverse/feature/favourite/model/dataSource/network/favourite_network_service.dart';
import 'package:stayverse/feature/home/model/dataSource/network/home_network_repository.dart';
import 'package:stayverse/feature/home/model/dataSource/network/home_network_service.dart';
import 'package:stayverse/feature/profile/model/dataSource/network/profile_network_repository.dart';
import 'package:stayverse/feature/profile/model/dataSource/network/profile_network_service.dart';
import 'package:stayverse/feature/search/model/dataSource/network/search_network_repository.dart';
import 'package:stayverse/feature/search/model/dataSource/network/search_network_service.dart';
import 'package:stayverse/feature/wallet/model/dataSource/wallet_network_repository.dart';
import 'package:stayverse/feature/wallet/model/dataSource/wallet_network_service.dart';

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
    ..registerSingleton<HomeNetworkRepository>(
        HomeNetworkRepository(dio: dioConfig()))
    ..registerSingleton<HomeNetworkService>(HomeNetworkService(locator.get()))
    ..registerSingleton<FavouriteNetworkRepository>(
        FavouriteNetworkRepository(dio: dioConfig()))
    ..registerSingleton<FavouriteNetworkService>(
        FavouriteNetworkService(locator.get()))
    ..registerSingleton<ProfileNetworkRepository>(
        ProfileNetworkRepository(dio: dioConfig()))
    ..registerSingleton<ProfileNetworkService>(
        ProfileNetworkService(locator.get()))
    ..registerSingleton<ApartmentDetailsRepository>(
        ApartmentDetailsRepository(dio: dioConfig()))
    ..registerSingleton<AparmentDetailsNetworkService>(
        AparmentDetailsNetworkService(locator.get()))
    ..registerSingleton<SearchNetworkRepository>(
        SearchNetworkRepository(dio: dioConfig()))
    ..registerSingleton<SearchNetworkService>(
        SearchNetworkService(locator.get()))
    ..registerSingleton<BookingNetworkRepository>(
        BookingNetworkRepository(dio: dioConfig()))
    ..registerSingleton<BookingNetworkService>(
        BookingNetworkService(locator.get()))
    ..registerSingleton<DashNetworkRepository>(
        DashNetworkRepository(dio: dioConfig()))
    ..registerSingleton<DashNetworkService>(DashNetworkService(locator.get()))
    ..registerSingleton<WalletNetworkRepository>(
        WalletNetworkRepository(dio: dioConfig()))
    ..registerSingleton<WalletNetworkService>(
        WalletNetworkService(locator.get()));
}

AppStyle get $styles => BrimEngine.style;

GlobalKey<NavigatorState> get $appKey =>
    locator.get<GlobalKey<NavigatorState>>();

BrimToast get $toastService => locator.get<BrimToast>();

BrimStorage get $brimStorage => BrimStorage.instance;

NavigationService get $navigate => locator.get<NavigationService>();

Dio dioConfig() {
  Dio dio = locator<Dio>()
    ..interceptors.add(locator<PrettyDioLogger>())
    ..interceptors.add(locator<ContentTypeInterceptor>())
    ..interceptors.add(locator<BearerTokenInterceptor>())
    ..interceptors.add(locator<UserAgentInterceptor>())
    ..options.baseUrl = Constant.host
    ..options.receiveTimeout = const Duration(seconds: 60)
    ..options.connectTimeout = const Duration(seconds: 60)
    ..options.sendTimeout = const Duration(seconds: 60);

  return dio;
}
