import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanrio_characters_app/main.dart';

class ScanButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool compact;
  final bool enabled;

  const ScanButton({
    super.key,
    required this.onTap,
    this.compact = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 18,
          vertical: compact ? 6 : 10,
        ),
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.accentMint
              : AppColors.accentMint.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentMint.withValues(alpha: enabled ? 0.4 : 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_search,
              size: compact ? 16 : 20,
              color: AppColors.textDark,
            ),
            const SizedBox(width: 6),
            Text(
              'Classify',
              style: GoogleFonts.poppins(
                fontSize: compact ? 12 : 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
