import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class ElectionController extends GetxController {
  var candidates = <CandidateModel>[].obs;
  var totalVotes = 0.obs;
  String elcid;
  ElectionController(this.elcid,);

  @override
  void onInit() {
    super.onInit();
    fetchCandidates();
  }

  Future<void> fetchCandidates() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('election').doc(elcid).collection('candidate').get();
    candidates.value = snapshot.docs.map((doc) {
      var data = doc.data();
      return CandidateModel(
        name: data['candit_name'],
        totalVotes: data['total_votes'] ?? 0,
      );
    }).toList();

     totalVotes.value = candidates.fold(0, (sum, candidate) => sum + candidate.totalVotes);
    } catch (e) {
      print("Error fetching candidates: $e");
    }
    
  }

  List<PieChartSectionData> get pieChartData {
    return candidates.map((candidate) {
      final percentage = (candidate.totalVotes / totalVotes.value) * 100;
      return PieChartSectionData(
        color: _getColorForName(candidate.name),
        value: candidate.totalVotes.toDouble(),
        //title: '${candidate.name}: ${candidate.totalVotes}',
       // title: '${candidate.name}\n${percentage.toStringAsFixed(1)}% \n${candidate.totalVotes}',
        title: '${candidate.name}: ${candidate.totalVotes} \n${percentage.toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
    }).toList();
  }

  Color _getColorForName(String name) {
    // Simple color assignment based on candidate name for demonstration
    // You can customize this function to return colors based on your requirements
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];
    return colors[name.hashCode % colors.length];
  }
}

class CandidateModel {
  final String name;
  final int totalVotes;

  CandidateModel({
    required this.name,
    required this.totalVotes,
  });
}
