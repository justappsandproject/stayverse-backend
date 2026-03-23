import 'package:stayvers_agent/feature/Reviews/model/data/review_args.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/page/edit_apartment_advert_page.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/page/edited_apartment_preview_page.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/edit_ride_advert_page.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/edit_ride_details_form_page.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/edited_preview_page.dart';
import 'package:stayvers_agent/feature/chefOwner/view/page/edit_chef_profile.dart';
import 'package:stayvers_agent/feature/inbox/view/page/chat_support_page.dart';
import 'package:stayvers_agent/feature/profile/view/page/delete_account_page.dart';
import 'package:stayvers_agent/feature/profile/view/page/edit_profile_page.dart';
import 'package:stayvers_agent/feature/profile/view/page/kyc_verification_page.dart';
import 'package:stayvers_agent/feature/wallet/model/data/withdrawal_success_data.dart';
import 'package:stayvers_agent/feature/wallet/view/page/paystack_page.dart';
import 'package:stayvers_agent/shared/viewMultipleImage/model/view_multiple_image_data.dart';
import 'package:stayvers_agent/shared/viewMultipleImage/view/view_multiple_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'package:stayvers_agent/auth/model/data/verify_code_data.dart';
import 'package:stayvers_agent/auth/view/page/forgot_password_page.dart';
import 'package:stayvers_agent/auth/view/page/login_page.dart';
import 'package:stayvers_agent/auth/view/page/reset_password_page.dart';
import 'package:stayvers_agent/auth/view/page/signup_as_page.dart';
import 'package:stayvers_agent/auth/view/page/signup_page.dart';
import 'package:stayvers_agent/auth/view/page/verify_otp_page.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/route/error_screen.dart';
import 'package:stayvers_agent/core/route/page_route.dart';
import 'package:stayvers_agent/feature/Reviews/view/page/reviews_page.dart';
import 'package:stayvers_agent/feature/apartmentOwner/model/data/apartment_response.dart';
import 'package:stayvers_agent/feature/apartmentOwner/model/data/booked_apartment_details_args.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/page/booked_apartment_details_page.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/page/listed_apartment_details.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/page/pending_apartment_details.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/booked_ride_details_args.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/ride_response.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/booked_ride_details_page.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/car_details_form_page.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/car_details_post_page.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/listed_ride_details_page.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/pending_ride_details.dart';
import 'package:stayvers_agent/feature/chat/view/page/chat_page.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/featured_form.dart';
import 'package:stayvers_agent/feature/chefOwner/view/page/chef_profile_page.dart';
import 'package:stayvers_agent/feature/chefOwner/view/page/setup_profile.dart';
import 'package:stayvers_agent/feature/dashBoard/view/page/dashboard_page.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';
import 'package:stayvers_agent/feature/discover/model/data/confirmation_page_args.dart';
import 'package:stayvers_agent/feature/discover/view/component/confirmation_page.dart';
import 'package:stayvers_agent/feature/discover/view/page/discover_chef_page.dart';
import 'package:stayvers_agent/feature/messaging/view/chats.dart';
import 'package:stayvers_agent/feature/profile/view/page/change_password_page.dart';
import 'package:stayvers_agent/feature/profile/view/page/listed_apartment_page.dart';
import 'package:stayvers_agent/feature/profile/view/page/listed_cars_page.dart';
import 'package:stayvers_agent/feature/splashScreen/view/page/onboarding.dart';
import 'package:stayvers_agent/feature/splashScreen/view/page/splash_screen_page.dart';
import 'package:stayvers_agent/feature/wallet/view/page/add_funds_page.dart';
import 'package:stayvers_agent/feature/wallet/view/page/confirm_transfer_page.dart';
import 'package:stayvers_agent/feature/wallet/view/page/pin_input_page.dart';
import 'package:stayvers_agent/feature/wallet/view/page/withdraw_page.dart';
import 'package:stayvers_agent/feature/wallet/view/page/withdraw_refund_page.dart';
import 'package:stayvers_agent/feature/wallet/view/page/withdrawal_successful_page.dart';

