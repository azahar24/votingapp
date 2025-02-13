import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyle {
  TextStyle myTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20.sp,
  );
  TextStyle myTextForm = TextStyle(
    color: Colors.black54,
  );

  TextStyle myTextForm1 = TextStyle(
    color: Colors.black87,
  );

  TextStyle cardTitle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 20.sp,
  );


  InputDecoration textFieldDecoration(hint, [icon, suficon]) => InputDecoration(
        hintText: hint,

        prefixIcon: Icon(
          icon,
          color: Color(0xFFA7A7A7),
          size: 20.sp,
        ),
        suffixIcon: suficon,
        //filled: true,
        //fillColor: Color(0xFF202244),
        border: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none),
        hintStyle: TextStyle(
          fontSize: 13.sp,
          color: Color(0xFFA7A7A7),
        ),
      );

      InputDecoration textFieldDecoration1(hint, [icon]) => InputDecoration(
        hintText: hint,

        suffixIcon: Icon(
          icon,
          color: Colors.black87,
          size: 20.sp,
        ),
        //filled: true,
        //fillColor: Color(0xFF202244),
        border: UnderlineInputBorder(
            //borderRadius: BorderRadius.circular(10.r),
            //borderSide: BorderSide.none
            ),
        hintStyle: TextStyle(
          fontSize: 13.sp,
          color: Colors.black87,
        ),
      );
}
