
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BigText extends StatelessWidget {
  String text;
  BigText({required this.text});


  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.black,
      fontSize: 36.sp,
    ),);
  }
}
