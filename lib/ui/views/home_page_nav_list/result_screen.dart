import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:votingapp/business_logics/profile_photo_con.dart';
import 'package:votingapp/business_logics/user_controller.dart';
import 'package:votingapp/const/app_colors.dart';
import 'package:votingapp/ui/models/elc_models.dart';
import 'package:votingapp/ui/styles/style.dart';
import 'package:votingapp/ui/views/pie_chart_result.dart';
import 'package:votingapp/ui/views/vote_screen.dart';

class Result extends StatelessWidget {

  String getElectionStatus(Election election) {
    final now = DateTime.now().toUtc();

    if (now.isBefore(election.startTime)) {
      return 'Upcoming';
    } else if (now.isBefore(election.endTime)) {
      return 'Ended';
    } else {
      return 'Ongoing';
    }
  }

  Future<Map<String, List<Election>>> getFilteredElections() async {
    final elections = await getElections();

    final upcomingElections = <Election>[];
    final ongoingElections = <Election>[];
    final endElections = <Election>[];

    for (var election in elections) {
      final status = getElectionStatus(election);
      if (status == 'Upcoming') {
        upcomingElections.add(election);
      } else if (status == 'Ongoing') {
        ongoingElections.add(election);
      }
      else if (status == 'Ended') {
        endElections.add(election);
      }
    }

    return {
      'upcoming': upcomingElections,
      'ongoing': ongoingElections,
      'Ended': endElections,
    };
  }

  final DocumentReference userDoc =
      FirebaseFirestore.instance.collection('user-form-data').doc(FirebaseAuth.instance.currentUser!.uid); 


  @override
  Widget build(BuildContext context) {
    
    final PhotoUploadController controller = Get.put(PhotoUploadController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(
            top: 15.h,
            left: 10.w,
            right: 10.w,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 55.h,
                        width: 55.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: controller.firebaseImageUrl.isNotEmpty
                                ? NetworkImage(
                                    controller.firebaseImageUrl.value)
                                : const AssetImage('assets/img/av.png'),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: userDoc.snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              !snapshot.data!.exists) {
                            return Center(child: Text('No data found'));
                          }

                          // Extract data from the snapshot
                          final userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          final name = userData['name'] ?? 'No Name';

                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, $name',
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            print('click');
                          },
                          icon: Icon(
                            Icons.notification_important_outlined,
                            color: Colors.grey[700],
                          )),
                    ],
                  )
                ],
              ),
              //Notification Account Name
              SizedBox(
                height: 20.h,
              ),
            
              SizedBox(
                height: 10.h,
              ),
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
      
                    final upcomingElections = snapshot.data!['upcoming']!;
                    final ongoingElections = snapshot.data!['ongoing']!;
                    final endElections = snapshot.data!['ongoing']!;
      
                    return ListView(
                            children: [
                              if (endElections.isNotEmpty) ...[
                                Padding(
                                  padding: EdgeInsets.all(10.0.r),
                                  child: Text('End Elections',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                                ...endElections.map((election) => Card(
                                      child: ListTile(
                                        onTap: () {
                                          Get.to(ResultPieChart(election.id));
                                          // Get.to(ElectionDetailPage(
                                          //   election: election,
                                          // ));
                                          //ElectionDetailPage(election: election,);
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
