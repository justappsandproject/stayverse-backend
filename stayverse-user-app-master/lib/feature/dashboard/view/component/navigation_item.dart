import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/feature/bookings/view/page/bookings_page.dart';
import 'package:stayverse/feature/favourite/view/page/favorite_page.dart';
import 'package:stayverse/feature/home/view/page/home.dart';
import 'package:stayverse/feature/messaging/view/messages.dart';
import 'package:stayverse/feature/profile/view/page/profile_page.dart';
import 'package:stayverse/shared/app_icons.dart';

class NavigationItem {
  final AppIcons icon;
  final String label;
  final Color activeColor;
  final Widget screen;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.activeColor,
    required this.screen,
  });
}

class NavigationItems {
  static final items = [
    NavigationItem(
      icon: AppIcons.home,
      label: 'Discover',
      activeColor: $styles.colors.light.primaryAccent,
      screen: const HomePage(),
    ),
    NavigationItem(
      icon: AppIcons.favourite,
      label: 'Favourite',
      activeColor: $styles.colors.light.primaryAccent,
      screen: const FavouritePage(),
    ),
    NavigationItem(
      icon: AppIcons.bookings,
      label: 'Bookings',
      activeColor: $styles.colors.light.primaryAccent,
      screen: const BookingsPage(),
    ),
    NavigationItem(
      icon: AppIcons.inbox,
      label: 'Inbox',
      activeColor: $styles.colors.light.primaryAccent,
      screen: const MessagesPage(),
    ),
    NavigationItem(
      icon: AppIcons.profile,
      label: 'Me',
      activeColor: $styles.colors.light.primaryAccent,
      screen: const ProfilePage(),
    ),
  ];
}
