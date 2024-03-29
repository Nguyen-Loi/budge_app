import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum _ImageType { network, asset }

class BImage extends StatelessWidget {
  const BImage.network(
    this.url, {
    super.key,
    this.height,
  })  : _imageType = _ImageType.network,
        width = null;

  const BImage.asset(
    String asset, {
    super.key,
    this.width,
    this.height,
  })  : _imageType = _ImageType.asset,
        url = asset;

  final String url;
  final double? width;
  final double? height;
  final _ImageType _imageType;

  @override
  Widget build(BuildContext context) {
    switch (_imageType) {
      case _ImageType.asset:
        return _asset();
      case _ImageType.network:
        return _network();
    }
  }

  Widget _asset() {
    return Image.asset(url, width: width, height: height);
  }

  Widget _network() {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.contain,
          ),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
