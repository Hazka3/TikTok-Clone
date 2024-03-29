import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils/utils_darkmode.dart';

class ChatDetailScreen extends StatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL = ":chatId";

  final String chatId;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  String _inputText = "";
  bool _isWriting = false;

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  void _stopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {
        _inputText = _textEditingController.text;
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            children: [
              const Positioned(
                child: Padding(
                  padding: EdgeInsets.all(Sizes.size5),
                  child: CircleAvatar(
                    radius: Sizes.size24,
                    foregroundImage: NetworkImage(
                        "https://avatars.githubusercontent.com/u/94900388?v=4"),
                    child: Text('は'),
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 3, color: Colors.white),
                    color: Colors.green.shade400,
                  ),
                ),
              )
            ],
          ),
          trailing: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.flag,
                size: Sizes.size20,
              ),
              Gaps.h28,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                size: Sizes.size20,
              ),
            ],
          ),
          title: Text(
            'はづか (${widget.chatId})',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            'Active now',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: _stopWriting,
        child: Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.only(
                right: Sizes.size20,
                left: Sizes.size20,
                top: Sizes.size14,
                bottom: Sizes.size96 + Sizes.size20,
              ),
              itemBuilder: (context, index) {
                final isMine = index % 2 == 0;
                return Row(
                  mainAxisAlignment:
                      isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(
                        Sizes.size14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(Sizes.size20),
                          topRight: const Radius.circular(Sizes.size20),
                          bottomLeft: Radius.circular(
                            isMine ? Sizes.size20 : Sizes.size5,
                          ),
                          bottomRight: Radius.circular(
                            isMine ? Sizes.size5 : Sizes.size20,
                          ),
                        ),
                        color: isMine
                            ? Colors.blue
                            : Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        "This is a message!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.size16,
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => Gaps.v10,
              itemCount: 10,
            ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: Sizes.size10,
                    bottom: Sizes.size24,
                    right: Sizes.size18,
                    left: Sizes.size18,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: Sizes.size48,
                          child: TextField(
                            onTap: _onStartWriting,
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              hintText: "Send a message...",
                              contentPadding: const EdgeInsets.only(
                                left: Sizes.size16,
                                top: Sizes.size10,
                                bottom: Sizes.size10,
                              ),
                              hintStyle: TextStyle(
                                color: isDarkMode(context)
                                    ? Colors.grey.shade300
                                    : Colors.black45,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Sizes.size20),
                                  topRight: Radius.circular(Sizes.size20),
                                  bottomLeft: Radius.circular(Sizes.size20),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: isDark ? null : Colors.white,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  right: Sizes.size14,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.faceSmile,
                                      color: isDark
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade900,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            autocorrect: false,
                            keyboardType: TextInputType.multiline,
                            expands: true,
                            minLines: null,
                            maxLines: null,
                            textInputAction: TextInputAction.newline,
                            cursorColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Gaps.h16,
                      _isWriting || _inputText.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.all(Sizes.size10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _inputText.isNotEmpty
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade400,
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.paperPlane,
                                color: Colors.white,
                                size: Sizes.size20,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
