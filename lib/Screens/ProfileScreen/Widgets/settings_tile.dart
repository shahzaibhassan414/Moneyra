import 'package:flutter/material.dart';
import '../../../Constants/custom_colors.dart';

class SettingsTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
  });

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        shadowColor: CustomColors.primaryGreen.withValues(alpha: 0.1),
        surfaceTintColor: CustomColors.primaryGreen.withValues(alpha: 0.05),
        child: InkWell(
          onTap: () {},
          splashColor: CustomColors.primaryGreen.withValues(alpha: 0.1),
          hoverColor: CustomColors.primaryGreen.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Icon(
                      widget.icon,
                      size: 22,
                      color: CustomColors.primaryBlue,
                    ),
                    Text(widget.title, style: const TextStyle(fontSize: 15)),
                  ],
                ),
                widget.trailing != null
                    ? Text(
                        widget.trailing!,
                        style: const TextStyle(
                          color: CustomColors.secondaryText,
                        ),
                      )
                    : const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: CustomColors.secondaryText,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
