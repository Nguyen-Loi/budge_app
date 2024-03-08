import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum _ImageType { normal, avatar }

class BImage extends StatelessWidget {
  const BImage(
    this.url, {
    super.key,
    this.width,
    this.height,
  })  : _imageType = _ImageType.normal,
        size = null;

  const BImage.avatar(this.url, {super.key, this.size})
      : _imageType = _ImageType.avatar,
        width = null,
        height = null;
  final String url;
  final double? width;
  final double? height;
  final double? size;
  final _ImageType _imageType;

  @override
  Widget build(BuildContext context) {
    switch (_imageType) {
      case _ImageType.normal:
        return _normal();
      case _ImageType.avatar:
        return _avatar();
    }
  }

  Widget _normal() {
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

  Widget _avatar() {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => CircleAvatar(
        radius: size,
      ),
      imageBuilder: (context, image) => CircleAvatar(
        backgroundImage: image,
        radius: size,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
