import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/controllers/chats_provider.dart';
import 'package:jobhub/views/common/app_bar.dart';
import 'package:jobhub/views/common/app_style.dart';
import 'package:jobhub/views/ui/chat/chatpage.dart';
import 'package:provider/provider.dart';

import '../../common/drawer/drawer_widget.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatNotifier>(
      builder: (context, chatNotifier, child) {
        chatNotifier.getChats();
        chatNotifier.getUser();
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: CustomAppBar(
              text: "Chats",
              child: Padding(
                  padding: EdgeInsets.all(12.h), child: const DrawerWidget()),
            ),
          ),
          body: FutureBuilder(
            future: chatNotifier.chats,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError == true) {
                return const Text("Error in get chat list");
              } else if (snapshot.data!.isEmpty) {
                return const Text("Chat list is empty");
              } else {
                return ListView.builder(
                    padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: ((context, index) {
                      var chat = snapshot.data![index];
                      var user = chat.users
                          .where((user) => user.id != chatNotifier.userId);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => ChatPage(
                                profile: user.first.profile,
                                name: user.first.username,
                                id: chat.id,
                                users: [chat.users[0].id, chat.users[1].id]));
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            width: width,
                            height: hieght * 0.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.h),
                                color: Color(kLightGrey.value)),
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 4.w),
                              minLeadingWidth: 0,
                              minVerticalPadding: 0,
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(user.first.profile),
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.first.username,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    style: appstyle(16, Color(kDark.value),
                                        FontWeight.w600),
                                  ),
                                  Text(chat.latestMessage.content,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: appstyle(
                                          16,
                                          Color(kDarkGrey.value),
                                          FontWeight.normal))
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(chatNotifier.formatTime(chat.updatedAt)),
                                  Icon(chat.latestMessage.sender.id ==
                                          user.first.id
                                      ? Ionicons.arrow_forward_circle_outline
                                      : Ionicons.arrow_back_circle_outline),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }));
              }
            },
          ),
        );
      },
    );
  }
}
