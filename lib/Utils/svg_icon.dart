import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String assetName;
  final double width;
  final double height;
  const SvgIcon({
    super.key,
    required this.assetName,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      allowDrawingOutsideViewBox: true,
    );
  }
}
