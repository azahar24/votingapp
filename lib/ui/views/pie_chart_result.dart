import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:votingapp/business_logics/pie_chart_controller.dart';

class ResultPieChart extends StatelessWidget {
   String docid;
   ResultPieChart( this.docid,);
  @override
  Widget build(BuildContext context) {
    final ElectionController controller = Get.put(ElectionController(docid));

    return Scaffold(
      appBar: AppBar(
        title: Text('Election Results'),
      ),
      body: Obx(() {
        if (controller.candidates.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: PieChart(
            PieChartData(
              sections: controller.pieChartData,
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
            ),
          ),
        );
      }),
    );
  }
}
