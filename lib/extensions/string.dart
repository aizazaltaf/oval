import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';

extension XString on String {
  String? toNullIfEmpty() {
    if (isEmpty) {
      return null;
    }
    return this;
  }

  String capitalizeFirstOfEach() {
    return split(' ').map((word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1)}';
      }
      return '';
    }).join(' ');
  }

  String getIcon() {
    switch (this) {
      case Constants.thermostat:
        return DefaultVectors.THERMOSTAT_ICON;

      case Constants.thermostate:
        return DefaultVectors.THERMOSTAT_ICON;

      case Constants.bulb:
        return DefaultVectors.IOT_BULB;

      case Constants.camera:
        return DefaultVectors.CAMERA;

      case Constants.hub:
        return DefaultVectors.CURTAIN_FIFTY;

      case Constants.smartLock:
        return DefaultVectors.DOORBELL_LOCK;

      default:
        return DefaultVectors.IOT_BULB;
    }
  }

  bool getExpansion() {
    final String notificationTitle = trim().toLowerCase();
    if (notificationTitle.contains(Constants.visitor) ||
            notificationTitle.contains(Constants.unwanted) ||
            (notificationTitle.contains(Constants.baby) &&
                notificationTitle.contains(Constants.run)) ||
            (notificationTitle.contains(Constants.pet) &&
                notificationTitle.contains(Constants.run)) ||
            notificationTitle.contains(Constants.fire) ||
            notificationTitle.contains(Constants.parcel) ||
            (notificationTitle.contains(Constants.dog) &&
                notificationTitle.contains(Constants.poop)) ||
            notificationTitle.contains(Constants.eavesdropper) ||
            notificationTitle.contains(Constants.intruder) ||
            notificationTitle.contains(Constants.weapon) ||
            notificationTitle.contains(Constants.humanFall) ||
            notificationTitle.contains(Constants.wildAnimal) ||
            notificationTitle.contains(Constants.drowning) ||
            notificationTitle.contains(Constants.boundaryBreach) ||
            (notificationTitle == Constants.onlyAlert) ||
            notificationTitle.contains(Constants.motion) ||
            notificationTitle.contains(Constants.monitoring)
        // || notificationTitle.contains(Constants.doorbellTheft)
        ) {
      return true;
    } else {
      return false;
    }
  }

  bool getCanCall() {
    final String notificationTitle = trim().toLowerCase();
    if (notificationTitle.contains(Constants.visitor) ||
        notificationTitle.contains(Constants.unwanted) ||
        notificationTitle.contains(Constants.parcel)) {
      return true;
    } else {
      return false;
    }
  }

  bool isBulb() {
    return split('.').first.toLowerCase().contains("light");
  }

  bool isTypeLight() {
    return toLowerCase().contains("bulb");
  }

  bool isTypeLock() {
    return toLowerCase().contains("lock");
  }

  bool isCamera() {
    return split('.').first.toLowerCase().contains("camera");
  }

  bool isThermostat() {
    return split('.').first.toLowerCase().contains("climate");
  }

  bool isSwitchBot() {
    return split('.').first.toLowerCase().contains("switchbot");
  }

  bool isRing() {
    return toLowerCase().contains("ring");
  }

  bool isAugust() {
    return toLowerCase().contains("august");
  }

  bool isEzviz() {
    return toLowerCase().contains("ezviz");
  }

  bool isSwitchBotCurtain() {
    return split('.').first.toLowerCase().contains("switchbot") &&
        toLowerCase().contains("curtain");
  }

  bool isSwitchBotBlind() {
    return split('.').first.toLowerCase().contains("switchbot") &&
        toLowerCase().contains("blind");
  }

  bool isHub() {
    return split('.').first.toLowerCase().contains("switchbot") &&
        toLowerCase().contains("hub");
  }

  bool isHubWithoutEntityId() {
    return toLowerCase().contains("hub");
  }

  bool isCurtainWithoutEntityId() {
    return toLowerCase().contains("curtain");
  }

  bool isBlindWithoutEntityId() {
    return toLowerCase().contains("blind");
  }

  bool isLock() {
    return split('.').first.toLowerCase().contains("lock");
  }

  bool isWyze() {
    return toLowerCase().contains("wyze");
  }

  bool isMultiCamerasDelete() {
    return contains("ezviz") || contains("ring");
  }
}
