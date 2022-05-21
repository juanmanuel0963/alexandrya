import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

class LoadingOverlay extends StatefulWidget {
  const LoadingOverlay({
    Key? key,
    required this.child,
    this.delay = const Duration(milliseconds: 500),
  }) : super(key: key);

  final Widget child;
  final Duration delay;

  static _LoadingOverlayState of(BuildContext context) {
    return context.findAncestorStateOfType<_LoadingOverlayState>()!;
  }

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  bool _isLoading = false;

  void show() {
    setState(() {
      _isLoading = true;
    });
  }

  void hide() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isLoading)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
            child: const Opacity(
              opacity: 0.2,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          ),
        if (_isLoading)
          Center(
            child: FutureBuilder(
              future: Future.delayed(widget.delay),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.done
                    ? Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                            Text(
                              'loading'.tr,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox();
              },
            ),
          ),
      ],
    );
  }
}