import '../../feature/apartmentOwner/view/page/new_advert_preview_page.dart';
import '../../feature/chefOwner/view/component/certification_form.dart';
import '../../feature/chefOwner/view/component/experience_form.dart';

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

      case LoginPage.route:
        const page = LoginPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case SignupAsPage.route:
        const page = SignupAsPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case SignUpPage.route:
        final page = SignUpPage(
          accountType: settings.arguments as ServiceType,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ForgotPasswordPage.route:
        const page = ForgotPasswordPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case VerifyCodePage.route:
        final page = VerifyCodePage(
          codeData: settings.arguments as VerificationCodeData?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ResetPasswordPage.route:
        final page = ResetPasswordPage(
          email: settings.arguments as String,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case DashBoardPage.route:
        const page = DashBoardPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case WithdrawPage.route:
        const page = WithdrawPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case WithdrawalSuccessfulPage.route:
        final page = WithdrawalSuccessfulPage(
            withdrawalData: settings.arguments as WithdrawalSuccessData);
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case WithdrawRefundPage.route:
        const page = WithdrawRefundPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case AddFundsPage.route:
        const page = AddFundsPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ConfirmTransferPage.route:
        const page = ConfirmTransferPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case PinInputPage.route:
        const page = PinInputPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ChatPage.route:
        const page = ChatPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ChangePasswordPage.route:
        const page = ChangePasswordPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case NewAdvertPreviewPage.route:
        const page = NewAdvertPreviewPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ConfirmationPage.route:
        final args = settings.arguments as ConfirmationPageArgs;
        final page = ConfirmationPage(
          message: args.message,
          onContinue: args.onContinue,
          buttonText: args.buttonText,
          underApproval: args.underApproval,
        );
        return CustomMaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => page,
        );

      case BookedApartmentDetailsPage.route:
        final args = settings.arguments as BookedApartmentDetailsArgs;
        final page = BookedApartmentDetailsPage(
          apartmentDetails: args.apartmentDetails,
          isCompleted: args.isCompleted,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ListedApartmentDetailsPage.route:
        final page = ListedApartmentDetailsPage(
          apartmentDetails: args as Apartment?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case SetupProfilePage.route:
        const page = SetupProfilePage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ExperienceForm.route:
        const page = ExperienceForm();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case CertificationForm.route:
        const page = CertificationForm();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ChefProfilePage.route:
        const page = ChefProfilePage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case FeaturedForm.route:
        const page = FeaturedForm();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case CarDetailsFormPage.route:
        const page = CarDetailsFormPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case CarDetailsPostPage.route:
        const page = CarDetailsPostPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case BookedRideDetailsPage.route:
        final args = settings.arguments as BookedRideDetailsArgs;
        final page = BookedRideDetailsPage(
          rideDetails: args.rideDetails,
          isCompleted: args.isCompleted,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ListedRideDetailsPage.route:
        final page = ListedRideDetailsPage(
          rideDetails: args as Ride?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ListedApartmentPage.route:
        const page = ListedApartmentPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ListedCarsPage.route:
        const page = ListedCarsPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ReviewsPage.route:
        final page = ReviewsPage(
          review: args as ReviewArgs,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case PendingApartmentDetails.route:
        final page = PendingApartmentDetails(
          apartmentDetails: args as Booking?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case PendingRideDetails.route:
        final page = PendingRideDetails(
          rideDetails: args as Booking?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case DiscoverChefPage.route:
        const page = DiscoverChefPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case Chats.route:
        final page = Chats(channel: args as Channel);
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case EditRideAdvertPage.route:
        final page = EditRideAdvertPage(ride: args as Ride?);
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case EditRideDetailsFormPage.route:
        final page = EditRideDetailsFormPage(rideId: args as String?);
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case EditedPreviewPage.route:
        final page = EditedPreviewPage(rideId: args as String?);
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case EditApartmentAdvertPage.route:
        final page = EditApartmentAdvertPage(apartment: args as Apartment?);
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case EditedApartmentPreviewPage.route:
        final page = EditedApartmentPreviewPage(
          apartmentId: args as String?,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case PayStackPage.route:
        final page = PayStackPage(url: args as String);
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

      case DeleteAccountPage.route:
        const page = DeleteAccountPage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case ViewMutipleImage.route:
        final page = ViewMutipleImage(
          data: args as ViewMutiplePageData,
        );
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case EditProfilePage.route:
        const page = EditProfilePage();
        return CustomMaterialPageRoute(
            settings: RouteSettings(name: settings.name), builder: (_) => page);

      case EditChefProfilePage.route:
        const page = EditChefProfilePage();
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
