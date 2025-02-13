import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:votingapp/const/app_colors.dart';

class DeepseaButton extends StatefulWidget {
  String text;
  Function onAction;
  DeepseaButton({required this.text, required this.onAction});

  @override
  State<DeepseaButton> createState() => _DeepseaButtonState();
}

class _DeepseaButtonState extends State<DeepseaButton> {
  Color buttonColor = AppColors.deepseaColor; // Default color

  void changeColorTemporary() {
    setState(() {
      buttonColor = Colors.green; // Change to a temporary color
    });

    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        buttonColor = AppColors.deepseaColor; // Revert to the original color
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        changeColorTemporary();
        widget.onAction();
      },
      child: Container(
        height: 50.h,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: 9.h, left: 20.w, bottom: 9.h),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 21.sp,
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: buttonColor, // Use the dynamic button color
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
