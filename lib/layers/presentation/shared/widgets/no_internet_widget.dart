import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({Key? key, this.onPressed}) : super(key: key);
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No internet",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer),
              child: Text(
                "Retry",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ))
        ],
      ),
    );
  }
}
