import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/service/streamChat/stream_client_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamChatBuilder extends StatelessWidget {
  final Widget? child;
  const StreamChatBuilder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: StreamClientService.instance.clientStream!,
      streamChatThemeData: StreamChatThemeData(
          colorTheme: StreamColorTheme.light(),
          channelHeaderTheme: StreamChannelHeaderThemeData(
            titleStyle: $styles.text.bodyBold.copyWith(color: Colors.white),
            subtitleStyle: $styles.text.bodySmall
                .copyWith(color: $styles.colors.lightGrey.withOpacity(0.7)),
          )),
      child: child,
    );
  }
}
