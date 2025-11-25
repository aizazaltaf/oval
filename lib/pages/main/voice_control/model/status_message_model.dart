import 'dart:math';

class StatusMessage {
  const StatusMessage({
    required this.message,
    required this.category,
  });
  final String message;
  final StatusCategory category;
}

enum StatusCategory {
  initial,
  midway,
  nearCompletion,
  fallback,
}

mixin StatusMessageManager {
  static final List<StatusMessage> _initialMessages = [
    const StatusMessage(
      message: "processing...",
      category: StatusCategory.initial,
    ),
    const StatusMessage(
      message: "processing...",
      category: StatusCategory.initial,
    ),
    const StatusMessage(
      message: "processing...",
      category: StatusCategory.initial,
    ),
  ];

  static final List<StatusMessage> _midwayMessages = [
    const StatusMessage(
      message: "processing...",
      category: StatusCategory.midway,
    ),
    const StatusMessage(
      message: "processing...",
      category: StatusCategory.midway,
    ),
    const StatusMessage(
      message: "processing...",
      category: StatusCategory.midway,
    ),
  ];

  static final List<StatusMessage> _nearCompletionMessages = [
    const StatusMessage(
      message: "processing...",
      category: StatusCategory.nearCompletion,
    ),
    const StatusMessage(
      message: "processing...",
      category: StatusCategory.nearCompletion,
    ),
    const StatusMessage(
      message: "processing...",
      category: StatusCategory.nearCompletion,
    ),
  ];

  static final List<StatusMessage> _fallbackMessages = [
    const StatusMessage(
      message: "processing...",
      category: StatusCategory.fallback,
    ),
    const StatusMessage(
      message: "processing...",
      category: StatusCategory.fallback,
    ),
    const StatusMessage(
      message: "processing...",
      category: StatusCategory.fallback,
    ),
  ];

  static String getRandomMessage(StatusCategory category) {
    final random = Random();
    List<StatusMessage> messages;

    switch (category) {
      case StatusCategory.initial:
        messages = _initialMessages;
      case StatusCategory.midway:
        messages = _midwayMessages;
      case StatusCategory.nearCompletion:
        messages = _nearCompletionMessages;
      case StatusCategory.fallback:
        messages = _fallbackMessages;
    }

    return messages[random.nextInt(messages.length)].message;
  }
}
