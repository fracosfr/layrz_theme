part of layrz_theme;

final getIt = GetIt.instance;

/// [showThemedSnackbar] is the helper function to display a [ThemedSnackbar].
void showThemedSnackbar(ThemedSnackbar item) {
  bool isRegistered = getIt.isRegistered<ThemedSnackbarController>(
    instanceName: "ThemedSnackbarController",
  );

  if (!isRegistered) {
    getIt.registerSingleton<ThemedSnackbarController>(
      ThemedSnackbarController(),
      instanceName: "ThemedSnackbarController",
    );
  }

  ThemedSnackbarController controller = getIt.get<ThemedSnackbarController>(
    instanceName: "ThemedSnackbarController",
  );

  controller.add(item);
}
