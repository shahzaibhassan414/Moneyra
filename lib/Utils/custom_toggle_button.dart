import 'package:flutter/material.dart';

import '../Constants/custom_colors.dart';

class CustomToggleButton extends StatefulWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;
  const CustomToggleButton({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title, style: const TextStyle(fontSize: 15)),
      Switch(
          value: widget.value,
          onChanged: (value) {
            widget.onChanged(value);
          },
          activeThumbColor: CustomColors.primaryGreen,
        ),
        ],
      ),
    );
  }
}
