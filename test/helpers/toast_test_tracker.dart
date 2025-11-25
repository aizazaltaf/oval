// Test helper for tracking toast calls
mixin ToastTestTracker {
  static String? lastToastTitle;
  static String? lastToastDescription;
  static String? lastToastType;
  static int toastCallCount = 0;

  static void reset() {
    lastToastTitle = null;
    lastToastDescription = null;
    lastToastType = null;
    toastCallCount = 0;
  }

  static void trackToast(String type, String? title, String description) {
    lastToastType = type;
    lastToastTitle = title;
    lastToastDescription = description;
    toastCallCount++;
  }
}
