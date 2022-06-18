import 'package:flutter/material.dart';
import 'package:flutter_bar_chart_sample/ui/page/top.dart';
import 'package:flutter_bar_chart_sample/ui/widget/chart/chart_x_axis.dart';
import 'package:flutter_bar_chart_sample/ui/widget/chart/chart_y_axis.dart';
import 'package:flutter_bar_chart_sample/ui/widget/chart/model/bar_chart_item.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BarChartByContainer extends HookWidget {
  const BarChartByContainer({
    Key? key,
    required this.barChartItems,
    required this.maxBarHeight,
    required this.barAnimationDuration,
  }) : super(key: key);

  final List<BarChartItem> barChartItems;
  final double maxBarHeight;
  final Duration barAnimationDuration;

  static const _barRatio = 0.8;
  static const _barTopRadius = Radius.circular(8);

  @override
  Widget build(BuildContext context) {
    // $B%H%C%W%Z!<%8$KCV$$$F$$$k?eJ?J}8~$N(Bpadding$BJ,%^%$%J%9$9$k(B
    final layoutWidth =
        MediaQuery.of(context).size.width - TopPage.chartHorizontalPadding * 2;
    // $BK@%0%i%U0lK\$ND9$5!J(B[BarChartByCanvas]$B$G$N7W;;<0$HF1$8!K(B
    final barWidth = (layoutWidth - ChartYAxis.scaleTextWidth) /
        barChartItems.length *
        _barRatio;

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
        builder: (context, _) => Padding(
          padding: const EdgeInsets.only(
            right: ChartYAxis.scaleTextWidth,
            bottom: ChartXAxis.scaleTextHeight,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: barChartItems
                .map(
                  (item) => Container(
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: const BorderRadius.only(
                        topLeft: _barTopRadius,
                        topRight: _barTopRadius,
                      ),
                    ),
                    width: barWidth,
                    // $B$=$l$>$l$NK@%0%i%U$N9b$5$K1~$8$F%"%K%a!<%7%g%s$N?JD=$rJQ$($k(B
                    height: item.height * animationHeight.value / maxBarHeight,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
