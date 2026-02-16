import 'package:flutter/material.dart';
import 'package:cvision/core/constants/colors.dart';
import 'package:cvision/cv/ui/template_selection_screen.dart';

class HomeBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onAddPressed;

  const HomeBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2E1C38),
            Color(0xFF4A2342),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.primaryAccent.withOpacity(0.1),
            blurRadius: 1,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.home_rounded),
          _buildNavItem(1, Icons.dashboard_customize_rounded),
          _buildAddButton(),
          _buildNavItem(2, Icons.person_rounded),
          _buildNavItem(3, Icons.settings_rounded),
        ],
      ),
    );
  }
  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: _buildStyledContainer(
        isSelected: isSelected,
        icon: icon,
        iconColor: isSelected ? Colors.white : Colors.white38,
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onAddPressed,
      behavior: HitTestBehavior.opaque,
      child: _buildStyledContainer(
        isSelected: false,
        icon: Icons.add_circle_outline_rounded,
        iconColor: AppColors.primaryAccent,
        isAddButton: true,
      ),
    );
  }

  Widget _buildStyledContainer({
    required bool isSelected,
    required IconData icon,
    required Color iconColor,
    bool isAddButton = false,
  }) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? AppColors.primaryAccent.withOpacity(0.15)
                : Colors.transparent,
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: AppColors.primaryAccent.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ]
                : [],
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
        ),
      ),
    );
  }
}