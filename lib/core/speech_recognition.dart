class SpeechRecognition {
  factory SpeechRecognition() {
    return instance;
  }

  SpeechRecognition._internal() {
    // initSpeechState();
  }
  static final SpeechRecognition instance = SpeechRecognition._internal();

  bool isDetected = false;
  String lastWords = '';
  String errorMessage = "";

  List<String> speakList = ["Listening", "Ah-huh?", "Yes?"];

  // Future<void> initSpeechState(BuildContext context) async {
  //   if (_porcupineManager != null) {
  //     await _porcupineManager?.delete();
  //     _porcupineManager = null;
  //   }
  //   if (Platform.isAndroid) {
  //     unawaited(Helper.setSpeakerphoneOn(true));
  //   } else {
  //     unawaited(SpeakerphoneController.setSpeakerphoneOn(true));
  //   }
  //   final apiKey = await apiService.getKeyForPorcupine();
  //   try {
  //     final platform = (Platform.isAndroid) ? "android" : "ios";
  //     final keywordPath = "assets/hey_oval_$platform.ppn";
  //     _porcupineManager = await PorcupineManager.fromKeywordPaths(
  //       apiKey['data']["value"],
  //       // "xVRf8hwfTVJRme4oIUKsxiFjF/v74+mj5ozEuU51RJhGwpWyAbZjXQ==",
  //       [keywordPath],
  //       (keywordIndex) async {
  //         if (keywordIndex >= 0 && !isDetected) {
  //           logger.fine("maaaaaamu kaaaa");
  //           if (!isDetected) {
  //             final random = Random();
  //             final int randomNumber = random.nextInt(3);
  //
  //             unawaited(
  //               singletonBloc.textToSpeech.speak(
  //                 speakList[randomNumber],
  //                 // "Hmmmm?"
  //               ),
  //             );
  //           }
  //           isDetected = true;
  //           bloc.updateIsListening(true);
  //
  //           await bloc.initAudioManager(context);
  //           await Future.delayed(const Duration(milliseconds: 500));
  //           bloc.record(context.mounted ? context : context);
  //         }
  //       },
  //       errorCallback: errorCallback,
  //     );
  //     await _porcupineManager?.start();
  //   } on PorcupineActivationException {
  //     errorCallback(
  //       PorcupineActivationException("AccessKey activation error."),
  //     );
  //   } on PorcupineActivationLimitException {
  //     errorCallback(
  //       PorcupineActivationLimitException(
  //         "AccessKey reached its device limit.",
  //       ),
  //     );
  //   } on PorcupineActivationRefusedException {
  //     errorCallback(PorcupineActivationRefusedException("AccessKey refused."));
  //   } on PorcupineActivationThrottledException {
  //     errorCallback(
  //       PorcupineActivationThrottledException(
  //         "AccessKey has been throttled.",
  //       ),
  //     );
  //   } on PorcupineException catch (ex) {
  //     errorCallback(ex);
  //   } finally {}
  // }
}
