import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/app/helper.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/Reviews/model/data/review_response.dart';

class ReviewsListCard extends StatelessWidget {
  final Review? review;
  const ReviewsListCard({super.key, this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.greyF7))),
      padding: const EdgeInsets.only(left: 7, right: 7, bottom: 18),
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: Center(
                      child: isEmpty(review?.user?.profilePicture)
                          ? Text(
                              review?.user?.firstname?.isNotEmpty == true
                                  ? review!.user!.firstname![0].toUpperCase()
                                  : 'U',
                              style: $styles.text.title1.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            )
                          : CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                review?.user?.profilePicture ?? '',
                              )),
                    ),
                  ),
                  const Gap(14),
                  Text(
                    review?.user?.fullName ?? 'Not Available',
                    style: $styles.text.body.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              RatingBarIndicator(
                rating: review?.rating ?? 0,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 16.0,
                unratedColor: Colors.grey,
                direction: Axis.horizontal,
              )
            ],
          ),
          const Gap(12),
          Text(
            review?.review ?? '',
            style: $styles.text.body.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.black0C,
            ),
          ),
        ],
      ),
    );
  }
}
