import 'dart:io';
import 'package:flutter_todos/localization/list_localization.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_todos/globals.dart' as globals;
import 'package:flutter_todos/pictureGallery.dart';

class Header extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HeaderState();
  }
}

class _HeaderState extends State<Header> {
  final cameras = availableCameras();
  File _image;
  final picker = ImagePicker();

  void _checkImage() {
    if (globals.profilePicture != null) {
      setState(() {
        _image = File(globals.profilePicture.path);
      });
    }
  }

  Future _getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 5,
    );
    setState(() {
      _image = File(pickedFile.path);
      globals.profilePicture = _image;
    });
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    _checkImage();
  }

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      child: Container(
        padding: EdgeInsets.only(left: 15.0, top: 30.0),
        child: Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {

                    setState(() {
                      _showSelectionDialog(context);
                      _checkImage();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: _image == null
                          ? Icon(Icons.add)
                          : Image.file(
                              _image,
                              fit: BoxFit.fill,
                              height: 50,
                              width: 50,
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).translate("title"),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontFamily: 'Helvetica', fontSize: 23),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(AppLocalizations.of(context).translate("setProfilePic")),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(AppLocalizations.of(context).translate("gallery")),
                      onTap: () {
                        _getImage();
                        Navigator.of(context).pop();
                      },
                    ),
                    Padding(padding: EdgeInsets.all(20.0)),
                    GestureDetector(
                      child: Text(AppLocalizations.of(context).translate("camera")),
                      onTap: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TakePictureScreen(camera: globals.camera)),
                        );
                        setState(() {
                          _checkImage();
                        });
                      },
                    ),
                    Padding(padding: EdgeInsets.all(20.0)),
                    GestureDetector(
                      child: Text(AppLocalizations.of(context).translate("delProfilePic"),style: TextStyle(color: Colors.red),),
                      onTap: () {
                        globals.profilePicture = null;
                        Navigator.of(context).pop();
                        setState(() {
                          _checkImage();
                        });
                      },
                    ),

                  ],
                ),
              ));
        });
  }
}
