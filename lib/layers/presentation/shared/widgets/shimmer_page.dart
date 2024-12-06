import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPage extends StatelessWidget {
  const ShimmerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
              ),
              Container(
                width: 200,
                height: 30,
                color: Colors.black,
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      child: SizedBox(
                        width: 160,
                        height: 170,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

