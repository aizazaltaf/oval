/// Mock implementation of CustomOverlayLoader for testing
mixin MockCustomOverlayLoader {
  static bool _isShowing = false;

  static void show() {
    _isShowing = true;
    // Do nothing in tests
  }

  static void dismiss() {
    _isShowing = false;
    // Do nothing in tests
  }

  static bool get isShowing => _isShowing;
}

/// Override the CustomOverlayLoader for testing
void setupMockCustomOverlayLoader() {
  // This would need to be implemented by modifying the CustomOverlayLoader class
  // or by using dependency injection, but for now we'll handle it in the test setup
}
