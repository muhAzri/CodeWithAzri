import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

const Color backgroundColor = Color(0xff05051E);
const Color primaryColor = Color(0xff640EF1);
const Color whiteColor = Color(0xffffffff);
const Color grayColor = Color(0xff61647D);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;

TextStyle whiteTextStyle = TextStyle(
  color: whiteColor,
  fontSize: 14.sp,
  fontFamily: GoogleFonts.poppins().fontFamily,
);

TextStyle purpleTextStyle = TextStyle(
  color: primaryColor,
  fontSize: 14.sp,
  fontFamily: GoogleFonts.poppins().fontFamily,
);

TextStyle grayTextStyle = TextStyle(
  color: grayColor,
  fontSize: 14.sp,
  fontFamily: GoogleFonts.poppins().fontFamily,
);
