import 'package:url_launcher/url_launcher.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todos/widgets/header.dart';

import 'localization/list_localization.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void dispose() {
    super.dispose();
  }

  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    getAllContacts();
  }

  getAllContacts() async {
    List<Contact> _contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20.0),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Wrap(
                  children: <Widget>[
                    Container(
                      width:MediaQuery.of(context).size.width,
                      child:Align(alignment: Alignment.center, child: Header()),
                    ),
                    Center(
                      child: Text(
                          AppLocalizations.of(context).translate("contactList"),
                          style:
                              TextStyle(fontSize: 20, fontFamily: "Helvetica")),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  Contact contact = contacts[index];
                  return Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF000000)),
                      ),
                    ),
                    child: ListTile(
                        title: Text(contact.displayName),
                        subtitle: Text(
                          contact.phones.elementAt(0).value,
                        ),
                        leading: (contact.avatar != null &&
                                contact.avatar.length > 0)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(contact.avatar),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.deepPurpleAccent,
                                ),
                                child: CircleAvatar(
                                    child: Text(contact.initials(),
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.transparent)),
                        onTap: () {
                          _launchCall(contact.phones.elementAt(0).value);
                        }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchCall(number) {
    launch("tel://" + number);
  }
}
