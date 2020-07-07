
import 'package:flutter/material.dart';
import 'package:flutter_todos/localization/list_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_todos/utils/colors.dart';

enum kMoreOptionsKeys {
  clearAll,
  getPermissions,
}
Map<int, String> kMoreOptionsMap = {
  kMoreOptionsKeys.clearAll.index: 'Delete bought items',
  kMoreOptionsKeys.getPermissions.index: 'Request Permission',
};
Map<int, String> kMoreOptionsMapHu = {
  kMoreOptionsKeys.clearAll.index: 'Megvett dolgok törlése',
  kMoreOptionsKeys.getPermissions.index: 'Engedélyek kérése',
};

class Utils {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }


  static void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
    }
  }

  static void showCustomDialog(BuildContext context,
      {String title,
      String msg,
      Function onConfirm,}) {
    final dialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: <Widget>[
        if (onConfirm != null)
          RaisedButton(
            color: Color(BuyColor.kPrimaryColorCode),
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context).translate("yes"),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        RaisedButton(
          color: Color(BuyColor.kSecondaryColorCode),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            AppLocalizations.of(context).translate("no"),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
    showDialog(context: context, builder: (x) => dialog);
  }
}
