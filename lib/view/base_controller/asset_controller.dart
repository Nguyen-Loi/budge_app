import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/enums/asset_type_enum.dart';
import 'package:budget_app/data/datasources/apis/asset_api.dart';
import 'package:budget_app/data/models/asset_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assetControllerProvider =
    NotifierProvider<AssetController, List<AssetModel>>(AssetController.new);

class AssetController extends Notifier<List<AssetModel>> {

  @override
  List<AssetModel> build() {
    return [];
  }

  Future<void> load(BuildContext context) async {
    try {
      final assets = await ref.read(assetApiProvider).fetch();
      if (kIsWeb) return;
      if (!context.mounted) {
        throw Exception('Context is not mounted: $runtimeType');
      }
      final List<Future<void>> cachingOperations = [];

      for (final asset in assets) {
        switch (asset.assetType) {
          case AssetTypeEnum.avatarImage:
            cachingOperations.add(
                precacheImage(CachedNetworkImageProvider(asset.url), context));
            break;
        }
      }

      await Future.wait(cachingOperations);

      state = assets;
    } catch (e) {
      logError('Error loading assets: $e');
      throw Exception('Failed to load assets: $e');
    }
  }

  List<AssetModel> getAssetsByType(AssetTypeEnum type) {
    return state.where((asset) => asset.assetType == type).toList();
  }

  String get defaultAvatar {
    final avatars = getAssetsByType(AssetTypeEnum.avatarImage);
    if (avatars.isEmpty) {
      return "";
    }
    return avatars.first.url;
  }
}
