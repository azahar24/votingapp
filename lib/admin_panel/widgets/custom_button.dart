import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButtomAdminDashboard extends StatefulWidget {
  String text;
  Function onAction;
  IconData icon;
  CustomButtomAdminDashboard({required this.text, required this.onAction, required this.icon,});

  @override
  State<CustomButtomAdminDashboard> createState() =>
      _CustomButtomAdminDashboardState();
}

class _CustomButtomAdminDashboardState
    extends State<CustomButtomAdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.onAction();
        });
      },
      child: Container(
        height: 158.h,
        width: 165.w,
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 1, 135, 82),
                Color.fromARGB(255, 126, 184, 161)
              ],
            ),
            borderRadius: BorderRadius.circular(20.r)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              widget.icon,
              size: 65.sp,
              color: Colors.white,
            ),
            SizedBox(
              height: 5.h,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
