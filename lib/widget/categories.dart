import 'package:flutter/material.dart';

import 'colors.dart';

Widget buildCategoryItem({
  required String name,
  required String? image,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 78,

      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? AppColors.pinkLight
                  : AppColors.white,
              border: Border.all(
                color: AppColors.navy,
                width: isSelected ? 2.5 : 1.5,
              ),
            ),
            child: ClipOval(
              child: image != null
                  ? Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.category,
                    size: 28,
                    color: Color(0xFF252A5A),
                  );
                },
              )
                  : const Icon(
                Icons.grid_view_rounded,
                size: 28,
                color: Color(0xFF252A5A),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight:
              isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF252A5A)
                  : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    ),
  );
}