import 'package:budget_app/constants/assets_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum _ImageType { network, asset }

class BAvatar extends StatelessWidget {
  const BAvatar.network(
    this.url, {
    super.key,
  })  : _imageType = _ImageType.network,
        size = null;

  const BAvatar.asset(String asset, {super.key, this.size})
      : _imageType = _ImageType.asset,
        url = asset
        ;

  final String url;
  final double? size;
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
    return CircleAvatar(
      radius: size,
      child: Image.asset(url),
    );
  }

  Widget _network() {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => CircleAvatar(
        radius: size,
        child: Image.asset(AssetsConstants.avatarDefault),
      ),
      imageBuilder: (context, image) => CircleAvatar(
        backgroundImage: image,
        radius: size,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
