import 'dart:io';
import 'dart:convert';
import 'package:budget_app/core/icon_manager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';

class BLottie extends StatefulWidget {
  const BLottie(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.animate = true,
    this.loadingWidget,
    this.errorWidget,
    this.onLoaded,
    this.cacheDuration = const Duration(days: 30),
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool animate;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final VoidCallback? onLoaded;
  final Duration cacheDuration;

  @override
  State<BLottie> createState() => _BLottieState();
}

class _BLottieState extends State<BLottie> {
  String? _cachedFilePath;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadLottieAnimation();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorWidget();
    }

    if (_isLoading) {
      return _buildLoadingWidget();
    }

    if (_cachedFilePath != null) {
      return _buildCachedLottie();
    }
    // Fallback to network loading if cache failed
    return _buildNetworkLottie();
  }

  Future<void> _loadLottieAnimation() async {
    try {
      // Try to load from cache first
      final cachedFile = await _getCachedFile();

      if (cachedFile != null && await cachedFile.exists()) {
        // Check if cache is still valid
        final lastModified = await cachedFile.lastModified();
        final now = DateTime.now();

        if (now.difference(lastModified) < widget.cacheDuration) {
          if (mounted) {
            setState(() {
              _cachedFilePath = cachedFile.path;
              _isLoading = false;
            });
          }
          widget.onLoaded?.call();
          return;
        }
      }

      // Download and cache the file
      await _downloadAndCache();
    } catch (e) {
      debugPrint('BLottie: Error loading animation: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  Future<File?> _getCachedFile() async {
    try {
      final cacheDir = await _getCacheDirectory();
      final fileName = _generateCacheFileName(widget.url);
      return File('${cacheDir.path}/$fileName');
    } catch (e) {
      debugPrint('BLottie: Error getting cache file: $e');
      return null;
    }
  }

  Future<Directory> _getCacheDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDir.path}/lottie_cache');

    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    return cacheDir;
  }

  String _generateCacheFileName(String url) {
    final bytes = utf8.encode(url);
    final digest = md5.convert(bytes);
    return '$digest.json';
  }

  Future<void> _downloadAndCache() async {
    try {
      final response = await http.get(Uri.parse(widget.url));

      if (response.statusCode == 200) {
        final cacheFile = await _getCachedFile();
        if (cacheFile != null) {
          await cacheFile.writeAsBytes(response.bodyBytes);
          if (mounted) {
            setState(() {
              _cachedFilePath = cacheFile.path;
              _isLoading = false;
            });
          }
          widget.onLoaded?.call();
        } else {
          throw Exception('Failed to create cache file');
        }
      } else {
        throw Exception('Failed to download: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('BLottie: Error downloading animation: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildCachedLottie() {
    return Lottie.file(
      File(_cachedFilePath!),
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      animate: widget.animate,
    );
  }

  Widget _buildNetworkLottie() {
    return Lottie.network(
      widget.url,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      animate: widget.animate,
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
