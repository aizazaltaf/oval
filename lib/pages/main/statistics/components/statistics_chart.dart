import 'package:admin/constants.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/statistics_model.dart';
import 'package:admin/pages/main/dashboard/view_model/filters_model.dart';
import 'package:admin/pages/main/statistics/components/statistics_filters_widget.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsChart extends StatefulWidget {
  const StatisticsChart({
    super.key,
    required this.statisticsList,
    required this.selectedDropDownValue,
    // required this.visitorName,
    required this.timeInterval,
  });
  final BuiltList<StatisticsModel> statisticsList;
  final String selectedDropDownValue;
  // final String visitorName;
  final FiltersModel timeInterval;

  @override
  State<StatisticsChart> createState() => _StatisticsChartState();
}

class _StatisticsChartState extends State<StatisticsChart> {
  // String getVisitorName() {
  //   return widget.visitorName.contains("A new")
  //       ? "Unknown"
  //       : widget.visitorName;
  // }

  String getTimeInterval() {
    if (StatisticsFiltersWidget.timeIntervalFilters
        .any((element) => element.title == widget.timeInterval.title)) {
      return widget.timeInterval.title.toLowerCase();
    } else {
      if (widget.timeInterval.value == widget.timeInterval.value2) {
        return widget.timeInterval.value!;
      }
      return "${widget.timeInterval.value} to ${widget.timeInterval.value2}";
    }
  }

  Widget getNoRecordsAvailableError() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Text(
        '${context.appLocalizations.no_records_available}'
        // '${widget.visitorName.isNotEmpty ? " of ${getVisitorName()}" : ""}'
        ' for ${getTimeInterval()}.',
        maxLines: 2,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              letterSpacing: 2,
              color: CommonFunctions.getThemeBasedWidgetColor(context),
              fontSize: 16,
            ),
      ),
    );
  }

  String getBarChartTitle(BuildContext context) {
    switch (widget.selectedDropDownValue) {
      case Constants.peakVisitorsHourKey:
        return context.appLocalizations.timings;

      case Constants.frequencyOfVisitsKey:
        return context.appLocalizations.name_of_visitors;

      default:
        return context.appLocalizations.days;
    }
  }

  List<CartesianChartAnnotation> getChartAnnotations() {
    final List<CartesianChartAnnotation> list = [];
    for (var i = 0; i < widget.statisticsList.length; i++) {
      list.add(
        CartesianChartAnnotation(
          widget: Container(
            width: widget.statisticsList[i].visitCount == 0 ? 0 : 2,
            color: Theme.of(context).primaryColor, // Line color
          ),
          coordinateUnit: CoordinateUnit.point,
          verticalAlignment: ChartAlignment.near,
          region: AnnotationRegion.plotArea,
          x: i, // X-axis value where the line should start
          y: widget.statisticsList[i]
              .visitCount, // Y-axis value where the line should end
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return widget.statisticsList.isEmpty ||
            widget.statisticsList.every((element) => element.visitCount == 0)
        ? getNoRecordsAvailableError()
        : Stack(
            alignment: Alignment.center,
            children: [
              SfCartesianChart(
                plotAreaBorderColor: Colors.transparent,
                plotAreaBorderWidth: 0,
                enableAxisAnimation: true,
                annotations: getChartAnnotations(),
                primaryXAxis: CategoryAxis(
                  labelPlacement: LabelPlacement.onTicks,
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  majorGridLines: const MajorGridLines(
                    width: 0,
                  ),
                  labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: CommonFunctions.getThemeBasedWidgetColor(
                          context,
                        ),
                      ),
                  axisLine: AxisLine(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  majorGridLines: MajorGridLines(
                    width: 2,
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.transparent,
                  ),
                  labelPosition: ChartDataLabelPosition.inside,
                  axisLine: AxisLine(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                series: <SplineAreaSeries<StatisticsModel, String>>[
                  SplineAreaSeries<StatisticsModel, String>(
                    borderDrawMode: BorderDrawMode.all,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(47, 102, 246, 0),
                        Colors.white,
                      ],
                    ),
                    borderColor: Theme.of(context).primaryColor,
                    markerSettings: MarkerSettings(
                      isVisible: true,
                      color: Colors.white,
                      borderWidth: 4,
                      width: 10,
                      height: 10,
                      borderColor: Theme.of(context).primaryColor,
                    ),
                    splineType: SplineType.monotonic,
                    dataSource: widget.statisticsList.toList(),
                    xValueMapper: (list, _) => list.title,
                    yValueMapper: (list, _) => list.visitCount,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      showZeroValue: false,
                      margin: EdgeInsets.zero,
                      labelPosition: ChartDataLabelPosition.outside,
                      labelAlignment: ChartDataLabelAlignment.outer,
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: CommonFunctions.getThemeBasedWidgetColor(
                                  context,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
              // if (widget.visitorName.isEmpty)
              //   Positioned(
              //     top: MediaQuery.of(context).size.height * 0.05,
              //     child: Text(
              //       getBarChartTitle(context),
              //       style: TextStyle(
              //         fontSize: 14,
              //         letterSpacing: 2.5,
              //         color: AppColors.textLightColor,
              //       ),
              //     ),
              //   )
              // else
              //   const SizedBox.shrink(),
            ],
          );
  }

  Widget getTopTitle(int index) {
    final TextStyle style = TextStyle(
      color: AppColors.textLightColor,
      fontSize: 12,
    );
    return index >= 0 && index < widget.statisticsList.length
        ? SizedBox(
            width: 56,
            child: Text(
              widget.statisticsList[index].visitCount.toString(),
              textAlign: TextAlign.center,
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        : Container();
  }

  Widget getXAxisValues(int index) {
    final TextStyle style = TextStyle(
      color: AppColors.textLightColor,
      fontSize: 12,
    );
    return index >= 0 && index < widget.statisticsList.length
        ? SizedBox(
            width: 56,
            child: Text(
              widget.statisticsList[index].title.contains("A new")
                  ? "Unknown"
                  : widget.statisticsList[index].title,
              textAlign: TextAlign.center,
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        : Container();
  }
}
