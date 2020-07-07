
import 'package:flutter/material.dart';
import 'package:flutter_todos/localization/list_localization.dart';
import 'package:flutter_todos/widgets/shared.dart';
import 'package:flutter_todos/model/model.dart' as Model;
import 'package:flutter_todos/utils/colors.dart';

class Bought extends StatefulWidget {
  final Function onTap;
  final Function onDeleteTask;
  final List<Model.Product> done;

  Bought({@required this.done, this.onTap, this.onDeleteTask});

  @override
  _BoughtState createState() => _BoughtState();
}

class _BoughtState extends State<Bought> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          color: Color(0xffc2c2b4),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              if (widget.done == null || widget.done.length == 0)
                Container(
                  height: 10,
                ),
              if (widget.done != null)
                for (int i = widget.done.length - 1; i >= 0; --i)
                  getTaskItem(
                    widget.done[i].title,
                    index: i,
                    onTap: () {
                      widget.onTap(pos: i);
                    },
                  ),
            ],
          ),
        ),
        SharedWidget.getCardHeader(
            context: context,
            text: AppLocalizations.of(context).translate("bought"),
            backgroundColorCode: BuyColor.kSecondaryColorCode,
            customFontSize: 14),
      ],
    );
  }

  Widget getTaskItem(String text,
      {@required int index, @required Function onTap}) {
    final double height = 50.0;
    return Container(
        child: Column(
      children: <Widget>[
        Dismissible(
          key: Key(text + '$index'),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            widget.onDeleteTask(todo: widget.done[index]);
          },
          background: SharedWidget.getOnDismissDeleteBackground(),
          child: InkWell(
            onTap: onTap,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    height: height,
                    child: Icon(
                      Icons.check,
                      color: Colors.grey[50],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 10, right: 20, bottom: 10),
                      child: Text(
                        text,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.grey[50],
                              decoration: TextDecoration.lineThrough,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 0.5,
          child: Container(
            color: Colors.white54,
          ),
        ),
      ],
    ));
  }
}
