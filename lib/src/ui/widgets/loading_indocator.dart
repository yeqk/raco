import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  /*
  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(),
  );
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}