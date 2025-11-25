import 'package:built_collection/built_collection.dart';

class ListingViewModel {
  ListingViewModel({
    required this.name,
    this.imageIcon,
    this.entityId,
    this.roomName,
    this.roomId,
    this.showNumbers = true,
  });
  String name;
  String? imageIcon;
  String? entityId;
  String? roomName;
  String? roomId;
  bool? showNumbers;
}

class ChatModel {
  ChatModel({this.id, this.text, this.senderImage, this.listingViewModel});
  String? text;
  int? id;
  String? senderImage;
  BuiltList<ListingViewModel>? listingViewModel;
}
