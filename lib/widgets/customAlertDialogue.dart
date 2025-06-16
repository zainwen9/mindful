import 'package:flutter/material.dart';
import '../resources/app_colors.dart';
import '../resources/global_context_key.dart';

enum QuickAlertType {
  success,
  error,
  warning,
  confirm,
  info,
  loading,
}

class QuickAlert {
  static void show({
    required QuickAlertType type,
    Color? backgroundColor,
    Color? headerBackgroundColor,
    Color? bodyColor,
    bool showButtons = true,
    Color? confirmBtnColor,
    Color? iconColor,
    String? title,
    String? subTitle,
    Color? titleColor,
    Color? subTitleColor,
    String? confirmButtonText,
    void Function()? buttonFunction,
    bool? disableBackButton,
  }) {
    showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: false, // Prevent dialog from closing on tap outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async =>
          disableBackButton ?? true, // Disable back button
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            backgroundColor: backgroundColor ?? Colors.white,
            surfaceTintColor: backgroundColor ?? Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: headerBackgroundColor ?? _getColor(type),
                      borderRadius: type == QuickAlertType.loading
                          ? BorderRadius.circular(15)
                          : const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )),
                  padding: const EdgeInsets.all(16.0),
                  child: type == QuickAlertType.loading
                      ? Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    ),
                  )
                      : _getIcon(type, iconColor),
                ),
                if (title != null || subTitle != null)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        if (title != null)
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: titleColor ?? Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        if (subTitle != null)
                          Text(
                            subTitle,
                            style: TextStyle(
                                color: subTitleColor ?? Colors.black,
                                fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                if (showButtons && type != QuickAlertType.loading)
                  ElevatedButton(
                    onPressed: buttonFunction ??
                            () {
                          Navigator.pop(context);
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmBtnColor ?? Colors.blue,
                    ),
                    child: Text(confirmButtonText ?? 'OK',
                        style: TextStyle(
                            color: confirmBtnColor == Colors.white
                                ? Colors.black
                                : Colors.white)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Color _getColor(QuickAlertType type) {
    switch (type) {
      case QuickAlertType.success:
        return Colors.green;
      case QuickAlertType.error:
        return Colors.red;
      case QuickAlertType.warning:
        return Colors.amber;
      case QuickAlertType.confirm:
        return Colors.blue;
      case QuickAlertType.info:
        return Colors.blue;
      case QuickAlertType.loading:
        return Colors.blue;
    }
  }

  static Icon _getIcon(QuickAlertType type, Color? icnClor) {
    switch (type) {
      case QuickAlertType.success:
        return Icon(Icons.check_circle,
            color: icnClor ?? Colors.white, size: 50.0);
      case QuickAlertType.error:
        return Icon(Icons.error, color: icnClor ?? Colors.white, size: 50.0);
      case QuickAlertType.warning:
        return Icon(Icons.warning, color: icnClor ?? Colors.white, size: 50.0);
      case QuickAlertType.confirm:
        return Icon(Icons.help, color: icnClor ?? Colors.white, size: 50.0);
      case QuickAlertType.info:
        return Icon(Icons.info, color: icnClor ?? Colors.white, size: 50.0);
      case QuickAlertType.loading:
        return Icon(Icons.hourglass_top,
            color: icnClor ?? Colors.white, size: 50.0);
    }
  }
}
