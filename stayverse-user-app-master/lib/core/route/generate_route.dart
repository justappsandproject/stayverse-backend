import 'package:flutter/material.dart';
import 'package:stayverse/auth/model/data/verify_code_data.dart';
import 'package:stayverse/auth/view/page/forgot_password.dart';
import 'package:stayverse/auth/view/page/login_page.dart';
import 'package:stayverse/auth/view/page/reset_password.dart';
import 'package:stayverse/auth/view/page/sign_up_page.dart';
import 'package:stayverse/auth/view/page/verify_otp_page.dart';
import 'package:stayverse/core/route/error_screen.dart';
import 'package:stayverse/core/route/page_route.dart';
import 'package:stayverse/feature/apartmentDetails/model/data/booking_data.dart';
import 'package:stayverse/feature/apartmentDetails/view/page/apartment_bookings_page.dart';
import 'package:stayverse/feature/apartmentDetails/view/page/apartment_details_page.dart';
import 'package:stayverse/feature/apartmentDetails/view/page/apartment_payment_page.dart';
import 'package:stayverse/feature/apartmentDetails/view/page/booking_confrimed.dart';
import 'package:stayverse/feature/bookings/model/data/booking_response.dart';
import 'package:stayverse/feature/bookings/model/data/leave_a_review_args.dart';
import 'package:stayverse/feature/bookings/view/page/apartment_booked_page.dart';
import 'package:stayverse/feature/bookings/view/page/car_booked_page.dart';
import 'package:stayverse/feature/bookings/view/page/chef_booked_page.dart';
import 'package:stayverse/feature/bookings/view/page/confirm_bookings_page.dart';
import 'package:stayverse/feature/bookings/view/page/leave_a_review_page.dart';
import 'package:stayverse/feature/bookings/view/page/reviews_page.dart';
import 'package:stayverse/feature/carDetails/model/booking_data.dart';
import 'package:stayverse/feature/carDetails/view/page/car_bookings_page.dart';
import 'package:stayverse/feature/carDetails/view/page/car_detail_page.dart';
import 'package:stayverse/feature/carDetails/view/page/car_payment_confirm_page.dart';
import 'package:stayverse/feature/carDetails/view/page/car_payment_page_widget.dart';
import 'package:stayverse/feature/chat/view/page/chat_page.dart';
import 'package:stayverse/feature/chefDetails/view/page/chef_profile_page.dart';
import 'package:stayverse/feature/dashboard/view/page/dashboard_page.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/home/model/data/ride_response.dart';
import 'package:stayverse/feature/inbox/view/page/chat_support_page.dart';
import 'package:stayverse/feature/inbox/view/page/inbox_page.dart';
import 'package:stayverse/feature/messaging/view/chats.dart';
import 'package:stayverse/feature/profile/view/page/change_password_page.dart';
import 'package:stayverse/feature/profile/view/page/delete_account_page.dart';
import 'package:stayverse/feature/profile/view/page/edit_profile_page.dart';
import 'package:stayverse/feature/profile/view/page/kyc_verification_page.dart';
import 'package:stayverse/feature/search/view/page/apartment_filter_page.dart';
import 'package:stayverse/feature/search/view/page/car_filter_page.dart';
import 'package:stayverse/feature/search/view/page/chef_filter_page.dart';
import 'package:stayverse/feature/search/view/page/search_result_page.dart';
import 'package:stayverse/feature/splashScreen/view/page/onboarding.dart';
import 'package:stayverse/feature/splashScreen/view/page/pick_an_experience.dart';
import 'package:stayverse/feature/splashScreen/view/page/splash_screen_page.dart';
import 'package:stayverse/feature/wallet/model/data/withdrawal_success_data.dart';
import 'package:stayverse/feature/wallet/view/page/add_funds_page.dart';
import 'package:stayverse/feature/wallet/view/page/confirm_payment_page.dart';
import 'package:stayverse/feature/wallet/view/page/confirmation_page.dart';
import 'package:stayverse/feature/wallet/view/page/create_pin_page.dart';
import 'package:stayverse/feature/wallet/view/page/paystack_page.dart';
import 'package:stayverse/feature/wallet/view/page/pin_page.dart';
import 'package:stayverse/feature/wallet/view/page/wallet_page_widget.dart';
import 'package:stayverse/feature/wallet/view/page/withdrawal_page.dart';
import 'package:stayverse/feature/wallet/view/page/withdrawal_successful_page.dart';
import 'package:stayverse/shared/viewMutipleImage/model/view_mutiple_image_data.dart';
import 'package:stayverse/shared/viewMutipleImage/view/view_mutiple_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    var args = settings.arguments;

    switch (settings.name) {
      case SplashScreenPage.route:
        const page = SplashScreenPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case OnboardingScreen.route:
        const page = OnboardingScreen();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case SignUpPage.route:
        const page = SignUpPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case LoginPage.route:
        const page = LoginPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ForgotPasswordPage.route:
        const page = ForgotPasswordPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ResetPasswordPage.route:
        final page = ResetPasswordPage(
          email: settings.arguments as String?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ChangePasswordPage.route:
        const page = ChangePasswordPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case VerifyCodePage.route:
        final page = VerifyCodePage(
          codeData: settings.arguments as VerificationCodeData?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case DashbBoardScreenPage.route:
        const page = DashbBoardScreenPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case SearchResultPage.route:
        const page = SearchResultPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ApartmentDetailsPage.route:
        final page = ApartmentDetailsPage(
          apartment: args as Apartment?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ApartmentBookingsPage.route:
        final page = ApartmentBookingsPage(
          apartment: args as Apartment?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case CarDetailPage.route:
        final page =
            CarDetailPage(ride: args as Ride?); // page = CarDetailPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case CarBookingsPage.route:
        final page = CarBookingsPage(
          ride: args as Ride?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case CarBookedPage.route:
        final page = CarBookedPage(
          data: args as Booking?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ApartmentBookedPage.route:
        final page = ApartmentBookedPage(
          data: args as Booking?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ConfirmBookingsPage.route:
        const page = ConfirmBookingsPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ChatPage.route:
        final page = ChatPage(channel: args as Channel);
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case KycVerificationPage.route:
        const page = KycVerificationPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ChatSupportPage.route:
        final page = ChatSupportPage(url: args as String);
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case InboxPage.route:
        const page = InboxPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case WalletPage.route:
        const page = WalletPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case PayStackPage.route:
        final page = PayStackPage(url: args as String);
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case AddFundsPage.route:
        const page = AddFundsPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case PinPage.route:
        const page = PinPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case CreatePinPage.route:
        const page = CreatePinPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ApartmentFilterPage.route:
        const page = ApartmentFilterPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ConfirmPaymentPage.route:
        const page = ConfirmPaymentPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case WithdrawalSuccessfulPage.route:
        final page = WithdrawalSuccessfulPage(
          withdrawalData: args as WithdrawalSuccessData,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case CarFilterPage.route:
        const page = CarFilterPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ChefFilterPage.route:
        const page = ChefFilterPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ConfirmationPage.route:
        const page = ConfirmationPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ChefProfilePage.route:
        final page = ChefProfilePage(
          chef: args as Chef?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ApartmentPaymentPage.route:
        final page = ApartmentPaymentPage(
          bookingData: args as BookingData?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ApartmentBookingConfrim.route:
        final page = ApartmentBookingConfrim(bookingData: args as BookingData?);
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case CarPaymentPage.route:
        final page = CarPaymentPage(
          bookingData: args as RideBookingData?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case CarBookingConfrim.route:
        final page = CarBookingConfrim(
          bookingData: args as RideBookingData?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ViewMutipleImage.route:
        final page = ViewMutipleImage(
          data: args as ViewMutiplePageData,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case Chats.route:
        final page = Chats(
          channel: args as Channel,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case WithdrawPage.route:
        const page = WithdrawPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case DeleteAccountPage.route:
        const page = DeleteAccountPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ChefBookedPage.route:
        final page = ChefBookedPage(
          data: args as Booking?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case PickAnExperience.route:
        const page = PickAnExperience();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case LeaveAReviewPage.route:
        final page = LeaveAReviewPage(
          review: args as LeaveAReviewArgs,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ReviewsPage.route:
        final page = ReviewsPage(
          review: args as LeaveAReviewArgs,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case EditProfilePage.route:
        const page = EditProfilePage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      default:
        return CustomMaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => RouteErrorScreen(
            route: settings.name,
          ),
        );
    }
  }
}
