import 'package:budget_app/core/icon_manager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum _BLottieType { network, asset }

class BLottie extends StatefulWidget {
  const BLottie(
    this.data, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.animate = true,
    this.loadingWidget,
    this.errorWidget,
    this.onLoaded,
    this.repeat = true,
  }) : _type = _BLottieType.asset;

  const BLottie.network(
    String url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.animate = true,
    this.loadingWidget,
    this.errorWidget,
    this.onLoaded,
    this.repeat = true,
  })  : data = url,
        _type = _BLottieType.network;

  final String data;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool animate;
  final bool repeat;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final VoidCallback? onLoaded;
  final _BLottieType _type;

  @override
  State<BLottie> createState() => _BLottieState();
}

class _BLottieState extends State<BLottie> {
  @override
  Widget build(BuildContext context) {
    switch (widget._type) {
      case _BLottieType.asset:
        return _buildAssetLottie();
      case _BLottieType.network:
        return _buildNetworkLottie();
    }
  }

  Widget _buildAssetLottie() {
    return Lottie.asset(
      widget.data,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      animate: widget.animate,
      repeat: widget.repeat,
    );
  }

  Widget _buildNetworkLottie() {
    return Lottie.network(
      widget.data,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      animate: widget.animate,
      repeat: widget.repeat,
      onLoaded: (_) => widget.onLoaded?.call(),
      frameBuilder: (context, child, composition) {
        if (composition != null) {
          return child;
        }
        return _buildLoadingWidget();
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget();
      },
    );
  }

  /// Builds the loading widget
  Widget _buildLoadingWidget() {
    if (widget.loadingWidget != null) {
      return widget.loadingWidget!;
    }

    return SizedBox(
      width: widget.width ?? 80,
      height: widget.height ?? 80,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Builds the error widget
  Widget _buildErrorWidget() {
    if (widget.errorWidget != null) {
      return widget.errorWidget!;
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: Icon(
          IconManager.errorLoadLottie,
          size: 48,
        ),
      ),
    );
  }
}
