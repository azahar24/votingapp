import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:votingapp/admin_panel/candidate_screen.dart';
import 'package:votingapp/admin_panel/screens/update_elc.dart';
import 'package:votingapp/const/app_colors.dart';
import 'package:votingapp/ui/models/elc_models.dart';
import 'package:votingapp/ui/styles/style.dart';

import '../../ui/views/pie_chart_result.dart';



class ElctionReport extends StatelessWidget {
  RxInt currentIndex = 0.obs;

  String getElectionStatus(Election election) {
  final now = DateTime.now().toUtc();

  if (now.isBefore(election.startTime)) {
    // If current time is before start time, it's upcoming
    return 'upcoming';
  } else if (now.isAfter(election.endTime)) {
    // If current time is after end time, the election has ended
    return 'ended';
  } else {
    // Otherwise, the election is ongoing
    return 'ongoing';
  }
}

  Future<Map<String, List<Election>>> getFilteredElections() async {
    final elections = await getElections();

    final upcomingElections = <Election>[];
    final ongoingElections = <Election>[];
    final endElections = <Election>[];

    for (var election in elections) {
      final status = getElectionStatus(election);
      if (status == 'upcoming') {
        upcomingElections.add(election);
      } else if (status == 'ongoing') {
        ongoingElections.add(election);
      } else if (status == 'ended') {
        endElections.add(election);
      }
    }

    return {
      'upcoming': upcomingElections,
      'ongoing': ongoingElections,
      'ended': endElections,
    };
  }

  final Stream<QuerySnapshot<Map>> _usersStream =
      FirebaseFirestore.instance.collection('election').snapshots();

  User? userData = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'Election Reports',
            style: TextStyle(
                fontSize: 23.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: AppColors.deepseaColor,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 20.h, left: 10.w, right: 10.h),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: ToggleSwitch(
                  minWidth: 200.0.w,
                  cornerRadius: 20.0,
                  activeBgColor: [AppColors.deepseaColor],
                  initialLabelIndex: 0,
                  totalSwitches: 2,
                  labels: ['ONGOING',  'END'],
                  onToggle: (index) {
                    print('switched to: $index');
                    currentIndex.value = index!;
                    print('cu to: $currentIndex');
                  },
                ),
              ),
              //3 toggle
              Expanded(
  child: FutureBuilder<Map<String, List<Election>>>(
    future: getFilteredElections(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No elections found.'));
      }

      // Using null-aware operator and default empty list
      
      final ongoingElections = snapshot.data?['ongoing'] ?? [];
      final endedElections = snapshot.data?['ended'] ?? [];

      return Obx(() {
        if (currentIndex.value == 0) {
          return ListView(
            children: [
              if (ongoingElections.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.all(10.0.r),
                  child: Text('Ongoing Elections',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ...ongoingElections.map((election) => Card(
                      child: ListTile(
                        onTap: () {
                          Get.to(ResultPieChart(election.id));
                        },
                        title: Text(
                          'Election Name: ${election.name}',
                          style: AppStyle().cardTitle,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                            'Ends at: ${DateFormat('yyyy-MM-dd HH:mm').format(election.endTime)}'),
                      ),
                    )),
              ],
            ],
          );
        }  else if (currentIndex.value == 1) {
          return ListView(
            children: [
              if (endedElections.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.all(10.0.r),
                  child: Text('Ended Elections',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ...endedElections.map((election) => Card(
                      child: ListTile(
                        onTap: () {
                          Get.to(ResultPieChart(election.id));
                        },
                        title: Text(
                          'Election Name: ${election.name}',
                          style: AppStyle().cardTitle,
                        ),
                        subtitle: Text(
                            'Ended at: ${DateFormat('yyyy-MM-dd HH:mm').format(election.endTime)}'),
                      ),
                    )),
              ],
            ],
          );
        } else {
          return Center(child: Text('No elections to display.'));
        }
      });
    },
  ),
)

            ],
          ),
        ),
      ),
    );
  }
}
