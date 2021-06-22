import 'dart:convert';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  FocusNode _focusNode;
  String title = "Please Select";
  String page = "Please Select";
  bool isTechnicial = false;
  bool isReportBug = false;
  bool isSaving = false;
  final txtDescription = TextEditingController();
  final txtEmail = TextEditingController();
  final txtDeviceModel = TextEditingController();
  final txtFunCardsVersion = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Technical Support,Billing,Suggestions,Contact Corporate
  final titleList = [
    'Please Select',
    'Technical Support',
    'Billing',
    'Suggestions',
    'Contact Corporate',
    'Report a Bug'
  ];

  final pageList = [
    'Please Select',
    'Login',
    'Setup',
    'Playlist',
    'Photo Gallery',
    'Business Page',
    'Sharing',
    'Reporting',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isSaving = true;
      });

      if (title == "Please Select") {
        _showFlushbar(
            context,
            'Please choose from the "How May We Help selection box"',
            Colors.red,
            Icons.dangerous);
        setState(() {
          isSaving = false;
        });

        return;
      }

      if (title == "Technical Support" && page == "Please Select") {
        _showFlushbar(
            context, 'Please select page', Colors.red, Icons.dangerous);
        setState(() {
          isSaving = false;
        });

        return;
      }

      SharedPreferences sharedPreferences;
      sharedPreferences = await SharedPreferences.getInstance();
      String email = sharedPreferences.getString('email');

      if (txtEmail.text.isNotEmpty) {
        email = txtEmail.text;
      }

      String encoded =
          base64.encode(utf8.encode(Constants.freshDeskAPIToken + ":X"));

      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Basic " + encoded,
      };

      var modelVersion = "Device Model: " +
          txtDeviceModel.text +
          " FunCards version: " +
          txtFunCardsVersion.text;

      final json = jsonEncode({
        "description": title == "Report a Bug"
            ? modelVersion + "\n " + txtDescription.text
            : txtDescription.text,
        "subject":
            title == "Technical Support" ? title + " / Page - " + page : title,
        "email": email,
        "priority": 1,
        "status": 2,
        "type": title,
      });

      try {
        Response response = await post(Constants.freshDeskCreateTicket,
            headers: headers, body: json);
        int statusCode = response.statusCode;
        print(response.body);

        if (statusCode == 201) {
          _showFlushbar(
              context,
              "Your request has been received and will be answered via Email.",
              Colors.green,
              Icons.check);

          setState(() {
            txtEmail.text = "";
            txtDescription.text = "";
            txtDeviceModel.text = "";
            txtFunCardsVersion.text = "";
            title = "Please Select";
            page = "Please Select";
            isSaving = false;
          });
        } else {
          _showFlushbar(context, "Something went wrong. Please try again later",
              Colors.red, Icons.dangerous);
          setState(() {
            isSaving = false;
          });
        }
      } catch (ex) {
        _showFlushbar(context, "Something went wrong. Please try again later",
            Colors.red, Icons.dangerous);
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  _txtDeviceModel() {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: TextFormField(
        controller: txtDeviceModel,
        decoration: new InputDecoration(
            enabledBorder: const OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            ),
            border: const OutlineInputBorder(),
            labelStyle: new TextStyle(color: Colors.green),
            filled: true,
            fillColor: Colors.white70),
      ),
    );
  }

  _txtFunCardsVersion() {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: TextFormField(
        controller: txtFunCardsVersion,
        decoration: new InputDecoration(
            enabledBorder: const OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            ),
            border: const OutlineInputBorder(),
            labelStyle: new TextStyle(color: Colors.green),
            filled: true,
            fillColor: Colors.white70),
      ),
    );
  }

  _txtEmail() {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: TextFormField(
          controller: txtEmail,
          decoration: new InputDecoration(
              enabledBorder: const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
              border: const OutlineInputBorder(),
              labelStyle: new TextStyle(color: Colors.green),
              filled: true,
              fillColor: Colors.white70),
          validator: (value) {
            if (value.isNotEmpty) {
              var email = value;
              bool isValidEmail =
                  RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(email);

              if (!isValidEmail) {
                return 'Invalid Email Address';
              }
            }
          }),
    );
  }

  _txtDescription() {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: TextFormField(
        focusNode: _focusNode,
        controller: txtDescription,
        maxLines: 8,
        autofocus: false,
        textInputAction: TextInputAction.done,
        decoration: new InputDecoration(
            enabledBorder: const OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            ),
            border: const OutlineInputBorder(),
            labelStyle: new TextStyle(color: Colors.green),
            filled: true,
            fillColor: Colors.white70),
        validator: (value) {
          if (value.isEmpty) {
            return 'Cannot be empty';
          }
        },
        onEditingComplete: () {
          _focusNode.unfocus();
        },
      ),
    );
  }

  _showFlushbar(BuildContext context, String text, Color color, IconData icon) {
    Size _screenSize = MediaQuery.of(context).size;
    Flushbar(
      maxWidth: _screenSize.width - 20,
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 10.0),
      borderRadius: 8.0,
      message: text,
      icon: Icon(
        icon,
        size: 28,
        color: color,
      ),
      leftBarIndicatorColor: color,
      duration: Duration(seconds: 5),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      reverseAnimationCurve: Curves.fastLinearToSlowEaseIn,
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/FunCards_logo.png',
              fit: BoxFit.cover,
              width: 100,
            ),
          ],
        ),
        centerTitle: false,
        titleSpacing: 0.0,
        actions: <Widget>[
          isSaving
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                  child: GestureDetector(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Color(0xff088AC7),
                      ),
                    ),
                    onTap: () async {
                      await _submit();
                    },
                  ),
                )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  "Customer Support",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Feedback is Crucial",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "How May We Help",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: _width,
                        height: 50.0,
                        child: Card(
                          elevation: 2.0,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xff088AC7),
                                  ),
                                  iconSize: 30,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                  ),
                                  items: titleList.map((String dropdownItem) {
                                    return DropdownMenuItem<String>(
                                      value: dropdownItem,
                                      child: Text(
                                        dropdownItem,
                                        textScaleFactor: 1.0,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String newValueSelected) {
                                    setState(() {
                                      title = newValueSelected;
                                      if (title == 'Technical Support')
                                        isTechnicial = true;
                                      else
                                        isTechnicial = false;

                                      if (title == 'Report a Bug')
                                        isReportBug = true;
                                      else
                                        isReportBug = false;
                                    });
                                  },
                                  value: title,
                                ),
                              )),
                        ),
                      ),
                      isTechnicial || isReportBug
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Page",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: _width,
                                  height: 50.0,
                                  child: Card(
                                    elevation: 2.0,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: Color(0xff088AC7),
                                            ),
                                            iconSize: 30,
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black),
                                            items: pageList
                                                .map((String dropdownItem) {
                                              return DropdownMenuItem<String>(
                                                value: dropdownItem,
                                                child: Text(
                                                  dropdownItem,
                                                  textScaleFactor: 1.0,
                                                ),
                                              );
                                            }).toList(),
                                            onChanged:
                                                (String newValueSelected) {
                                              setState(() {
                                                page = newValueSelected;
                                              });
                                            },
                                            value: page,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      isReportBug
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Device/Model (optional)",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                _txtDeviceModel(),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "FunCards Version (optional)",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                _txtFunCardsVersion(),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _txtEmail(),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _txtDescription(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
