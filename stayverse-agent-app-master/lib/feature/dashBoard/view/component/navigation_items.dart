import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/page/add_new_advert_page.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/create_new_advert.dart';
import 'package:stayvers_agent/feature/dashBoard/controller/dashboard_controller.dart';
import 'package:stayvers_agent/feature/discover/view/page/apartment_discover_page.dart';
import 'package:stayvers_agent/feature/discover/view/page/discover_chef_page.dart';
import 'package:stayvers_agent/feature/discover/view/page/ride_discover_page.dart';
import 'package:stayvers_agent/feature/messaging/view/messages.dart';
import 'package:stayvers_agent/feature/profile/view/page/profile_page.dart';
import 'package:stayvers_agent/feature/wallet/view/page/wallet_page.dart';
import 'package:stayvers_agent/shared/app_icons.dart';

class NavigationItem {
  final AppIcons icon;
  final String label;
  final Color activeColor;
  final Widget screen;
  final bool isActionButton;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.activeColor,
    required this.screen,
    this.isActionButton = false,
  });
}

class NavigationItems {
  static List<NavigationItem> items(WidgetRef ref) {
    final serviceType = ref.watch(
        dashboadController.select((state) => state.user?.agent?.serviceType));
    return [
      // Discover Item - Different for each account type
      NavigationItem(
        icon: AppIcons.discover,
        label: 'Discover',
        activeColor: $styles.colors.light.primaryAccent,
        screen: _getDiscoverScreen(serviceType),
      ),

      // Wallet Item - Same for all account types
      NavigationItem(
        icon: AppIcons.wallet,
        label: 'Wallet',
        activeColor: $styles.colors.light.primaryAccent,
        screen: const WalletPage(),
      ),

      // Bookings/Add Item - Different for each account type
      NavigationItem(
        icon: _getMiddleTabIcon(serviceType),
        label: _getMiddleTabLabel(serviceType),
        activeColor: $styles.colors.light.primaryAccent,
        screen: _getMiddleTabScreen(serviceType),
        isActionButton: serviceType == ServiceType.chef,
      ),

      // Inbox Item - Same for all account types
      NavigationItem(
        icon: AppIcons.message,
        label: 'Inbox',
        activeColor: $styles.colors.light.primaryAccent,
        screen: const MessagesPage(),
      ),

      // Profile Item - Same for all account types
      NavigationItem(
        icon: AppIcons.profile,
        label: 'Me',
        activeColor: $styles.colors.light.primaryAccent,
        screen: const ProfilePage(),
      ),
    ];
  }

  static Widget _getDiscoverScreen(ServiceType? accountType) {
    switch (accountType) {
      case ServiceType.chef:
        return const DiscoverChefPage();
      case ServiceType.apartmentOwner:
        return const ApartmentDiscoverPage();
      case ServiceType.carOwner:
        return const RideDiscoverPage();
      default:
        return const ApartmentDiscoverPage();
    }
  }

  // Helper method to get the correct middle tab icon
  static AppIcons _getMiddleTabIcon(ServiceType? accountType) {
    switch (accountType) {
      case ServiceType.chef:
        return AppIcons.chef_radio;
      case ServiceType.apartmentOwner:
        return AppIcons.add;
      case ServiceType.carOwner:
        return AppIcons.add;
      default:
        return AppIcons.add;
    }
  }

  // Helper method to get the correct middle tab label
  static String _getMiddleTabLabel(ServiceType? accountType) {
    switch (accountType) {
      case ServiceType.chef:
        return 'Add Dish';
      case ServiceType.apartmentOwner:
        return 'Add Property';
      case ServiceType.carOwner:
        return 'Add Vehicle';
      default:
        return 'Add';
    }
  }

  // Helper method to get the correct middle tab screen
  static Widget _getMiddleTabScreen(ServiceType? accountType) {
    switch (accountType) {
      case ServiceType.chef:
        return const SizedBox();
      case ServiceType.apartmentOwner:
        return const ApartmentAdvert();
      case ServiceType.carOwner:
        return const CreateCarAdvert();
      default:
        return const SizedBox();
    }
  }
}
