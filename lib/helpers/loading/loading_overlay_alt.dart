import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

class LoadingOverlayAlt extends StatelessWidget {
  LoadingOverlayAlt({
    Key? key,
    required this.child,
    this.delay = const Duration(milliseconds: 500),
  })  : _isLoadingNotifier = ValueNotifier(false),
        super(key: key);

  final ValueNotifier<bool> _isLoadingNotifier;

  final Widget child;
  final Duration delay;

  static LoadingOverlayAlt of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<LoadingOverlayAlt>()!;
  }

  void show() {
    _isLoadingNotifier.value = true;
  }

  void hide() {
    _isLoadingNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoadingNotifier,
      child: child,
      builder: (context, value, child) {
        return Stack(
          children: [
            child!,
            if (value)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                child: const Opacity(
                  opacity: 0.2,
                  child: ModalBarrier(dismissible: false, color: Colors.black),
                ),
              ),
            if (value)
              Center(
                child: FutureBuilder(
                  future: Future.delayed(delay),
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
      },
    );
  }
}
