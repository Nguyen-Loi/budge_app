import 'dart:io';

import 'package:budget_app/constants/assets_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum _ImageType { network, asset, file }

class BAvatar extends StatelessWidget {
  const BAvatar.network(
    this.url, {
    super.key,
    this.size,
  })  : _imageType = _ImageType.network,
        file = null;

  const BAvatar.asset(String asset, {super.key, this.size})
      : _imageType = _ImageType.asset,
        url = asset,
        file = null;

  const BAvatar.file(
    this.file, {
    super.key,
    this.size,
  })  : _imageType = _ImageType.file,
        url = null;

  final String? url;
  final File? file;
  final double? size;
  final _ImageType _imageType;

  @override
  Widget build(BuildContext context) {
    switch (_imageType) {
      case _ImageType.asset:
        return _asset();
      case _ImageType.network:
        return _network();
      case _ImageType.file:
        return _file();
    }
  }

  Widget _asset() {
    return CircleAvatar(
      radius: size,
      child: Image.asset(url!),
    );
  }

  Widget _file() {
    return CircleAvatar(
      radius: size,
      child: Image.file(file!),
    );
  }

  Widget _network() {
    return CachedNetworkImage(
      imageUrl: url!,
      placeholder: (context, url) => CircleAvatar(
        radius: size,
        child: Lottie.asset(LottieAssets.loadingImage),
      ),
      imageBuilder: (context, image) => CircleAvatar(
        backgroundImage: image,
        radius: size,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
