import 'dart:async';
import 'dart:typed_data';

import 'package:admin/core/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class SmoothMemoryImage extends StatefulWidget {
  const SmoothMemoryImage({
    super.key,
    required this.newImageBytes,
  });
  final Uint8List newImageBytes;

  @override
  State<SmoothMemoryImage> createState() => _SmoothMemoryImageState();
}

class _SmoothMemoryImageState extends State<SmoothMemoryImage> {
  ImageProvider? _currentImageProvider;
  late Uint8List _currentImageBytes;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _currentImageBytes = widget.newImageBytes;
    _currentImageProvider = MemoryImage(_currentImageBytes);
  }

  @override
  void didUpdateWidget(SmoothMemoryImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.newImageBytes != oldWidget.newImageBytes) {
      _loadAndSwapImage(widget.newImageBytes);
    }
  }

  Future<void> _loadAndSwapImage(Uint8List bytes) async {
    if (_isLoading) {
      return; // Prevent multiple simultaneous loads
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    final completer = Completer<void>();
    final imageProvider = MemoryImage(bytes);
    bool loadSuccess = false;

    final stream = imageProvider.resolve(ImageConfiguration.empty);
    final listener = ImageStreamListener(
      (_, __) {
        loadSuccess = true;
        completer.complete();
      },
      onError: (error, stackTrace) {
        loadSuccess = false;
        completer.complete();
      },
    );

    stream.addListener(listener);
    await completer.future;
    stream.removeListener(listener);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (loadSuccess) {
          // Only update if the image loaded successfully
          _currentImageBytes = bytes;
          _currentImageProvider = imageProvider;
          _hasError = false;
        } else {
          // Keep the previous image and mark as error
          _hasError = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _buildImageWidget(),
    );
  }

  Widget _buildImageWidget() {
    // If there's an error or no current provider, show default image
    if (_hasError || _currentImageProvider == null) {
      return Image.asset(
        DefaultImages.FRONT_CAMERA_THUMBNAIL,
        fit: BoxFit.cover,
        width: 100.w,
        height: 205,
      );
    }

    // Show current image with error handling
    return Image(
      key: ValueKey(_currentImageBytes.hashCode),
      image: _currentImageProvider!,
      fit: BoxFit.cover,
      width: 100.w,
      height: 205,
      errorBuilder: (context, exception, stackTrace) {
        // If current image fails, mark as error and show default
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
        return Image.asset(
          DefaultImages.FRONT_CAMERA_THUMBNAIL,
          fit: BoxFit.cover,
          width: 100.w,
          height: 205,
        );
      },
    );
  }
}
