import 'package:flutter/material.dart';
import 'package:flutter_todos/widgets/header.dart';
import 'package:flutter_todos/widgets/task_input.dart';
import 'package:flutter_todos/widgets/todo.dart';
import 'package:flutter_todos/widgets/done.dart';
import 'package:flutter_todos/model/model.dart' as Model;
import 'package:flutter_todos/model/db_wrapper.dart';
import 'package:flutter_todos/utils/utils.dart';
import 'package:flutter_todos/widgets/popup.dart';
import 'mappage.dart';
import 'contactpage.dart';
import 'widgets/popup.dart';
import 'package:camera/camera.dart';
import 'globals.dart' as globals;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_todos/localization/list_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.last;
  globals.camera = firstCamera;
  if (globals.firstrun) {
    globals.firstrun = false;
    runApp(ShoppingListApp());
    Services().requestPermission();
  } else {
    runApp(ShoppingListApp());
  }
}

class ShoppingListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        backgroundColor: Color(0xffffffee),
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('hu', 'HU'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },

      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cameras = availableCameras();
  List<Model.Product> products;
  List<Model.Product> done;

  //String _selection;

  @override
  void initState() {
    super.initState();
    getBuyAndDones();
  }

  final controller = PageController(
    initialPage: 1,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: PageView(
        controller: controller,
        children: <Widget>[
          MapPage(),
          SafeArea(
            child: GestureDetector(
              onTap: () {
                Utils.hideKeyboard(context);
              },
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).backgroundColor,
                    floating: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Header(),
                                        Container(
                                          margin: EdgeInsets.only(top: 35),
                                          child: Popup(
                                            getBuyAndDone: getBuyAndDones,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: TaskInput(
                                      onSubmitted: addTaskInTodo,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    expandedHeight: 200,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        switch (index) {
                          case 0:
                            return Buy(
                              buys: products,
                              onTap: markTodoAsDone,
                              onDeleteTask: deleteTask,
                            );
                          case 1:
                            return SizedBox(
                              height: 30,
                            );
                          default:
                            return Bought(
                              done: done,
                              onTap: markDoneAsTodo,
                              onDeleteTask: deleteTask,
                            );
                        }
                      },
                      childCount: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ContactPage(),
          //GalleryPage(),
          //TakePictureScreen(camera: globals.camera,),
        ],
      ),
    );
  }

  void getBuyAndDones() async {
    final _products = await DBWrapper.sharedInstance.getProducts();
    final _done = await DBWrapper.sharedInstance.getDones();
    setState(() {
      products = _products;
      done = _done;
    });
  }

  void addTaskInTodo({@required TextEditingController controller}) {
    final inputText = controller.text.trim();
    if (inputText.length > 0) {
      Model.Product todo = Model.Product(
        title: inputText,
        created: DateTime.now(),
        updated: DateTime.now(),
        status: Model.ProductStatus.active.index,
      );
      DBWrapper.sharedInstance.addProduct(todo);
      getBuyAndDones();
    } else {
      Utils.hideKeyboard(context);
    }
    controller.text = '';
  }

  void markTodoAsDone({@required int pos}) {
    DBWrapper.sharedInstance.markProductAsDone(products[pos]);
    getBuyAndDones();
  }

  void markDoneAsTodo({@required int pos}) {
    DBWrapper.sharedInstance.markDoneAsProduct(done[pos]);
    getBuyAndDones();
  }

  void deleteTask({@required Model.Product todo}) {
    DBWrapper.sharedInstance.deleteProduct(todo);
    getBuyAndDones();
  }
}
