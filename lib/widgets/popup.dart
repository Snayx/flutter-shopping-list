import 'package:flutter/material.dart';
import 'package:flutter_todos/localization/list_localization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_todos/model/db_wrapper.dart';
import 'package:flutter_todos/utils/utils.dart';

class Services {
  void requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationAlways,
      Permission.contacts,
      Permission.camera,
      Permission.storage,
    ].request();
  }
}

class Popup extends StatelessWidget {
  Function getBuyAndDone;

  Popup({this.getBuyAndDone});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        elevation: 4,
        icon: Icon(Icons.more_vert),
        onSelected: (value) {
          if (value == kMoreOptionsKeys.clearAll.index) {
            print(value);
            Utils.showCustomDialog(context,
                title:
                    '${AppLocalizations.of(context).translate("sureDelete")}',
                msg: '${AppLocalizations.of(context).translate("msgSureDel")}',
                onConfirm: () {
              DBWrapper.sharedInstance.deleteAllDoneProduct();
              getBuyAndDone();
            });
          } else if (value == kMoreOptionsKeys.getPermissions.index) {
            Services().requestPermission();
          }
        },
        itemBuilder: (context) {
          List list = List<PopupMenuEntry<int>>();

          for (int i = 0; i < kMoreOptionsMap.length; ++i) {
            if (AppLocalizations.of(context).locale.languageCode == "hu") {
              list.add(
                  PopupMenuItem(value: i, child: Text(kMoreOptionsMapHu[i])));
            } else {
              list.add(
                  PopupMenuItem(value: i, child: Text(kMoreOptionsMap[i])));
            }
            if (i == 0) {
              list.add(PopupMenuDivider(
                height: 5,
              ));
            }
          }

          return list;
        });
  }
}
