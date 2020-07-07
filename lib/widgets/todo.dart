
import 'package:flutter/material.dart';
import 'package:flutter_todos/localization/list_localization.dart';
import 'package:flutter_todos/widgets/shared.dart';
import 'package:flutter_todos/model/model.dart' as Model;
import 'package:flutter_todos/utils/colors.dart';

const int NoTask = -1;
const int animationMilliseconds = 500;

class Buy extends StatefulWidget {
  final Function onTap;
  final Function onDeleteTask;
  final List<Model.Product> buys;

  Buy({@required this.buys, this.onTap, this.onDeleteTask});

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<Buy> {
  int taskPosition = NoTask;
  bool showCompletedTaskAnimation = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              if (widget.buys == null || widget.buys.length == 0)
                Container(
                  height: 10,
                ),
              if (widget.buys != null)
                for (int i = 0; i < widget.buys.length; ++i)
                  AnimatedOpacity(
                    curve: Curves.fastOutSlowIn,
                    opacity: taskPosition != i
                        ? 1.0
                        : showCompletedTaskAnimation ? 0 : 1,
                    duration: Duration(seconds: 1),
                    child: getTaskItem(
                      widget.buys[i].title,
                      index: i,
                      onTap: () {
                        setState(() {
                          taskPosition = i;
                          showCompletedTaskAnimation = true;
                        });
                        Future.delayed(
                          Duration(milliseconds: animationMilliseconds),
                        ).then((value) {
                          taskPosition = NoTask;
                          showCompletedTaskAnimation = false;
                          widget.onTap(pos: i);
                        });
                      },
                    ),
                  ),
            ],
          ),
        ),
        SharedWidget.getCardHeader(
            context: context, text: AppLocalizations.of(context).translate("want"), customFontSize: 14),
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
            widget.onDeleteTask(todo: widget.buys[index]);
          },
          background: SharedWidget.getOnDismissDeleteBackground(),
          child: InkWell(
            onTap: onTap,
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    width: 7,
                    decoration: BoxDecoration(
                      color: BuyColor.sharedInstance.leadingTaskColor(index),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 15, right: 20, bottom: 15),
                      child: Text(
                        text,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Color(0xff373640),
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
            color: Colors.grey,
          ),
        ),
      ],
    ));
  }
}
