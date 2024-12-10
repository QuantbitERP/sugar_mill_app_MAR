import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sugar_mill_app/constants.dart';

Widget fullScreenLoader({
  required bool loader,
  required Widget child,
  required BuildContext context,
}) {
  return Stack(
    children: [
      child,
      if (loader)
        Container(
          height: getHeight(context),
          width: getWidth(context),
          color: Colors.black.withOpacity(0.5), // Dimmed background
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Text(
                      'Please Wait...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    ],
  );
}



Widget shimmerListView({
  required bool loader,
  required Widget child,
  required BuildContext context,
}) {
  return Stack(
    children: [
      child,
      if (loader)

        Container(
          color: Colors.white,
          child: ListView.separated(
            itemCount: 10, // Adjust as needed
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20),
                    //   gradient: const LinearGradient(
                    //     colors: [Colors.white54, Colors.white],
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomRight,
                    //   ),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.grey.withOpacity(0.3),
                    //       blurRadius: 8.0,
                    //       spreadRadius: 3.0,
                    //       offset: const Offset(2, 4),
                    //     ),
                    //   ],
                    //   border: Border.all(color: Colors.blueAccent, width: 0.5),
                    // ),
                    child: MaterialButton(
                      onPressed: () {},
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row (Slip No and Farmer Name)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 100,
                                height: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 40),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 16,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          // Bottom Row (Village and Circle)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 100,
                                    height: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 100,
                                    height: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          // Workflow State Card
                          Container(
                            width: double.infinity,
                            height: 30,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
    ],
  );
}


Widget shimmerForm({
  required bool loader,
  required Widget child,
  required BuildContext context,
}) {
  return Stack(
    children: [
      child, // The actual form content
      if (loader)
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Simulate a header or title
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Simulate an input field
                  Container(
                    width: double.infinity,
                    height: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  // Simulate another input field
                  Container(
                    width: double.infinity,
                    height: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  // Simulate a drop-down or selection field
                  Container(
                    width: double.infinity,
                    height: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  // Simulate a multi-row section
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Simulate a button
                  Container(
                    width: double.infinity,
                    height: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  // Simulate another button
                  Container(
                    width: double.infinity,
                    height: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  // Simulate a multi-row section
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Simulate a multi-row section
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Simulate a multi-row section
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Simulate a multi-row section
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Simulate a button

                  Container(
                    width: double.infinity,
                    height: 48,
                    color: Colors.grey,
                  ),
                  // Simulate a multi-row section
                ],
              ),
            ),
          ),
        ),
    ],
  );
}
