import 'package:craft_bay/app/asset_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AssetPath.appLogoSvg,
      width: width ?? 120,
      height: height,
      fit: BoxFit.scaleDown,
    );
  }
}
