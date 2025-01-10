import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  final String loadingText;
  final Function callback;

  const LoadingPage({
    super.key,
    required this.loadingText,
    required this.callback,
  });

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      widget.callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
            semanticsLabel: widget.loadingText,
          ),
        )
      ],
    ));
  }
}
