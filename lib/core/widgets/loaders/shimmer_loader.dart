import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  final double height;
  final double? width;
  final BorderRadius borderRadius;
  final EdgeInsets margin;

  const ShimmerLoader({
    Key? key,
    this.height = 16,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.margin = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

class ShimmerCardLoader extends StatelessWidget {
  const ShimmerCardLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 16,
              width: 150,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Container(
              height: 12,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              height: 12,
              width: 200,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
