import 'package:flutter/material.dart';
import '../../../Constants/custom_colors.dart';

class SettingsTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
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
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          splashColor: CustomColors.primaryGreen.withOpacity(0.1),
          hoverColor: CustomColors.primaryGreen.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      widget.icon,
                      size: 22,
                      color: CustomColors.primaryBlue,
                    ),
                    const SizedBox(width: 10),
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
