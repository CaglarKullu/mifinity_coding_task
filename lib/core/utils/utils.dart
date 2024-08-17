import 'package:flutter/material.dart';

void showFeatureUnavailableDialog(BuildContext context, String featureName) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('$featureName Unavailable'),
        content: const Text(
            'This feature will be available in a future update. Stay tuned!'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
