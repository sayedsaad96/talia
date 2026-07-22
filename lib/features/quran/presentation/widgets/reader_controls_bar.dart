import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/features/quran/presentation/cubit/reader_state.dart';

class ReaderControlsBar extends StatelessWidget {
  final ReaderState state;
  final VoidCallback onToggleTajweed;
  final VoidCallback onToggleMode;
  final VoidCallback onDecreaseFontSize;
  final VoidCallback onIncreaseFontSize;
  final VoidCallback onBookmark;
  final VoidCallback onClose;
  final bool hasBookmark;

  const ReaderControlsBar({
    super.key,
    required this.state,
    required this.onToggleTajweed,
    required this.onToggleMode,
    required this.onDecreaseFontSize,
    required this.onIncreaseFontSize,
    required this.onBookmark,
    required this.onClose,
    this.hasBookmark = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: (state.isDarkMode ? AppColors.darkSurface : AppColors.surface).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.format_color_text, color: state.isTajweed ? AppColors.primary : AppColors.textSecondary),
                onPressed: onToggleTajweed,
              ),
              IconButton(
                icon: Icon(state.mode == ReadingMode.mushaf ? Icons.menu_book : Icons.list, color: AppColors.textPrimary),
                onPressed: onToggleMode,
              ),
              if (state.mode == ReadingMode.surah) ...[
                IconButton(
                  icon: const Icon(Icons.text_decrease, color: AppColors.textPrimary),
                  onPressed: onDecreaseFontSize,
                ),
                IconButton(
                  icon: const Icon(Icons.text_increase, color: AppColors.textPrimary),
                  onPressed: onIncreaseFontSize,
                ),
              ],
              IconButton(
                icon: Icon(hasBookmark ? Icons.bookmark : Icons.bookmark_border, color: hasBookmark ? AppColors.secondary : AppColors.textPrimary),
                onPressed: onBookmark,
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.error),
                onPressed: onClose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
