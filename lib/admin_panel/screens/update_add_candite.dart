import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:votingapp/admin_panel/controller/update_or_add_candidate_con.dart';
import 'package:votingapp/const/app_colors.dart';
import 'package:votingapp/ui/styles/style.dart';
import 'package:votingapp/ui/widgets/deepsea_button.dart';

class CreateElection extends StatelessWidget {
  final String electioncode;
  final CreateElectionController controller = Get.put(CreateElectionController());

  CreateElection({required this.electioncode});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream =
        FirebaseFirestore.instance
            .collection('election')
            .doc(electioncode)
            .collection('candidate')
            .snapshots();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_box),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return GetBuilder<CreateElectionController>(
                builder: (controller) {
                  return AlertDialog(
                    title: Text('Candidate Info'),
                    content: Container(
                      height: 350,
                      width: 300,
                      child: Column(
                        children: [
                          DeepseaButton(
                            text: "Add Candidate Photo",
                            onAction: () => controller.chooseImageFromGallery(),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: controller.canditNameController,
                            decoration: AppStyle().textFieldDecoration1('Candidate Name'),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: controller.partyNameController,
                            decoration: AppStyle().textFieldDecoration1('Party Name'),
                          ),
                          SizedBox(height: 30),
                          DeepseaButton(
                            text: "Add Candidate",
                            onAction: () async => controller.writeDataElc(electioncode).whenComplete((){
                              controller.canditNameController.clear();
                              controller.partyNameController.clear();
                            }),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      appBar: AppBar(
        title: Text(
          'Add Candidate',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          color: Colors.white,
          icon: Icon(Icons.arrow_back, size: 25),
        ),
        backgroundColor: AppColors.deepseaColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['candit_name'], maxLines: 1),
                leading: Image.network(data['img']),
                subtitle: Text(data['party_name'], maxLines: 1),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return GetBuilder<CreateElectionController>(
                        builder: (controller) {
                          return AlertDialog(
                            title: Text('Candidate Info'),
                            content: Column(
                              children: [
                                DeepseaButton(
                                  text: "Update Candidate Photo",
                                  onAction: () => controller.chooseImageFromGallery(),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: controller.canditNameController,
                                  decoration: AppStyle().textFieldDecoration1('Candidate Name'),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: controller.partyNameController,
                                  decoration: AppStyle().textFieldDecoration1('Party Name'),
                                ),
                                SizedBox(height: 30),
                                Row(
                                  children: [
                                    DeepseaButton(
                                      text: "Update",
                                      onAction: () async => controller.updateDataElc(electioncode, document.id),
                                    ),
                                    SizedBox(width: 10),
                                    DeepseaButton(
                                      text: "Delete",
                                      onAction: () async => controller.deleteCandidate(electioncode, document.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
