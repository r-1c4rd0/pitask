import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SubscriptionsListLoaderWidget extends StatelessWidget {
  final int count;
  final double itemHeight;

  const SubscriptionsListLoaderWidget({Key? key, required this.count, required this.itemHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: count ?? 1,
        itemBuilder: (_, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.1),
            highlightColor: Colors.grey[200]!.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: itemHeight ?? 190,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
