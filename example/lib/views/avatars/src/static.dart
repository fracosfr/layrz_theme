part of avatars;

class StaticAvatarsView extends StatefulWidget {
  const StaticAvatarsView({super.key});

  @override
  State<StaticAvatarsView> createState() => _StaticAvatarsViewState();
}

class _StaticAvatarsViewState extends State<StaticAvatarsView> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "What is a static avatar?",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "It's simple, avatars using static images or icons are static avatars (In the Layrz philosophy).",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              "How to use it?",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "To generate an avatar, you will use an utility function drawAvatar, here is an example:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const ThemedCodeSnippet(
              code: "drawAvatar(context: context, size: 30)",
            ),
            const SizedBox(height: 10),
            Text(
              "Result:",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            drawAvatar(
              context: context,
              size: 30,
            ),
            const SizedBox(height: 10),
            Text(
              "You can also change the color of the avatar using the argument color:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const ThemedCodeSnippet(
              code: "drawAvatar(context: context, size: 30, color: Colors.red)",
            ),
            const SizedBox(height: 10),
            Text(
              "Result:",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            drawAvatar(
              context: context,
              size: 30,
              color: Colors.red,
            ),
            const SizedBox(height: 10),
            Text(
              "Look this other examples:",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "Our functions offers inline documentation, so you can see all the arguments and their types.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 10),
              children: [
                ListTile(
                  leading: drawAvatar(
                    context: context,
                    size: 50,
                    avatar: 'https://cdn.layrz.com/resources/layo/layo2.png',
                  ),
                  title: const Text("Using an image"),
                  trailing: ThemedButton(
                    icon: MdiIcons.contentCopy,
                    labelText: "Get the code",
                    onTap: () {
                      Clipboard.setData(const ClipboardData(
                        text: "drawAvatar(context: context, size: 50, avatar: "
                            "'https://cdn.layrz.com/resources/layo/layo2.png')",
                      ));
                      showThemedSnackbar(ThemedSnackbar(
                        context: context,
                        message: "Copied to clipboard",
                        icon: MdiIcons.clipboardCheckOutline,
                        color: Colors.green,
                      ));
                    },
                  ),
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                ListTile(
                  leading: drawAvatar(
                    context: context,
                    size: 50,
                    icon: MdiIcons.account,
                    color: Colors.green,
                  ),
                  title: const Text("Using an icon w/ a color"),
                  trailing: ThemedButton(
                    icon: MdiIcons.contentCopy,
                    labelText: "Get the code",
                    onTap: () {
                      Clipboard.setData(const ClipboardData(
                        text: "drawAvatar(context: context, size: 50, icon: MdiIcons.account, color: Colors.green)",
                      ));
                      showThemedSnackbar(ThemedSnackbar(
                        context: context,
                        message: "Copied to clipboard",
                        icon: MdiIcons.clipboardCheckOutline,
                        color: Colors.green,
                      ));
                    },
                  ),
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                ListTile(
                  leading: drawAvatar(
                    context: context,
                    size: 50,
                    avatar: 'https://cdn.layrz.com/resources/layo/layo2.png',
                    radius: 10,
                    elevation: 3,
                  ),
                  title: const Text("Changing the border radius and elevation"),
                  trailing: ThemedButton(
                    icon: MdiIcons.contentCopy,
                    labelText: "Get the code",
                    onTap: () {
                      Clipboard.setData(const ClipboardData(
                        text: "drawAvatar(context: context, size: 50, avatar: "
                            "'https://cdn.layrz.com/resources/layo/layo2.png', radius: 10, elevation: 3)",
                      ));
                      showThemedSnackbar(ThemedSnackbar(
                        context: context,
                        message: "Copied to clipboard",
                        icon: MdiIcons.clipboardCheckOutline,
                        color: Colors.green,
                      ));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
