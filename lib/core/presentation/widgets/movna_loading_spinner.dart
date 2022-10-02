import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MovnaLoadingSpinner extends StatelessWidget {
  const MovnaLoadingSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO : rotating movna logo
    return Center(
      child: SpinKitFadingCube(
        color: Theme.of(context).colorScheme.secondary,
        size: 50.0,
      ),
    );
  }
}
