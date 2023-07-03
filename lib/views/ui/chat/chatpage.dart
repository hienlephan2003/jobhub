import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub/controllers/chats_provider.dart';
import 'package:jobhub/models/request/messaging/send_message.dart';
import 'package:jobhub/models/response/messaging/messaging_res.dart';
import 'package:jobhub/services/helpers/messaginghelper.dart';
import 'package:jobhub/views/common/height_spacer.dart';
import 'package:jobhub/views/common/reusable_text.dart';
import 'package:jobhub/views/common/width_spacer.dart';
import 'package:jobhub/views/ui/chat/widgets/message_textfield.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../constants/app_constants.dart';
import '../../common/app_bar.dart';
import '../../common/app_style.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key,
      required this.id,
      required this.profile,
      required this.name,
      required this.users});
  final String id;
  final String profile;
  final String name;
  final List<String> users;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Future<List<MessageRes>> msgList;
  // late int offset = 1;
  double offset = 0;
  bool fetchNew = false;
  bool isCanFetch = true;
  bool isCanUpdateScroll = false;
  TextEditingController messageController = TextEditingController();
  List<MessageRes> messages = [];
  final ScrollController scrollController = ScrollController();
  String receiver = '';
  IO.Socket? socket;
  @override
  void initState() {
    getMessages();
    handleNext();
    connect();
    joinChat();
    print("init state");

    super.initState();
  }

  void handleNext() {
    scrollController.addListener(() async {
      if (scrollController.hasClients) {
        if (scrollController.position.maxScrollExtent ==
            scrollController.position.pixels) {
          print("loading<><><>");
          offset = scrollController.position.pixels;
          if (messages.length >= 12 && isCanFetch == true) {
            isCanUpdateScroll = true;
            getMessages();
            setState(() {});
            // scrollController.position.animateTo(offset,
            //     duration: Duration.zero, curve: Curves.bounceIn);
          }
        }
        // if (scrollController.position.maxScrollExtent > offset &&
        //     isCanUpdateScroll) {
        //   scrollController.jumpTo(offset - 1);
        //   isCanUpdateScroll = false;
        // }
      }
    });
  }

  void connect() {
    var chatNotifier = Provider.of<ChatNotifier>(context, listen: false);
    socket = IO.io(
        'https://chatapp-backend-production-a15c.up.railway.app',
        <String, dynamic>{
          "transports": ['websocket'],
          "autoConnect": false,
        });
    socket!.emit("setup", chatNotifier.userId);
    socket!.connect();
    socket!.onConnect((_) {
      print("Connected to frontend");
      socket!.on('online-users', (userId) {
        chatNotifier.online
            .replaceRange(0, chatNotifier.online.length, [userId]);
      });

      socket!.on('typing', (status) {
        chatNotifier.typingStatus = true;
      });

      socket!.on('stop typing', (status) {
        chatNotifier.typingStatus = false;
      });
      socket!.on('message received', (newMessage) {
        sendStopTyping(widget.id);
        MessageRes receivedMessage = MessageRes.fromJson(newMessage);
        if (receivedMessage.sender.id != chatNotifier.userId) {
          setState(() {
            messages.insert(0, receivedMessage);
          });
        }
      });
    });
  }

  void getMessages() {
    print("run get messages");
    msgList = MessagingHelper.recieveMessage(widget.id, messages.length);
    fetchNew = true;
  }

  void sendMessage(String content, String chatId, String receiver) {
    SendMessage model =
        SendMessage(chatId: chatId, content: content, reciever: receiver);
    MessagingHelper.sendMessage(model).then((res) {
      var emission = res[2];
      socket!.emit('new message', emission);
      sendStopTyping(widget.id);
      setState(() {
        messageController.clear();
        messages.insert(0, res[1]);
      });
    });
  }

  void sendTypingEvent(String status) {
    socket!.emit('typing', status);
  }

  void joinChat() {
    socket!.emit('join chat', widget.id);
  }

  void sendStopTyping(String status) {
    socket!.emit('stop typing', status);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatNotifier>(builder: (context, chatNotifier, child) {
      receiver = widget.users.firstWhere((id) => id != chatNotifier.userId);
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
            text: chatNotifier.typing ? widget.name : "typing.......",
            actions: [
              Stack(children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(widget.profile),
                ),
                Positioned(
                    right: 3,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: chatNotifier.online.contains(receiver)
                          ? Colors.green
                          : Colors.grey,
                    ))
              ])
            ],
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Padding(
                  padding: EdgeInsets.all(12.h),
                  child: const Icon(CupertinoIcons.arrow_left)),
            ),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(children: [
            Expanded(
              child: FutureBuilder(
                future: msgList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      messages.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError == true) {
                    return const Text("Error in get chat list");
                  } else if (snapshot.data!.isEmpty && messages.isEmpty) {
                    return const Text("Chat list is empty");
                  } else {
                    if (snapshot.data!.isEmpty) {
                      isCanFetch = false;
                    }
                    final msgList = snapshot.data;
                    if (fetchNew == true &&
                        snapshot.connectionState == ConnectionState.done) {
                      messages = messages + msgList!;
                      fetchNew = false;
                    }
                    // WidgetsBinding.instance.addPostFrameCallback((_) {
                    //   if (scrollController.hasClients) {
                    //     scrollController.jumpTo(offset);
                    //   }
                    // });
                    return ListView.builder(
                        padding: EdgeInsets.fromLTRB(20.h, 10.h, 20.h, 0),
                        itemCount: messages.length,
                        reverse: true,
                        controller: scrollController,
                        itemBuilder: ((context, index) {
                          var chat = messages[index];
                          bool isSender = chat.sender.id == chatNotifier.userId;
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h, bottom: 12.h),
                            child: Column(
                              children: [
                                ReusableText(
                                    text:
                                        chatNotifier.formatTime(chat.updatedAt),
                                    style: appstyle(10, Color(kDark.value),
                                        FontWeight.normal)),
                                const HeightSpacer(size: 15),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isSender == false
                                        ? CircleAvatar(
                                            radius: 12,
                                            backgroundImage:
                                                NetworkImage(widget.profile),
                                          )
                                        : const SizedBox.shrink(),
                                    WidthSpacer(width: 5),
                                    Expanded(
                                      child: ChatBubble(
                                        alignment: isSender
                                            ? Alignment.bottomRight
                                            : Alignment.bottomLeft,
                                        elevation: 0,
                                        clipper: ChatBubbleClipper4(
                                            radius: 8,
                                            type: isSender
                                                ? BubbleType.sendBubble
                                                : BubbleType.receiverBubble),
                                        backGroundColor: isSender
                                            ? Color(kOrange.value)
                                            : Color(kLightBlue.value),
                                        margin: EdgeInsets.only(bottom: 8.h),
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: width * 0.7,
                                            maxHeight: 200,
                                          ),
                                          child: ReusableText(
                                              maxLines: 10,
                                              text: chat.content,
                                              style: appstyle(
                                                14,
                                                Color(kLight.value),
                                                FontWeight.normal,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }));
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(12.h),
              alignment: Alignment.bottomCenter,
              child: MessagingTextField(
                controller: messageController,
                onSubmitted: (_) {},
                onChanged: (value) {
                  sendTypingEvent(widget.id);
                },
                suffixIcon: GestureDetector(
                  onTap: () {
                    String msg = messageController.text;
                    sendMessage(msg, widget.id, receiver);
                  },
                  child: Icon(
                    Icons.send,
                    size: 24,
                    color: Color(kLightBlue.value),
                  ),
                ),
              ),
            )
          ]),
        )),
      );
    });
  }
}
