import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/brimAuth/brim_auth.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/core/service/streamChat/communication.dart';
import 'package:stayverse/core/util/app/helper.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/apartment_favourite.dart';
import 'package:stayverse/feature/bookings/model/data/leave_a_review_args.dart';
import 'package:stayverse/feature/bookings/view/page/reviews_page.dart';
import 'package:stayverse/feature/chefDetails/controller/chef_details_controller.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/messaging/view/chats.dart';
import 'package:stayverse/shared/app_icons.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/image_loading_progress.dart';

class ChefProfileHeader extends ConsumerStatefulWidget {
  final Chef? chef;
  final double? totalPrice;
  const ChefProfileHeader({
    super.key,
    this.chef,
    this.totalPrice,
  });

  @override
  ConsumerState<ChefProfileHeader> createState() => _ChefProfileHeaderState();
}

class _ChefProfileHeaderState extends ConsumerState<ChefProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.09),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(1, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: widget.chef?.coverPhoto?.isNotEmpty == true
                        ? Image.network(
                            widget.chef!.coverPhoto!,
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
                                AppAsset.apartment,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 180,
                              );
                            },
                          )
                        : Image.asset(
                            AppAsset.apartment,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 180,
                          ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppBtn.basic(
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
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: FavouriteBtn(
                            isFavourite: ref.watch(chefDetailsController.select(
                              (state) =>
                                  state.isFavourite ??
                                  widget.chef?.isFavorite ??
                                  false,
                            )),
                            onTap: (action) {
                              ref
                                  .read(chefDetailsController.notifier)
                                  .debounceFavourite(
                                    action: action,
                                    chefId: widget.chef?.id ?? '',
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        child: widget.chef?.profilePicture?.isNotEmpty == true
                            ? Image.network(
                                widget.chef?.profilePicture ?? '',
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
                                  return Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade200,
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported,
                                          color: Colors.grey),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade200,
                                ),
                                child: const Center(
                                  child: Icon(Icons.image_not_supported,
                                      color: Colors.grey),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),

              // Action Button
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    $navigate.toWithParameters(ReviewsPage.route,
                        args: LeaveAReviewArgs(
                          serviceType: ServiceType.chefs.apiPoint,
                          serviceId: widget.chef?.id ?? '',
                        ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 20,
                      ),
                      Text(
                        '${widget.chef?.averageRating ?? 0.0}',
                        style: $styles.text.bodyBold.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: 0.85,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(30),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${widget.chef?.fullName}",
                          maxLines: 1,
                          style: $styles.text.bodyBold.copyWith(
                            fontSize: 18,
                            height: 1.3,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(5),
                        SvgPicture.asset(
                          AppAsset.verified,
                          height: 16,
                        ),
                      ],
                    ),
                    const Gap(4),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        "${widget.chef?.bio}",
                        maxLines: 5,
                        style: $styles.text.body.copyWith(
                          fontSize: 14,
                          height: 1.3,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF616161),
                        ),
                      ),
                    ),
                    const Gap(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (widget.totalPrice != null)
                            ? Text(
                                widget.totalPrice != null
                                    ? 'Payment ~ ${MoneyServiceV2.formatNaira(widget.totalPrice ?? 0, decimalDigits: 0)}'
                                    : '₦--',
                                style: $styles.text.body.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              )
                            : Row(
                                children: [
                                  Text(
                                    widget.chef?.pricingPerHour != null
                                        ? MoneyServiceV2.formatNaira(
                                            widget.chef?.pricingPerHour ?? 0,
                                            decimalDigits: 0)
                                        : '₦--',
                                    style: $styles.text.body.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '/hour',
                                    style: $styles.text.body.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF616161),
                                    ),
                                  ),
                                ],
                              ),
                        const Gap(12),
                        Row(
                          children: [
                            AppBtn(
                              semanticLabel: 'Chat with agent',
                              onPressed: () {
                                _chatAgent();
                              },
                              circular: true,
                              padding: const EdgeInsets.all(10),
                              bgColor: context.themeColors.primaryAccent,
                              child: const AppIcon(
                                AppIcons.message,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                            const Gap(10),
                            AppBtn(
                              semanticLabel: 'Call with agent',
                              onPressed: () {
                                openPhoneNumber(
                                    number:
                                        widget.chef?.agent?.phoneNumber ?? '');
                              },
                              circular: true,
                              padding: const EdgeInsets.all(10),
                              bgColor: context.themeColors.primaryAccent,
                              child: const AppIcon(
                                AppIcons.call,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                      ],
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

  void _chatAgent() {
    final channel = CommnunicationSevice.instance.chatAgent(
      myId: BrimAuth.curentUser()?.id ?? '',
      agentId: widget.chef?.agent?.id ?? '',
    );

    if (channel != null) {
      $navigate.toWithParameters(Chats.route, args: channel);
    }
  }
}
