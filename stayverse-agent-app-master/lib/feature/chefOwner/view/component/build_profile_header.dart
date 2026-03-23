import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/financial/money_service_v2.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/Reviews/model/data/review_args.dart';
import 'package:stayvers_agent/feature/Reviews/view/page/reviews_page.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_profile_response.dart';
import 'package:stayvers_agent/feature/chefOwner/view/page/edit_chef_profile.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/image_loading_progress.dart';

class ProfileHeader extends StatelessWidget {
  final ChefProfileData? chefProfileData;
  const ProfileHeader({super.key, required this.chefProfileData});

  @override
  Widget build(BuildContext context) {
    final String profileImage = chefProfileData?.profilePicture ?? '';
    final String coverImage = chefProfileData?.coverPhoto ?? '';
    final String isApproved = chefProfileData?.status ?? 'pending';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.06),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Cover Image Container
                  Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: coverImage.isNotEmpty
                        ? Image.network(
                            coverImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 180,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 180,
                                width: double.infinity,
                                color: Colors.grey.shade200,
                                child: LinearImageLoadingProgress(
                                  loadingProgress: loadingProgress,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                AppAsset.shortlet,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 180,
                              );
                            },
                          )
                        : Image.asset(
                            AppAsset.shortlet,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 180,
                          ),
                  ),

                  // Back Button
                  Positioned(
                    top: 40,
                    left: 16,
                    child: AppBtn.basic(
                      onPressed: () {
                        $navigate.back();
                      },
                      semanticLabel: 'Back',
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black.withOpacity(0.7),
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  // Profile Image
                  Positioned(
                    left: 16,
                    bottom: -50,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: ClipOval(
                        child: profileImage.isNotEmpty
                            ? Image.network(
                                profileImage,
                                fit: BoxFit.cover,
                                width: 90,
                                height: 90,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 90,
                                    height: 90,
                                    color: Colors.grey.shade200,
                                    child: LinearImageLoadingProgress(
                                      loadingProgress: loadingProgress,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    AppAsset.chef,
                                    fit: BoxFit.cover,
                                    width: 90,
                                    height: 90,
                                  );
                                },
                              )
                            : Image.asset(
                                AppAsset.chef,
                                fit: BoxFit.cover,
                                width: 90,
                                height: 90,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              8.sbH,
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        $navigate.toWithParameters(
                          ReviewsPage.route,
                          args: ReviewArgs(
                            serviceType: ServiceType.chef.id,
                            serviceId: chefProfileData?.id ?? '',
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppColors.black, size: 17),
                          2.sbW,
                          Text(
                            '${chefProfileData?.averageRating ?? '0.0'}',
                            style: $styles.text.body.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // // Action Buttons
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0, right: 12.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       AppBtn(
              //         semanticLabel: 'Chat with agent',
              //         onPressed: () {
              //           $navigate.to(ChatPage.route);
              //         },
              //         circular: true,
              //         padding: const EdgeInsets.all(10),
              //         bgColor: context.themeColors.primaryAccent,
              //         child: const AppIcon(
              //           AppIcons.message,
              //           color: Colors.black,
              //           size: 20,
              //         ),
              //       ),
              //       const Gap(10),
              //       AppBtn(
              //         semanticLabel: 'Call with agent',
              //         onPressed: () {},
              //         circular: true,
              //         padding: const EdgeInsets.all(10),
              //         bgColor: context.themeColors.primaryAccent,
              //         child: const AppIcon(
              //           AppIcons.call,
              //           size: 20,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              30.sbH,
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            (chefProfileData?.fullName ?? 'N/A').txt16(
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                            const Gap(5),
                            SvgPicture.asset(
                              AppAsset.verified,
                              height: 16,
                              // ignore: deprecated_member_use
                              color: isApproved == 'approved'
                                  ? Colors.green
                                  : AppColors.primaryyellow,
                            ),
                          ],
                        ),
                        AppBtn(
                          onPressed: () {
                            $navigate.to(EditChefProfilePage.route);
                          },
                          semanticLabel: '',
                          padding: EdgeInsets.zero,
                          bgColor: Colors.transparent,
                          child: const AppIcon(
                            AppIcons.edit_outline,
                          ),
                        ),
                      ],
                    ),
                    4.sbH,
                    (chefProfileData?.bio ?? 'N/A').txt14(
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey61,
                      height: 0,
                    ),
                    6.sbH,
                    (chefProfileData?.address ?? 'N/A').txt14(
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey8B,
                    ),
                    6.sbH,
                    '${chefProfileData?.pricingPerHour != null ? MoneyServiceV2.formatNaira(chefProfileData?.pricingPerHour?.toDouble() ?? 0, decimalDigits: 0) : '₦--'}/hr'
                        .txt14(
                      fontFamily: Constant.inter,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
