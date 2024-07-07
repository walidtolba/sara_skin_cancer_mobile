import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final Function() onTap;
  final String? value;
  const SettingItem({
    Key? key,
    required this.title,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    required this.onTap,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          value != null
              ? Text(
                  value!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                )
              : const SizedBox(),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Ionicons.chevron_forward_outline),
            ),
          ),
        ],
      ),
    );
  }
}
