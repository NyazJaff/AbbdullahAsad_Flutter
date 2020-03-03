import 'package:flutter/material.dart';
import 'package:abdullah_asad/Helper/util.dart';


TextStyle arabicTxtStyle({paramColour: UtilColours.APP_BAR, double paramSize: 20.0}){

   return TextStyle(
      fontSize: paramSize,
      color: paramColour,
      fontFamily: "Tajawal",
      fontStyle: FontStyle.normal
  );
}

Widget appBgImage(){
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/brand/bg_tran.png"),
        fit: BoxFit.cover,
      ),
    ),
  );
}