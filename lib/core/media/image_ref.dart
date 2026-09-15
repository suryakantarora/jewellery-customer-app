/// Where an image comes from. Every image in the app is addressed through
/// this so a backend file server can replace bundled assets without any
/// screen changing.
///
/// String forms: `asset://images/x.jpg`, `key://abc123`, `https://…`.
sealed class ImageRef {
  const ImageRef();

  const factory ImageRef.asset(String path) = AssetImageRef;
  const factory ImageRef.key(String storageKey) = KeyImageRef;
  const factory ImageRef.url(Uri uri) = UrlImageRef;

  static const none = NoImageRef();

  static ImageRef fromString(String? raw) {
    if (raw == null || raw.trim().isEmpty) return none;
    final value = raw.trim();
    if (value.startsWith('asset://')) {
      return ImageRef.asset(value.substring('asset://'.length));
    }
    if (value.startsWith('key://')) {
      return ImageRef.key(value.substring('key://'.length));
    }
    if (value.startsWith('https://') || value.startsWith('http://')) {
      final uri = Uri.tryParse(value);
      return uri == null ? none : ImageRef.url(uri);
    }
    if (value.startsWith('assets/')) return ImageRef.asset(value);
    // A bare storage key from the ERP catalogue response.
    return ImageRef.key(value);
  }

  @override
  String toString() => switch (this) {
    AssetImageRef(:final path) => 'asset://$path',
    KeyImageRef(:final storageKey) => 'key://$storageKey',
    UrlImageRef(:final uri) => uri.toString(),
    NoImageRef() => '',
  };

  bool get isEmpty => this is NoImageRef;

  @override
  bool operator ==(Object other) =>
      other is ImageRef && other.toString() == toString();

  @override
  int get hashCode => toString().hashCode;
}

class AssetImageRef extends ImageRef {
  const AssetImageRef(this.path);

  /// Full asset path (`assets/images/...`) — the `asset://` prefix is the
  /// asset root, so `asset://images/x.jpg` → `assets/images/x.jpg`.
  final String path;

  String get assetPath => path.startsWith('assets/') ? path : 'assets/$path';
}

class KeyImageRef extends ImageRef {
  const KeyImageRef(this.storageKey);
  final String storageKey;
}

class UrlImageRef extends ImageRef {
  const UrlImageRef(this.uri);
  final Uri uri;
}

class NoImageRef extends ImageRef {
  const NoImageRef();
}
