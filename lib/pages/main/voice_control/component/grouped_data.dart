import 'package:admin/pages/main/voice_control/model/chat_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

class GroupedData extends StatelessWidget {
  const GroupedData({super.key, required this.items});
  final BuiltList<ListingViewModel> items;

  @override
  Widget build(BuildContext context) {
    final Map<String?, List<ListingViewModel>> groupedItems = {};
    for (final item in items) {
      groupedItems[item.roomName] = groupedItems[item.roomName] ?? [];
      groupedItems[item.roomName]?.add(item);
    }

    final List<MapEntry<String?, List<ListingViewModel>>> groupedList =
        groupedItems.entries.toList();
    return ListView.separated(
      itemCount: groupedList.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final group = groupedList[index];
        final roomName = group.key ?? "Unknown Room";
        final roomItems = group.value;
        int i = 1;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              roomName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...roomItems.map((item) {
              return Text("${i++}. ${item.name}");
            }),
          ],
        );
      },
    );
  }
}
