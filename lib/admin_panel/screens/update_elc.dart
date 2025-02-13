import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:votingapp/admin_panel/create_elc.dart';
import 'package:votingapp/const/app_colors.dart';
import 'package:votingapp/ui/styles/style.dart';
import 'package:votingapp/ui/widgets/deepsea_button.dart';

class UpdateElection extends StatefulWidget {
  String docid;
  String elcName;
  String startTimenav;
  String endTimenav;
  UpdateElection(
      {required this.elcName,
      required this.startTimenav,
      required this.endTimenav,
      required this.docid});

  @override
  State<UpdateElection> createState() => _UpdateElectionState();
}

class _UpdateElectionState extends State<UpdateElection> {
  TextEditingController _elcNameController = TextEditingController();

  Rx<TextEditingController> _starTimeController = TextEditingController().obs;

  Rx<TextEditingController> _endTimeController = TextEditingController().obs;

  String? startTime;

  String? endTime;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _elcNameController.text = widget.elcName;
    _starTimeController.value.text = widget.startTimenav;
    _endTimeController.value.text = widget.endTimenav;
  }

  dateTimePickerStartTime(BuildContext context) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy HH:mm',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime(2000),
      maxDateTime: DateTime(3000),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) {
        DateTime selectdate = dateTime;
        final selIOS = DateFormat('dd-MMM-yyyy - HH:mm').format(selectdate);
        print(selIOS);
        startTime = selIOS;
        _starTimeController.value.text = selIOS;
      },
    );
  }

  dateTimePickerendTime(BuildContext context) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy HH:mm',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime(2000),
      maxDateTime: DateTime(3000),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) {
        DateTime selectdate = dateTime;
        final selIOS = DateFormat('dd-MMM-yyyy - HH:mm').format(selectdate);
        print(selIOS);
        endTime = selIOS;
        _endTimeController.value.text = selIOS;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'Update Election',
            style: TextStyle(
                fontSize: 23.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: AppColors.deepseaColor,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 20.h, left: 15.w, right: 15.w),
          child: Column(
            children: [
              TextFormField(
                //validator: ((value) => EmailVal().validateEmail(value)),
                controller: _elcNameController,
                keyboardType: TextInputType.text,
                style: AppStyle().myTextForm1,
                decoration: AppStyle().textFieldDecoration1(
                  'Election Name',
                ),
              ),
              TextFormField(
                //validator: ((value) => EmailVal().validateEmail(value)),
                controller: _starTimeController.value,
                keyboardType: TextInputType.text,
                style: AppStyle().myTextForm1,
                //readOnly: true,
                decoration: InputDecoration(
                    hintText: 'Election Start Time',
                    hintStyle: TextStyle(
                      fontSize: 15.sp,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () => dateTimePickerStartTime(context),
                        icon: Icon(Icons.calendar_month_rounded))),
              ),
              TextFormField(
                //validator: ((value) => EmailVal().validateEmail(value)),
                controller: _endTimeController.value,
                keyboardType: TextInputType.text,
                style: AppStyle().myTextForm1,
                //readOnly: true,
                decoration: InputDecoration(
                    hintText: 'Election End Time',
                    hintStyle: TextStyle(
                      fontSize: 15.sp,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () => dateTimePickerendTime(context),
                        icon: Icon(Icons.calendar_month_rounded))),
              ),
              SizedBox(
                height: 10.h,
              ),
             DeepseaButton(
  text: "Next",
  onAction: () async {
    try {
      CollectionReference election =
          FirebaseFirestore.instance.collection('election');

      // Get the current document data
      DocumentSnapshot currentData = await election.doc(widget.docid).get();

      // Create a map for fields to be updated only if they are different
      Map<String, dynamic> updatedData = {};

      // Check if the election name has changed
      if (_elcNameController.text != currentData['election_name']) {
        updatedData['election_name'] = _elcNameController.text;
      }

      // Check if start_time is different from the current one
      if (startTime != null && startTime != currentData['start_time']) {
        updatedData['start_time'] = startTime;
      }

      // Check if end_time is different from the current one
      if (endTime != null && endTime != currentData['end_time']) {
        updatedData['end_time'] = endTime;
      }

      // Update the document only if there are changes
      if (updatedData.isNotEmpty) {
        await election.doc(widget.docid).update(updatedData).whenComplete(
          () {
            Fluttertoast.showToast(msg: 'Update Election Successfully');
            Get.to(CreateElection(
              electioncode: widget.docid,
            ));
          },
        );
      } else {
        Fluttertoast.showToast(msg: 'No changes to update');
        Get.to(CreateElection(
              electioncode: widget.docid,
            ));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'error: $e');
    }
  },
),

            ],
          ),
        ),
      ),
    );
  }
}
