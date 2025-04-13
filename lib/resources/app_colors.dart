import 'package:flutter/material.dart';

class ColorManager{
  static Color primary=HexColor.fromHex("#000000");
  static Color primaryOpactity70=HexColor.fromHex("#000000");
  static Color buttonColor=HexColor.fromHex("#0ABE57");
  static Color page4ContainerColor=HexColor.fromHex("#16966E");
  static Color white=HexColor.fromHex("#FFFFFF");
  static Color bubbleColor=HexColor.fromHex("#03C390");
  static Color grey=HexColor.fromHex("#03C390");
  static Color questionOptionColor=HexColor.fromHex("#064D24");
  static Color teal=HexColor.fromHex("#32D5C1");
  static Color mentalButton=HexColor.fromHex("#6A994E");
  static Color yellowCircle=HexColor.fromHex("#FFDF53");
  static Color orange=HexColor.fromHex("#FF7700");
  static Color orangeCircle=HexColor.fromHex("#F4512E");
  static Color pingBg=HexColor.fromHex("#F60030");
  static Color achivementName=HexColor.fromHex("#FCCF17");
  static Color navBar=HexColor.fromHex("#D0D0D");
  static Color navBarIcons=HexColor.fromHex("#0ABE57");
  static Color backgroundColor=HexColor.fromHex("#080D13");
}

extension HexColor on Color{
  static Color fromHex(String hexColorString){
    hexColorString=hexColorString.replaceAll('#', '');
    if(hexColorString.length==6){
      hexColorString="FF"+hexColorString; //8 char with opacity 100%
    }
    return Color(int.parse(hexColorString,radix: 16),);
  }
}