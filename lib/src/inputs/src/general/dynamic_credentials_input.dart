part of inputs;

typedef CredentialOnChanged = void Function(Map<String, dynamic>);

class ThemedDynamicCredentialsInput extends StatefulWidget {
  final Map<String, dynamic> value;
  final List<CredentialField> fields;
  final CredentialOnChanged? onChanged;
  final Map<String, dynamic> errors;
  final String translatePrefix;
  final bool isEditing;
  final String? layrzGeneratedToken;
  final String? nested;
  final void Function(CredentialFieldAction)? actionCallback;
  final bool isLoading;

  /// [ThemedDynamicCredentialsInput] is a dynamic credentials input.
  /// Layrz uses this input to generate the dynamic credentials form some models.
  /// In Layrz API represents the field `credentials` of the entities, like `InboundProtocol` or `OutboundProtocol`.
  /// To get more information about that, please read the documentation of the Layrz API and/or the field [fields]
  /// of this class.
  const ThemedDynamicCredentialsInput({
    super.key,

    /// [value] is the value of the credentials.
    required this.value,

    /// [fields] is the list of fields of the credentials.
    required this.fields,

    /// [onChanged] is the callback function when the credentials are changed.
    this.onChanged,

    /// [errors] is the list of errors of the credentials.
    this.errors = const {},

    /// [translatePrefix] is the prefix of the translations of the credentials.
    this.translatePrefix = '',

    /// [isEditing] is the state of the credentials being edited.
    this.isEditing = true,

    /// [layrzGeneratedToken] is the token generated by Layrz API.
    this.layrzGeneratedToken,

    /// [nested] is the nested field of the credentials.
    this.nested,

    /// [actionCallback] is the callback function when the credentials are changed.
    this.actionCallback,

    /// [isLoading] is the state of the credentials being loaded.
    this.isLoading = false,
  });

  @override
  State<ThemedDynamicCredentialsInput> createState() => _ThemedDynamicCredentialsInputState();
}

class _ThemedDynamicCredentialsInputState extends State<ThemedDynamicCredentialsInput> {
  late Map<String, dynamic> credentials;
  List<CredentialField> get fields => widget.fields;
  bool get isEditing => widget.isEditing;
  bool get isLoading => widget.isLoading;
  String get translatePrefix => widget.translatePrefix;

  @override
  void initState() {
    super.initState();
    credentials = widget.value;
  }

