import 'dart:convert';

import 'package:ble/DeviceBle.dart';
import 'package:jieba_flutter/analysis/jieba_segmenter.dart';
import 'package:ble/ble.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  String botdevices;
  final ValueChanged<bool> isfreshpageCallBack;
  // ignore: member-ordering
  ChatPage(this.botdevices, {super.key, required this.isfreshpageCallBack});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> implements DeviceListener {
  List<types.Message> _messages = [];
  final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
  var _VabData;

  @override
  void initState() {
    super.initState();
    Ble.getInstance();
    Ble.getInstance().setDeviceListener(this);
    _loadMessages();
    _loadModelVab();
  }

  @override
  void dispose() {
    super.dispose();
    widget.isfreshpageCallBack(true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Chat(
          messages: _messages,
          onAttachmentPressed: _handleAtachmentPressed,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          user: _user,
        ),
      );

  void _loadModelVab() async {
    final response = await rootBundle.loadString('assets/textcnnvab.json');
    final messages = (jsonDecode(response) as List).toList();
    final map = <String, dynamic>{
      for (var item in messages)
        item['index'].toString(): {'token': item['token']},
    };
    setState(() {
      _VabData = map;
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
    print(widget.botdevices);
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
    var _sendtext = _wordsegmen(textMessage);
  }

  Future _wordsegmen(types.TextMessage message) async {
    List<int> _buffersend = [];
    await JiebaSegmenter.init().then((value) {
      final seg = JiebaSegmenter();
      var i = 0;
      for (var item in seg.process(message.text, SegMode.SEARCH)) {
        _VabData.forEach((key, value) {
          if (value['token'] == item.word) {
            _buffersend.add(int.parse(key));
            return;
          }
        });
        if (_buffersend.length == i) {
          _buffersend.add(0);
        }
        i++;
      }
      Ble.getInstance().sendCommend(_buffersend.toString());
    });
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  // ignore: member-ordering
  @override
  void onBluetoothOff() {}
  // ignore: member-ordering
  @override
  void onBluetoothOn() {}
  // ignore: member-ordering
  @override
  void onConnectionStateChange(int status) {}
  // ignore: member-ordering
  @override
  void onFoundDevice(List<DeviceBle> devices) {}

  // ignore: member-ordering
  @override
  void onReConnected() {}
  // ignore: member-ordering
  @override
  void onReceivedDataListener(List byteData) {
    // ignore: omit_local_variable_types
    final List<int> list2 = byteData.map((e) => e as int).toList();
    // ignore: omit_local_variable_types
    String data = "";
    try {
      data = String.fromCharCodes(list2);
    } catch (e) {
      data = "--";
    }
    final textMessage = types.TextMessage(
      author: types.User(id: const Uuid().v4()),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: data,
    );
    _addMessage(textMessage);
  }

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
