// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: prefer_const_constructors, prefer_single_quotes, sized_box_for_whitespace, non_constant_identifier_names, always_declare_return_types, type_annotate_public_apis, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, omit_local_variable_types

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:ble/DeviceBle.dart';
import 'package:ble/EventChannelConstant.dart';
import 'package:ble/ble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'chat.dart';

void main() {
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

final ScreenWidth = window.physicalSize.width / window.devicePixelRatio;
final ScreenHeight = window.physicalSize.height / window.devicePixelRatio;
double ButtonDis = ScreenHeight / 3.5;

final ScrollController _controller = ScrollController();
final ScrollController _controllerview = ScrollController();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _appname = "Percept Bot";
  var _appcontrollersize = 22.0;
  var _controllertext = 0.0;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _appcontrollersize = _controller.offset / 10 + 20;
        var offset = (_controller.offset - _controllertext);
        if (offset > 38) {
          _controllerview.jumpTo(-offset);
          ButtonDis = ScreenHeight / 5.7;
          _controllertext = _controller.offset;
        } else if (offset < -50) {
          _controllerview.jumpTo(15);
          ButtonDis = ScreenHeight / 3.6;
          _controllertext = _controller.offset;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned(
            child: CustomScrollView(
              controller: _controller,
              slivers: <Widget>[
                _AppBar(context),
                _FormView(context),
              ],
            ),
          ),
          Positioned(
            top: ButtonDis,
            child: Container(
              height: ScreenHeight,
              width: ScreenWidth,
              child: CustomScrollView(
                controller: _controllerview,
                slivers: const <Widget>[
                  SliverToBoxAdapter(
                    child: FormData(),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  Widget _AppBar(BuildContext context) => SliverAppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarContrastEnforced: true,
        ),
        primary: true,
        toolbarHeight: 90.0,
        expandedHeight: ScreenHeight / 3,
        //actions: _buildActions(context),
        pinned: true,
        backgroundColor: const Color.fromARGB(255, 218, 223, 226),
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: false,
          title: Text(
            _appname,
            style: TextStyle(
              fontSize: _appcontrollersize,
              color: Color.fromARGB(255, 223, 223, 223),
              shadows: const [
                Shadow(color: Colors.black, blurRadius: 1),
              ],
            ),
          ),
          titlePadding: const EdgeInsets.only(left: 25, bottom: 110),
          collapseMode: CollapseMode.parallax,
          stretchModes: const [
            StretchMode.blurBackground,
            StretchMode.zoomBackground,
          ],
          background: Image.asset(
            'assets/images/caver.webp',
            fit: BoxFit.cover,
          ),
        ),
      );

  List<Widget> _buildActions(BuildContext context) => <Widget>[
        IconButton(
          onPressed: () {
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => ChatPage(
                  "a",
                  isfreshpageCallBack: (fresh) {},
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.pets,
            color: Colors.black,
            size: 30,
          ),
        ),
      ];
  Widget _FormView(BuildContext context) => SliverFixedExtentList(
        itemExtent: ScreenHeight / 1.38,
        delegate: SliverChildBuilderDelegate(
          (content, index) => Container(
            color: Color.fromARGB(252, 229, 229, 229),
            child: Column(
              children: const [
                //_description(),
                //_steps(),
              ],
            ),
          ),
          childCount: 1,
        ),
      );
}

// ignore: member-ordering
class FormData extends StatefulWidget {
  const FormData({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormDataState createState() => _FormDataState();
}

class _FormDataState extends State<FormData> implements DeviceListener {
  int _position = 0;
  String _BLEConnectd = "";
  String _platformVersion = 'Unknown';
  bool IsConnected = false;
  bool isBLEConnected = false;
  bool isfreshpage = false;
  List<DeviceBle> devices = [];
  String botdevices = "";
  var _crossFadeState = CrossFadeState.showFirst;
  bool get isFirst => _crossFadeState == CrossFadeState.showFirst;

  @override
  void initState() {
    super.initState();
    Ble.getInstance();
    requestPermission();
    initPlatformState();
    Ble.getInstance().setDeviceListener(this);
  }

  requestPermission() async {
    PermissionStatus permissionStatus = await Permission.location.status;
    if (permissionStatus.isDenied) {
      List<Permission> permissions = [];
      if (Platform.isIOS) {
        permissions = [Permission.storage, Permission.phone];
      } else {
        permissions = [
          Permission.location,
          Permission.storage,
          Permission.phone,
        ];
      }
      Map<Permission, PermissionStatus> statuses = await permissions.request();
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Ble.getInstance().platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) => Container(
        height: ScreenHeight / 1.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(28)),
          boxShadow: const [],
        ),
        child: _ViewCard(context),
      );

  Card _ViewCard(BuildContext context) => Card(
        color: Color.fromARGB(237, 252, 252, 252),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.only(
          left: ScreenWidth / 15,
          right: ScreenWidth / 15,
          top: ScreenHeight / 70,
          bottom: ScreenHeight / 70,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 200, top: 30),
              child: Text(
                '连接状态',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  wordSpacing: 100.0,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _StartChatButton(context),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                IsConnected ? "已连接" : "未连接",
                style: TextStyle(
                  fontSize: 27,
                  wordSpacing: 100.0,
                  color: Colors.blue,
                ),
              ),
            ),
            StepperCop(_position),
            AnimatedCrossFade(
              firstChild: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
                child: MaterialButton(
                  elevation: 5,
                  textColor: Colors.white,
                  splashColor: Colors.blueAccent,
                  highlightColor: Colors.blueAccent,
                  child: Text(IsConnected ? "连接中.." : "开始连接"),
                  onPressed: () async {
                    _controller.jumpTo(80);
                    setState(() {
                      IsConnected = true;
                    });
                    Timer(Duration(milliseconds: 50), () async {});
                    final PermissionStatus permissionStatus =
                        await Permission.location.status;
                    if (permissionStatus.isDenied) {
                      IsConnected = false;
                      return print("请确认权限是否开启！");
                    }
                    Timer(Duration(milliseconds: 4000), () async {
                      await Ble.getInstance().startScanBluetooth;
                    });
                    if (!await Ble.getInstance().isEnabled) {
                      Ble.getInstance().enabled();
                    } else {
                      Timer(Duration(milliseconds: 1000), () async {});
                      _position = 1;
                    }
                  },
                ),
              ),
              secondChild: Row(
                // spacing: 20,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: new Border.all(width: 1.5, color: Colors.blue),
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                    child: MaterialButton(
                      elevation: 5,
                      textColor: Colors.blue,
                      splashColor: Colors.blue,
                      highlightColor: Colors.blue,
                      child: Text(
                        "断开连接",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      onPressed: () async {
                        Timer(Duration(milliseconds: 200), () async {
                          if (isfreshpage) {
                            Ble.getInstance().setDeviceListener(this);
                          }
                        });

                        Ble.getInstance().disconnect();
                        setState(() {
                          _position = 0;
                          _crossFadeState = CrossFadeState.showFirst;
                          IsConnected = false;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 8 - 30,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                    child: MaterialButton(
                      elevation: 6,
                      textColor: Colors.white,
                      splashColor: Color.fromARGB(255, 25, 146, 87),
                      highlightColor: Color.fromARGB(255, 25, 146, 87),
                      child: Text("开始聊天"),
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => MaterialApp(
                              home: ChatPage(
                                botdevices,
                                isfreshpageCallBack: (fresh) {
                                  isfreshpage = fresh;
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              crossFadeState: _crossFadeState,
              duration: Duration(milliseconds: 300),
            ),
          ],
        ),
      );

  Image _StartChatButton(BuildContext context) => Image(
        width: ScreenWidth / 4,
        height: ScreenWidth / 4,
        image: Svg(
          'assets/images/begin.svg',
        ),
      );
  // ignore: member-ordering
  @override
  void onBluetoothOff() {}

  // ignore: member-ordering
  @override
  void onBluetoothOn() {
    _position++;
  }

  // ignore: member-ordering
  @override
  void onConnectionStateChange(int status) {
    if (status == EventChannelConstant.STATE_CONNECTED) {
      isBLEConnected = true;
      setState(() {
        _crossFadeState = CrossFadeState.showSecond;
        IsConnected = true;
      });
      Timer(Duration(milliseconds: 500), () async {
        await Ble.getInstance().stopScanBluetooth;
      });
    } else if (status == EventChannelConstant.STATE_DISCONNECTED) {
      isBLEConnected = false;
      setState(() {
        _crossFadeState = CrossFadeState.showFirst;
        IsConnected = false;
      });
    }
  }

  // ignore: member-ordering
  @override
  Future<void> onFoundDevice(List<DeviceBle> devices) async {
    Timer(Duration(milliseconds: 2000), () async {});
    bool findbot = false;
    String botaddress = "";
    int count = 0;
    for (var pBot in devices) {
      if (pBot.name == "PerceptBot") {
        findbot = true;
        botaddress = pBot.address;
        botdevices = pBot.toString();
      }
    }
    //Timer(Duration(milliseconds: 500), () async {});
    if (findbot) {
      if (!await Ble.getInstance().isConnect &&
          await Ble.getInstance().status == "disconnect") {
        setState(() {
          _position = 2;
        });
        Ble.getInstance().connect(botaddress);
      }
    } else {
      await Ble.getInstance().stopScanBluetooth;
    }
  }

  // ignore: member-ordering
  @override
  void onReConnected() {}

  // ignore: member-ordering
  @override
  void onReceivedDataListener(List byteData) {}

  // ignore: member-ordering
  @override
  void onScanStart() {}

  // ignore: member-ordering
  @override
  void onScanStop() {}

  // ignore: member-ordering
  @override
  void onServiceCharac(Map data) {}

  // ignore: member-ordering
  @override
  void onServicesDiscovered() {}

  // ignore: member-ordering
  @override
  void onServicesNotSupport() {}
}

// ignore: must_be_immutable
class StepperCop extends StatefulWidget {
  int _position;
  // ignore: member-ordering
  StepperCop(this._position);

  @override
  // ignore: library_private_types_in_public_api
  _StepperCopState createState() => _StepperCopState();
}

class _StepperCopState extends State<StepperCop> {
  // ignore: member-ordering
  final stepsData = {
    "打开蓝牙": '打开蓝牙',
    "配对注册": '配对注册',
    "注册完成": '注册完成',
  };

  // ignore: member-ordering
  final steps = [
    Step(
      title: Text("打开蓝牙"),
      content: Text("打开蓝牙"),
    ),
    Step(title: Text("配对注册"), content: Text("配对注册")),
    Step(title: Text("注册完成"), content: Text("注册完成")),
  ];

  @override
  Widget build(BuildContext context) => Container(
        height: 260,
        margin: const EdgeInsets.only(
          left: 60,
          top: 10,
        ),
        child: Stepper(
          controlsBuilder: (BuildContext context, ControlsDetails details) =>
              Row(
            children: const <Widget>[],
          ),
          // Type: StepperType.horizontal,.
          currentStep: widget._position,
          steps: stepsData.keys.map((e) {
            final isActive =
                stepsData.keys.toList().indexOf(e) == widget._position;
            return Step(
              title: Text(
                e,
                style: TextStyle(color: isActive ? Colors.blue : Colors.black),
              ),
              isActive: isActive,
              state: _getState(stepsData.keys.toList().indexOf(e)),
              content: Container(
                height: 60,
                child: const ListTile(
                  title: Text(
                    '稍等片刻',
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Text(
                    '即刻就好',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
  StepState _getState(index) {
    if (widget._position == index) return StepState.indexed;
    if (widget._position > index) return StepState.complete;
    return StepState.indexed;
  }
}
