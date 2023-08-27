part of inputs;

class ThemedAvatarInput extends StatelessWidget {
  final String? labelText;
  final Widget? label;
  final String? value;
  final void Function(String?)? onChanged;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;

  @Deprecated("Use `ThemedAvatarPicker` instead")
  const ThemedAvatarInput({
    super.key,
    this.label,
    this.value,
    this.labelText,
    this.onChanged,
    this.disabled = false,
    this.errors = const [],
    this.hideDetails = false,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  Widget build(BuildContext context) {
    return ThemedAvatarPicker(
      label: label,
      value: value,
      labelText: labelText,
      onChanged: onChanged,
      disabled: disabled,
      errors: errors,
      hideDetails: hideDetails,
    );
  }
}

class ThemedAvatarPicker extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final String? value;
  final void Function(String?)? onChanged;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final Widget? customChild;

  /// [ThemedAvatarPicker] is a widget that allows the user to pick an avatar.
  const ThemedAvatarPicker({
    super.key,

    /// [labelText] is the label text of the input. Avoid submit [label] and [labelText] at the same time.
    this.labelText,

    /// [label] is the label widget of the input. Avoid submit [label] and [labelText] at the same time.
    this.label,

    /// [value] is the current value of the input. This value should be a base64 string or an URL.
    this.value,

    /// [onChanged] is the callback that is called when the value of the input changes.
    this.onChanged,

    /// [disabled] is a flag that indicates if the input is disabled.
    this.disabled = false,

    /// [errors] is a list of errors that will be displayed below the input.
    this.errors = const [],

    /// [hideDetails] is a flag that indicates if the errors should be displayed.
    this.hideDetails = false,

    /// [customChild] is a custom child that will be displayed instead of the default input.
    /// If this property is submitted, the input will be ignored.
    this.customChild,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedAvatarPicker> createState() => _ThemedAvatarPickerState();
}

class _ThemedAvatarPickerState extends State<ThemedAvatarPicker> with SingleTickerProviderStateMixin {
  late String? _value;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _value = widget.value ?? "";

    if (_value?.isNotEmpty ?? false) {
      _controller.animateTo(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customChild != null) {
      return InkWell(
        onTap: widget.disabled ? null : _showPicker,
        child: widget.customChild!,
      );
    }

    Color cardColor = widget.disabled ? Colors.grey.shade300 : Theme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.label ?? Text(widget.labelText ?? ""),
          AnimatedContainer(
            width: 100,
            height: 100,
            duration: const Duration(milliseconds: 300),
            decoration: generateContainerElevation(
              context: context,
              color: cardColor,
              elevation: 3,
              radius: 20,
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.disabled ? null : _showPicker,
                child: Stack(
                  children: [
                    Center(
                      child: _value?.isNotEmpty ?? false
                          ? ThemedImage(
                              path: _value!,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            )
                          : Icon(
                              widget.disabled ? MdiIcons.lockOutline : MdiIcons.cloudUpload,
                              size: 50,
                              color: validateColor(color: cardColor),
                            ),
                    ),
                    widget.disabled
                        ? const SizedBox()
                        : Positioned(
                            right: 0,
                            top: 0,
                            child: FadeTransition(
                              opacity: CurvedAnimation(
                                parent: _controller,
                                curve: Curves.easeInOut,
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                child: ClipOval(
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    color: Colors.red.shade800,
                                    child: Icon(MdiIcons.close,
                                        size: 15, color: validateColor(color: Colors.red.shade800)),
                                  ),
                                ),
                                onTap: () {
                                  setState(() => _value = null);
                                  widget.onChanged?.call(null);
                                  _controller.animateTo(0);
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          ThemedFieldDisplayError(errors: widget.errors, hideDetails: widget.hideDetails),
        ],
      ),
    );
  }

  void _showPicker() async {
    final files = await pickFile(
      allowMultiple: false,
      type: FileType.image,
    );
    if (files != null) {
      ThemedFile file = files.first;
      Map<String, String>? b64 = await compute(parseFileToBase64, file);

      if (b64 != null) {
        String image = "data:${b64['mimeType']};base64,${b64['base64']}";
        setState(() => _value = image);
        widget.onChanged?.call(image);

        _controller.animateTo(1);
      }
    }
  }
}
