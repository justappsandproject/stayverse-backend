// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(this.icon,
      {super.key, this.size = 24, this.color, this.iconType = IconType.svg});
  final AppIcons icon;
  final double size;
  final Color? color;
  final IconType iconType;

  const AppIcon.png(this.icon,
      {super.key, this.size = 24, this.color, this.iconType = IconType.png});

  const AppIcon.svg(this.icon,
      {super.key, this.size = 24, this.color, this.iconType = IconType.svg});

  @override
  Widget build(BuildContext context) {
    String i = icon.name.toLowerCase().replaceAll('_', '-');

    String path = iconType.isSvg
        ? 'assets/images/icons/svgs/icon-$i.svg'
        : 'assets/images/icons/pngs/icon-$i.png';

    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: iconType.isSvg
            ? SvgPicture.asset(
                path,
                width: size,
                height: size,
                // ignore: deprecated_member_use
                color: color,
              )
            : Image.asset(
                path,
                width: size,
                height: size,
                color: color,
                filterQuality: FilterQuality.high,
              ),
      ),
    );
  }
}

enum AppIcons {
  back,
  arrow_down,
  cancel,
  discover,
  message,
  add,
  profile,
  wallet,
  chef_radio,
  heart,
  calender,
  money,
  location,
  add_solid,
  bank_send_sqaure,
  bank_send,
  send_message,
  img_upload,
  air_conditioner,
  bathroom,
  bedroom,
  guest,
  mountain_view,
  parking,
  pets_allowed,
  washer,
  wifi,
  edit_outline,
  chef_profile,
  experience,
  certification,
  hori_more,
  send,
  verify_biometrics,
  bright_light,
  clear_photo,
  face_cover,
  bank_recieve,
  call,
  balcony,
  pool,
  garage,
  gym,
  security,
  snooker,
  mountain,
  delete,
}

enum IconType { svg, png }

extension IsSvg on IconType {
  bool get isSvg => this == IconType.svg;
}
