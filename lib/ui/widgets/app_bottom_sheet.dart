import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

// class AppBottomSheet extends StatelessWidget {
//   final Widget child;
//   final bool isDismissible;
//   final bool enableDrag;
//   final double maxHeightFraction;
//   final double minHeightFraction;
//   final EdgeInsetsGeometry? padding;

//   const AppBottomSheet({
//     super.key,
//     required this.child,
//     this.isDismissible = true,
//     this.enableDrag = true,
//     this.maxHeightFraction = 0.9,
//     this.minHeightFraction = 0.3,
//     this.padding,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // final height = MediaQuery.of(context).size.height;

//     return DraggableScrollableSheet(
//       initialChildSize: minHeightFraction,
//       maxChildSize: maxHeightFraction,
//       minChildSize: minHeightFraction,
//       expand: false,
//       builder: (context, scrollController) {
//         return Container(
//           padding:
//               padding ??
//               const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             color: AppColors.whiteColor,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//           ),
//           child: child,
//         );
//       },
//     );
//   }
// }

class AppBottomSheet extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppBottomSheet({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SingleChildScrollView(child: child),
      ),
    );
  }
}
