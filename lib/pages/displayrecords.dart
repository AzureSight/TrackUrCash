import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class displayrecords extends StatelessWidget {
  const displayrecords({
    super.key,
    required this.data,
    required this.onSelect,
  });
  final dynamic data;
  final Function() onSelect;
  @override
  Widget build(BuildContext context) {
    // DateTime date = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
    DateTime date = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
    // .add(Duration(hours: 8));

    String formattedDate = DateFormat('d MMM hh:mma').format(date);
    return GestureDetector(
      onTap: onSelect, // Trigger of function on tap

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 10),
                    color: Colors.grey.withOpacity(0.19),
                    blurRadius: 10.0,
                    spreadRadius: 4.0)
              ]),
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    "${data['detail']}",
                    style: TextStyle(color: Colors.green),
                  ),
                )
              ],
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("Amount",
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const Spacer(),
                    Text("₱${data['amount']}",
                        style: TextStyle(color: Colors.grey, fontSize: 13))
                  ],
                ),
                Text(
                  formattedDate,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
