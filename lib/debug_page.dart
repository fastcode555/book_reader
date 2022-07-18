import 'dart:io';

import 'package:book_reader/api/apis.dart';
import 'package:flutter/material.dart';
import 'package:infinity_core/core.dart';

class DebugPage extends StatefulWidget {
  static const String routeName = '/login/DebugPage';

  const DebugPage({Key? key}) : super(key: key);

  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  String? _host;

  @override
  void initState() {
    super.initState();
    _host = Apis.resolveHost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("调试页面"),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            // margin: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: <Widget>[
                _buildCenterLogo(),
                _buildHostWidget("外网测试", Apis.hostTest),
                _buildHostWidget("外网预备", Apis.hostPrepare),
                _buildHostWidget("正式环境", Apis.host),
                ...Global.languages.mapWidget(
                  (index, t) => TextButton(
                      onPressed: () {
                        LanguageUtil.setLocalModel(t);
                        Navigator.of(context).pop();
                      },
                      child: Text(t.titleId)),
                ),
                _buildConfirmWidget(),
              ],
            ),
          ),
        ));
  }

  _buildHostWidget(String title, String host) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _host = host;
        });
        await SpUtil.putString(Apis.hostTestKey, host);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.grey, width: 1)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(host,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Icon(
                Icons.check_box,
                color: host == _host ? Colors.deepOrange : Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildConfirmWidget() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
            child: const Text(
              "取消",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              NavigatorUtil.pop();
            },
          ),
          const SizedBox(width: 50.0),
          FlatButton(
            child: const Text(
              "确认",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              await Apis.switchHost(_host).then((value) {
                exit(0);
              });
            },
          )
        ],
      ),
    );
  }

  _buildCenterLogo() {
    return const Align(
      alignment: Alignment.topCenter,
      child: Icon(Icons.star, size: 200.0, color: Colors.blue),
    );
  }
}
