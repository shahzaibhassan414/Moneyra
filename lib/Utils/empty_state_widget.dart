import 'package:flutter/material.dart';
import 'package:moneyra/Constants/custom_svg.dart';
import 'package:moneyra/Utils/svg_icon.dart';
import '../Constants/custom_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  const EmptyStateWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            SvgIcon(assetName: CustomSvg.noDataIcon, width: 100, height: 100),
            
            Text(
              title,
              style: TextStyle(color: CustomColors.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}
