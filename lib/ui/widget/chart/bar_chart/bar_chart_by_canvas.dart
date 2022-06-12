import 'package:flutter/material.dart';
import 'package:flutter_bar_chart_sample/ui/widget/chart/chart_x_axis.dart';
import 'package:flutter_bar_chart_sample/ui/widget/chart/chart_y_axis.dart';
import 'package:flutter_bar_chart_sample/ui/widget/chart/model/bar_chart_item.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BarChartByCanvas extends HookWidget {
  const BarChartByCanvas({
    Key? key,
    required this.barChartItems,
    required this.maxBarHeight,
    required this.barAnimationDuration,
  }) : super(key: key);

  final List<BarChartItem> barChartItems;
  final double maxBarHeight;
  final Duration barAnimationDuration;

  @override
  Widget build(BuildContext context) {
    final animationController =
        useAnimationController(duration: barAnimationDuration);

    final animationHeight = useMemoized(
      () => animationController.drive(
        Tween(
          begin: 0.0,
          end: maxBarHeight,
        ).chain(
          CurveTween(
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
      [maxBarHeight],
    );

    useEffect(() {
      // [barChartItems]$B$,99?7$5$l$?%?%$%_%s%0$G%"%K%a!<%7%g%sH/2P(B
      Future.microtask(animationController.forward);

      return animationController.reset;
    }, [barChartItems]);

    return SizedBox.expand(
      child: AnimatedBuilder(
        animation: animationHeight,
        builder: (context, _) => CustomPaint(
          painter: _BarChartPainter(
            barChartItems: barChartItems,
            animationHeight: animationHeight.value,
          ),
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  const _BarChartPainter({
    required this.barChartItems,
    required this.animationHeight,
  });

  final List<BarChartItem> barChartItems;
  final double animationHeight;

  static const _barRatio = 0.8;
  static const _barTopRadius = Radius.circular(8);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 1;

    final yAxisHeight = size.height - ChartXAxis.scaleTextHeight;
    final xAxisWidth = size.width - ChartYAxis.scaleTextWidth;

    final xAxisEqualWidth = xAxisWidth / barChartItems.length;
    final barWidth = xAxisEqualWidth * _barRatio;
    final barMarginLeft = (xAxisEqualWidth - barWidth) / 2;

    for (var i = 0; i < barChartItems.length; i++) {
      final item = barChartItems[i];

      // $B$=$l$>$l$NK@%0%i%U$N9b$5$K1~$8$F%"%K%a!<%7%g%s$N?JD=$rJQ$($k(B
      final animationBarHeight = item.height * animationHeight / yAxisHeight;

      final barX = xAxisEqualWidth * i + barMarginLeft;
      final barY = yAxisHeight - animationBarHeight;

      final rect = Rect.fromLTWH(barX, barY, barWidth, animationBarHeight);

      canvas.drawRRect(
        RRect.fromRectAndCorners(rect,
            topLeft: _barTopRadius, topRight: _barTopRadius),
        paint..color = item.color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
