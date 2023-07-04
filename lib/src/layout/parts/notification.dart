part of layout;

class ThemedNotificationIcon extends StatefulWidget {
  final List<ThemedNotificationItem> notifications;
  final Color backgroundColor;

  const ThemedNotificationIcon({
    super.key,

    /// [notifications] is the list of notifications to be displayed in the
    /// notification icon.
    required this.notifications,

    /// [backgroundColor] is the background color of the notification icon.
    required this.backgroundColor,
  });

  @override
  State<ThemedNotificationIcon> createState() => _ThemedNotificationIconState();
}

class _ThemedNotificationIconState extends State<ThemedNotificationIcon> with SingleTickerProviderStateMixin {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get backgroundColor => widget.backgroundColor;
  List<ThemedNotificationItem> get notifications => widget.notifications;

  Color get notificationIconColor => isDark
      ? Colors.white.withOpacity(notifications.isEmpty ? 0.5 : 1)
      : Colors.black.withOpacity(notifications.isEmpty ? 0.5 : 1);

  IconData get notificationIcon => notifications.isNotEmpty ? MdiIcons.bellBadge : MdiIcons.bell;

  late AnimationController _controller;
  OverlayEntry? _overlay;
  final GlobalKey _key = GlobalKey();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: kHoverDuration);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _key,
      onTap: _buildOverlay,
      child: Icon(
        notificationIcon,
        color: notificationIconColor,
        size: 18,
      ),
    );
  }

  Future<void> _buildOverlay() async {
    if (_overlay != null) {
      await _destroyOverlay();
    }

    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    Size screenSize = MediaQuery.of(context).size;
    double bottom = 50;
    double right = screenSize.width - offset.dx - renderBox.size.width;

    double width = screenSize.width * 0.5;

    _overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(child: GestureDetector(onTap: _destroyOverlay)),
              Positioned(
                bottom: bottom,
                right: right,
                child: RawKeyboardListener(
                  focusNode: _focusNode,
                  onKey: (event) {
                    if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
                      _destroyOverlay();
                    }
                  },
                  child: ScaleTransition(
                    scale: _controller,
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: width - 50,
                      constraints: BoxConstraints(
                        maxHeight: screenSize.height * 0.4,
                        minHeight: 56,
                        maxWidth: 400,
                      ),
                      decoration: generateContainerElevation(context: context),
                      clipBehavior: Clip.antiAlias,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemExtent: 56,
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          ThemedNotificationItem item = notifications[index];

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: item.onTap != null
                                  ? () {
                                      _destroyOverlay(callback: item.onTap);
                                    }
                                  : null,
                              child: Container(
                                height: 56,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    drawAvatar(
                                      context: context,
                                      icon: item.icon ?? MdiIcons.bell,
                                      color: item.color ?? Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(item.content, style: Theme.of(context).textTheme.bodySmall),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_overlay!);
    await _controller.forward();
    _focusNode.requestFocus();
  }

  Future<void> _destroyOverlay({VoidCallback? callback}) async {
    _focusNode.unfocus();
    await _controller.reverse();
    _overlay?.remove();
    _overlay = null;

    callback?.call();
  }
}
