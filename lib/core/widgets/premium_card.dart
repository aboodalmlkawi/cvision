import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cvision/core/constants/colors.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final IconData? backgroundIcon; // The huge background icon
  final bool enableShimmer;       // Activate the shine
  final Gradient? gradient;       // Card color
  final double height;

  const PremiumCard({
    super.key,
    required this.child,
    required this.onTap,
    this.backgroundIcon,
    this.enableShimmer = false,
    this.gradient,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: gradient ?? AppColors.cardGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              if (backgroundIcon != null)
                Positioned(
                  right: -25,
                  bottom: -25,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Icon(
                      backgroundIcon,
                      size: 140,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
              if (enableShimmer)
                Positioned.fill(
                  child: Shimmer.fromColors(
                    baseColor: Colors.transparent,
                    highlightColor: Colors.white.withOpacity(0.15),
                    period: const Duration(seconds: 3),
                    child: Container(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}