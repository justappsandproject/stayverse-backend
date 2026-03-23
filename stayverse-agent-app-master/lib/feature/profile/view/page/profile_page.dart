import 'dart:io';

import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/constant.dart';
import 'package:stayvers_agent/core/data/current_user.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/app/helper.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/chefOwner/view/page/chef_profile_page.dart';
import 'package:stayvers_agent/feature/dashBoard/controller/dashboard_controller.dart';
import 'package:stayvers_agent/feature/inbox/view/page/chat_support_page.dart';
import 'package:stayvers_agent/feature/profile/controller/profile_controller.dart';
import 'package:stayvers_agent/feature/profile/view/component/delete_account_dialog.dart';
import 'package:stayvers_agent/feature/profile/view/component/kyc_option.dart';
import 'package:stayvers_agent/feature/profile/view/component/logout_dialog.dart';
import 'package:stayvers_agent/feature/profile/view/component/notification_switch.dart';
import 'package:stayvers_agent/feature/profile/view/component/profile_option.dart';
import 'package:stayvers_agent/feature/profile/view/page/change_password_page.dart';
import 'package:stayvers_agent/feature/profile/view/page/edit_profile_page.dart';
import 'package:stayvers_agent/feature/profile/view/page/kyc_verification_page.dart';
import 'package:stayvers_agent/feature/profile/view/page/listed_apartment_page.dart';
import 'package:stayvers_agent/feature/profile/view/page/listed_cars_page.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

class ProfilePage extends ConsumerStatefulWidget {
  static const route = '/ProfilePage';
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  File? profileImage;

  @override
  Widget build(BuildContext context) {
    final serviceType = ref.watch(
        dashboadController.select((state) => state.user?.agent?.serviceType));
    final profile = ref.watch(dashboadController.select((state) => state.user));
    final user = ref.watch(dashboadController).user;
    return BrimSkeleton(
      isAuthSkeleton: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: const SizedBox.shrink(),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        actions: [
          AppBtn(
            onPressed: () {
              $navigate.to(EditProfilePage.route);
            },
            semanticLabel: '',
            padding: EdgeInsets.zero,
            bgColor: Colors.transparent,
            child: const AppIcon(
              AppIcons.edit_outline,
            ),
          ),
          const Gap(16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _takePicture,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor:
                              context.color.primary.withValues(alpha: 0.2),
                          backgroundImage: _getProfileImage(user),
                          child: _getProfileImage(user) == null
                              ? Icon(
                                  Icons.person,
                                  size: 40,
                                  color: context.color.primary,
                                )
                              : null,
                        ),

                        // Loading overlay
                        if (ref.watch(profileController).isLoading)
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  padding: EdgeInsets.zero,
                                  strokeWidth: 1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  Text(
                    user?.fullName ?? '',
                    style: $styles.text.bodyBold.copyWith(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    user?.email ?? '',
                    style: $styles.text.bodyBold.copyWith(
                      fontSize: 14,
                      height: 1,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            ...[
              _getFirstProfileTile(serviceType),
              ProfileOption(
                  title: 'Notification',
                  trailing: const NotificationSwitch(),
                  onTap: () {
                    ref
                        .read(profileController.notifier)
                        .updateNotificationPreference(true);
                  }),
              // const _ProfileOption(
              //     title: 'Finger Print/Face ID', hasToggle: true),
              ProfileOption(
                  title: 'Password',
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.grey.shade500, size: 18),
                  onTap: () {
                    $navigate.to(ChangePasswordPage.route);
                  }),
              ProfileOption(
                  title: 'Chat Support',
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.grey.shade500, size: 18),
                  onTap: () {
                    $navigate.toWithParameters(
                      ChatSupportPage.route,
                      args: Constant.chatSupportUrl,
                    );
                  }),
              ProfileOption(
                  title: 'About',
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.grey.shade500, size: 18),
                  onTap: () {
                    openAboutUs(
                      Constant.aboutUsUrl,
                    );
                  }),
              KycProfileOption(
                  title: 'KYC',
                  onTap: () {
                    $navigate.to(KycVerificationPage.route);
                  },
                  kycStatus: profile?.kycStatus),
            ].expand((widget) => [
                  widget,
                  Divider(
                    height: 10,
                    thickness: 1,
                    color: Colors.grey.shade100,
                  )
                ]),
            const Gap(25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppBtn.from(
                text: 'Log Out',
                expand: true,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
                bgColor: AppColors.black,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const LogoutDialog(),
                  );
                },
              ),
            ),
            const Gap(5),
            AppBtn.basic(
              semanticLabel: 'Delete Account',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const DeleteAccountDialog(),
                );
              },
              child: Text(
                'Delete Account',
                style: $styles.text.bodyBold.copyWith(
                  fontSize: 15,
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.red,
                  decorationThickness: 1,
                  fontWeight: FontWeight.w400,
                ),
              ).alignAtCenter(),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  ImageProvider? _getProfileImage(CurrentUser? user) {
    // Show local preview while uploading
    if (profileImage != null) {
      return FileImage(profileImage!);
    }

    // Show uploaded image from backend
    if (user?.profilePicture != null && user!.profilePicture!.isNotEmpty) {
      return NetworkImage(user.profilePicture!);
    }

    return null;
  }

  void _takePicture() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.camera_alt_outlined,
                      color: Colors.grey.shade900),
                  title: Text(
                    'Take a Picture',
                    style: $styles.text.bodyBold.copyWith(
                      fontSize: 16,
                      height: 1,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedFile = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                      preferredCameraDevice: CameraDevice.front,
                      imageQuality: 85,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        profileImage = File(pickedFile.path);
                      });
                      await _uploadProfilePicture();
                    }
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: AppIcon(AppIcons.clear_photo,
                      color: Colors.grey.shade900),
                  title: Text(
                    'Pick from Gallery',
                    style: $styles.text.bodyBold.copyWith(
                      fontSize: 16,
                      height: 1,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedFile = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        profileImage = File(pickedFile.path);
                      });
                      await _uploadProfilePicture();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _uploadProfilePicture() async {
    if (profileImage == null) return;

    final success =
        await ref.read(profileController.notifier).uploadProfile(profileImage!);

    if (success) {
      // Refresh user to get the updated profile picture URL from backend
      await ref.read(dashboadController.notifier).refreshUser();

      // Clear local preview after successful upload
      setState(() {
        profileImage = null;
      });
    } else {
      // If upload failed, also clear the preview
      setState(() {
        profileImage = null;
      });
    }
  }

  static Widget _getFirstProfileTile(ServiceType? accountType) {
    switch (accountType) {
      case ServiceType.chef:
        return ProfileOption(
            title: 'View Profile',
            onTap: () {
              $navigate.to(ChefProfilePage.route);
            });
      case ServiceType.apartmentOwner:
        return ProfileOption(
            title: 'Listed Apartment',
            onTap: () {
              $navigate.to(ListedApartmentPage.route);
            });
      case ServiceType.carOwner:
        return ProfileOption(
            title: 'Listed Cars',
            onTap: () {
              $navigate.to(ListedCarsPage.route);
            });
      default:
        return ProfileOption(title: 'View Profile', onTap: () {});
    }
  }
}
