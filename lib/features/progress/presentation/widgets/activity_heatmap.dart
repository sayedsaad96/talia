import 'package:flutter/material.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';

class ActivityHeatmap extends StatelessWidget {
  final Map<DateTime, int> dailyActivity;
  final int weeks;

  const ActivityHeatmap({
    super.key,
    required this.dailyActivity,
    this.weeks = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(
        size: Size(double.infinity, 120), // Height based on 7 rows
        painter: _HeatmapPainter(
          dailyActivity: dailyActivity,
          weeks: weeks,
        ),
      ),
    );
  }
}

class _HeatmapPainter extends CustomPainter {
  final Map<DateTime, int> dailyActivity;
  final int weeks;

  _HeatmapPainter({
    required this.dailyActivity,
    required this.weeks,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final int rows = 7;
    final int cols = weeks;
    final double padding = 4.0;
    
    // Calculate cell size based on available width and height
    final double cellWidth = (size.width - (padding * (cols - 1))) / cols;
    final double cellHeight = (size.height - (padding * (rows - 1))) / rows;
    
    // Make cells square if possible, bounded by height
    final double cellSize = cellWidth < cellHeight ? cellWidth : cellHeight;
    
    // Center the grid
    final double totalWidth = (cellSize * cols) + (padding * (cols - 1));
    final double offsetX = (size.width - totalWidth) / 2;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // We want the bottom-right cell to be today.
    // So the top-left cell is today minus (weeks * 7 - 1) days.
    // Wait, typically columns are weeks, rows are days of week.
    // Let's just walk backward from today.
    
    for (int col = cols - 1; col >= 0; col--) {
      for (int row = rows - 1; row >= 0; row--) {
        // Calculate days ago
        final int daysAgo = ((cols - 1 - col) * 7) + (rows - 1 - row);
        final date = today.subtract(Duration(days: daysAgo));
        
        final count = dailyActivity[date] ?? 0;
        final color = _getColorForCount(count);

        final paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

        final x = offsetX + (col * (cellSize + padding));
        final y = row * (cellSize + padding);

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, cellSize, cellSize),
            const Radius.circular(4),
          ),
          paint,
        );
      }
    }
  }

  Color _getColorForCount(int count) {
    if (count == 0) return Colors.grey[200]!;
    if (count < 3) return AppColors.primary.withValues(alpha: 0.3);
    if (count < 6) return AppColors.primary.withValues(alpha: 0.6);
    return AppColors.primary;
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter oldDelegate) {
    return oldDelegate.dailyActivity != dailyActivity || oldDelegate.weeks != weeks;
  }
}
