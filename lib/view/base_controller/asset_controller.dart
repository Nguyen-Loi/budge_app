import 'dart:io';
import 'dart:convert';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/core/enums/asset_type_enum.dart';
import 'package:budget_app/data/datasources/apis/asset_api.dart';
import 'package:budget_app/data/models/asset_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';

final assetControllerProvider =
    StateNotifierProvider<AssetController, List<AssetModel>>((ref) {
  final assetApi = ref.watch(assetApiProvider);
  return AssetController(assetApi: assetApi);
});

class AssetController extends StateNotifier<List<AssetModel>> {
  AssetController({required AssetApi assetApi})
      : _assetApi = assetApi,
        super([]);

  final AssetApi _assetApi;

  Future<void> load(BuildContext context) async {
    try {
      final assets = await _assetApi.fetch();
      if (!context.mounted) {
        throw Exception('Context is not mounted: $runtimeType');
      }
      for (final asset in assets) {
        switch (asset.assetType) {
          case AssetTypeEnum.avatarImage:
            await precacheImage(CachedNetworkImageProvider(asset.url), context);
            break;
          case AssetTypeEnum.lottieJson:
            await _cacheLottieAsset(asset.url);
            break;
        }
      }
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

  /// Cache Lottie animation files for offline usage
  Future<void> _cacheLottieAsset(String url) async {
    try {
      final cachedFile = await _getLottieCachedFile(url);

      if (cachedFile != null && await cachedFile.exists()) {
        // Check if cache is still valid (30 days)
        final lastModified = await cachedFile.lastModified();
        final now = DateTime.now();
        const cacheDuration = Duration(days: 30);

        if (now.difference(lastModified) < cacheDuration) {
          // Cache is still valid, no need to download
          return;
        }
      }

      // Download and cache the file
      await _downloadAndCacheLottie(url);
    } catch (e) {
      logError('Error caching Lottie asset: $e');
      // Don't throw error for caching failures, just log it
    }
  }

  Future<File?> _getLottieCachedFile(String url) async {
    try {
      final cacheDir = await _getLottieCacheDirectory();
      final fileName = _generateLottieCacheFileName(url);
      return File('${cacheDir.path}/$fileName');
    } catch (e) {
      logError('Error getting Lottie cache file: $e');
      return null;
    }
  }

  Future<Directory> _getLottieCacheDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDir.path}/lottie_cache');

    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    return cacheDir;
  }

  String _generateLottieCacheFileName(String url) {
    final bytes = utf8.encode(url);
    final digest = md5.convert(bytes);
    return '$digest.json';
  }

  Future<void> _downloadAndCacheLottie(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final cacheFile = await _getLottieCachedFile(url);
        if (cacheFile != null) {
          await cacheFile.writeAsBytes(response.bodyBytes);
        }
      }
    } catch (e) {
      logError('Error downloading Lottie asset: $e');
    }
  }

  /// Get cached Lottie file path if exists and valid
  Future<String?> getCachedLottieFilePath(String url) async {
    try {
      final cachedFile = await _getLottieCachedFile(url);

      if (cachedFile != null && await cachedFile.exists()) {
        final lastModified = await cachedFile.lastModified();
        final now = DateTime.now();
        const cacheDuration = Duration(days: 30);

        if (now.difference(lastModified) < cacheDuration) {
          return cachedFile.path;
        }
      }
    } catch (e) {
      logError('Error getting cached Lottie file path: $e');
    }
    return null;
  }
}