  @override
  void didUpdateWidget(ThemedDynamicCredentialsInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      credentials = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveRow(
      children: fields.map((field) {
        Sizes sm = Sizes.col12;

        Widget? content;

        if (showField(field)) {
          switch (field.type) {
            case CredentialFieldType.string:
            case CredentialFieldType.soapUrl:
            case CredentialFieldType.restUrl:
            case CredentialFieldType.ftp:
            case CredentialFieldType.dir:
              content = ThemedTextInput(
                disabled: !isEditing,
                labelText: t('$translatePrefix.${field.field}.title'),
                value: credentials[field.field] ?? '',
                errors: ThemedOrm.getErrors(
                    key: widget.nested != null
                        ? 'credentials.${widget.nested}.${field.field}'
                        : 'credentials.${field.field}'),
                onChanged: (value) {
                  credentials[field.field] = value;
                  setState(() {});
                  widget.onChanged?.call(credentials);
                },
              );
              break;
            case CredentialFieldType.integer:
            case CredentialFieldType.float:
              content = ThemedNumberInput(
                disabled: !isEditing,
                labelText: t('$translatePrefix.${field.field}.title'),
                value: credentials[field.field],
                errors: ThemedOrm.getErrors(
                    key: widget.nested != null
                        ? 'credentials.${widget.nested}.${field.field}'
                        : 'credentials.${field.field}'),
                onChanged: (value) {
                  if (value == null) {
                    credentials[field.field] = null;
                    return;
                  } else if (field.type == CredentialFieldType.integer) {
                    credentials[field.field] = value.toInt();
                  } else if (field.type == CredentialFieldType.float) {
                    credentials[field.field] = value.toDouble();
                  } else {
                    credentials[field.field] = value;
                  }
                  setState(() {});
                  widget.onChanged?.call(credentials);
                },
              );
              break;
            case CredentialFieldType.choices:
              content = ThemedSelectInput<String>(
                items: field.choices!
                    .map(
                      (choice) => ThemedSelectItem<String>(
                        value: choice,
                        label: t('$translatePrefix.${field.field}.$choice'),
                      ),
                    )
                    .toList(),
                disabled: !isEditing,
                labelText: t('$translatePrefix.${field.field}.title'),
                value: credentials[field.field],
                errors: ThemedOrm.getErrors(
                    key: widget.nested != null
                        ? 'credentials.${widget.nested}.${field.field}'
                        : 'credentials.${field.field}'),
                onChanged: (value) {
                  credentials[field.field] = value?.value;
                  setState(() {});
                  widget.onChanged?.call(credentials);
                },
              );
              break;
            case CredentialFieldType.layrzApiToken:
              content = ThemedTextInput(
                readonly: true,
                labelText: widget.nested != null
                    ? t('$translatePrefix.${widget.nested}.${field.field}.title')
                    : t('$translatePrefix.${field.field}.title'),
                value: widget.layrzGeneratedToken ?? t('builder.authorization.tokenNew'),
                suffixIcon: widget.layrzGeneratedToken != null ? MdiIcons.clipboardOutline : null,
                onSuffixTap: widget.layrzGeneratedToken != null
                    ? () {
                        Clipboard.setData(ClipboardData(text: widget.layrzGeneratedToken!));
                        ThemedSnackbarMessenger.maybeOf(context)?.showSnackbar(ThemedSnackbar(
                          message: t('builder.authorization.tokenCopied'),
                          icon: MdiIcons.clipboardCheckOutline,
                        ));
                      }
                    : null,
                errors: ThemedOrm.getErrors(
                    key: widget.nested != null
                        ? 'credentials.${widget.nested}.${field.field}'
                        : 'credentials.${field.field}'),
              );
              break;
            case CredentialFieldType.nestedField:
              content = ThemedDynamicCredentialsInput(
                value: credentials[field.field] ?? {},
                fields: field.requiredFields ?? [],
                onChanged: (value) {
                  credentials[field.field] = value;
                  setState(() {});
                  widget.onChanged?.call(credentials);
                },
                errors: widget.errors,
                nested: field.field,
                translatePrefix: '$translatePrefix.${field.field}',
                isEditing: isEditing,
              );
              break;
            case CredentialFieldType.wialonToken:
              content = ThemedTextInput(
                labelText: t('$translatePrefix.${field.field}.title'),
                readonly: true,
                value: credentials[field.field],
                errors: ThemedOrm.getErrors(
                    key: widget.nested != null
                        ? 'credentials.${widget.nested}.${field.field}'
                        : 'credentials.${field.field}'),
                suffixIcon: isLoading ? MdiIcons.lockOutline : MdiIcons.autorenew,
                onSuffixTap: () => widget.actionCallback?.call(CredentialFieldAction.wialonOAuth),
              );
              break;
            default:
              content = Center(child: Text(t('dynamic.credentials.unknown')));
              break;
          }
        }

        return ResponsiveCol(
          xs: Sizes.col12,
          sm: sm,
          child: content != null
              ? field.type == CredentialFieldType.nestedField
                  ? content
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: content,
                    )
              : const SizedBox(),
        );
      }).toList(),
    );
  }

  String t(String key) {
    return LayrzAppLocalizations.of(context)?.t(key) ?? 'Tranlation missing: $key';
  }

  bool showField(CredentialField field) {
    if (field.onlyChoices != null) {
      return field.onlyChoices!.contains(credentials[field.onlyField!]);
    }

    return true;
  }
}
