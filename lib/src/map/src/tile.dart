part of '../map.dart';

const kDefaultLayer = MapLayer(
  id: 'osm',
  name: 'OpenStreetMap',
  source: MapSource.osm,
);

/// [kMinZoom] is the minimum zoom level for the map.
const double kMinZoom = 3;

/// [kMaxZoom] is the maximum zoom level for the map.
const double kMaxZoom = 18;

class ThemedTileLayer extends StatefulWidget {
  /// [layer] is the selected layer to use. If not provided, the default one will be used, aka, OpenStreetMap.
  final MapLayer? layer;

  /// [minZoom] is the minimum zoom level for the map.
  final double minZoom;

  /// [maxZoom] is the maximum zoom level for the map.
  final double maxZoom;

  /// [isCancellable] is a flag to indicate whether the map can be cancelled or not.
  final bool isCancellable;

  /// [ThemedTileLayer] is a wrapper for [TileLayer] widget. It will automatically detect which layer to use based on
  /// the [layer] parameter. If not provided, the default one will be used, aka, OpenStreetMap.
  const ThemedTileLayer({
    super.key,
    this.layer,
    this.minZoom = kMinZoom,
    this.maxZoom = kMaxZoom,
    this.isCancellable = true,
  });

  @override
  State<ThemedTileLayer> createState() => _ThemedTileLayerState();

  static double get reservedAttributionHeight => 20;
}

class _ThemedTileLayerState extends State<ThemedTileLayer> {
  MapLayer get layer => widget.layer ?? kDefaultLayer;
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  String get _osmUrl => 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  // String get _osmUrl => 'http://127.0.0.1:5000/{z}/{x}/{y}.png';

  String get _mapboxUrl {
    if (layer.source != MapSource.mapbox) {
      return _osmUrl;
    }

    if (layer.mapboxToken == null) {
      return _osmUrl;
    }

    if (layer.mapboxToken!.isEmpty) {
      return _osmUrl;
    }

    final style = layer.mapboxLayers?.firstOrNull;

    if (style == null) {
      return _osmUrl;
    }

    String username;
    String styleId;

    switch (style) {
      case MapboxStyle.navigation:
        username = 'mapbox';
        styleId = isDark ? 'navigation-night-v1' : 'navigation-day-v1';
        break;
      case MapboxStyle.satelliteHybrid:
        username = 'mapbox';
        styleId = 'satellite-streets-v12';
        break;
      case MapboxStyle.satellite:
        username = 'mapbox';
        styleId = 'satellite-v9';
        break;
      case MapboxStyle.monochrome:
        username = 'mapbox';
        styleId = isDark ? 'dark-v11' : 'light-v11';
        break;
      case MapboxStyle.custom:
        username = layer.mapboxCustomUsername ?? 'mapbox';
        if (layer.mapboxCustomUsername == null) {
          styleId = 'streets-v11';
        } else {
          styleId = layer.mapboxCustomStyleId ?? 'streets-v11';
        }
        break;
      case MapboxStyle.streets:
      default:
        username = 'mapbox';
        styleId = 'streets-v11';
        break;
    }

    return _composeMapboxUrl(
      username: username,
      styleId: styleId,
      token: layer.mapboxToken!,
    );
  }

  String get _mapboxAttribution {
    if (layer.source != MapSource.mapbox) {
      return _layrzAttributionLight;
    }

    if (layer.mapboxToken == null) {
      return _layrzAttributionLight;
    }

    if (layer.mapboxToken!.isEmpty) {
      return _layrzAttributionLight;
    }

    final style = layer.mapboxLayers?.firstOrNull;

    if (style == null) {
      return _layrzAttributionLight;
    }

    String attribution;

    switch (style) {
      case MapboxStyle.navigation:
      case MapboxStyle.monochrome:
        attribution = isDark ? (layer.attributionUrlDark ?? _layrzAttributionDark) : (layer.attributionUrl);
        break;
      case MapboxStyle.satellite:
      case MapboxStyle.satelliteHybrid:
        attribution = layer.attributionUrlDark ?? layer.attributionUrl;
        break;
      case MapboxStyle.custom:
      case MapboxStyle.streets:
      default:
        attribution = layer.attributionUrl;
    }

    return attribution;
  }

  String _composeMapboxUrl({required String username, required String styleId, required String token}) {
    return 'https://api.mapbox.com/styles/v1/$username/$styleId/tiles/512/{z}/{x}/{y}?access_token=$token';
  }

  String get _hereUrl {
    if (layer.source != MapSource.here) {
      return _osmUrl;
    }

    if (layer.hereToken == null) {
      return _osmUrl;
    }

    if (layer.hereToken!.isEmpty) {
      return _osmUrl;
    }

    final style = layer.hereLayers?.firstOrNull;

    if (style == null) {
      return _osmUrl;
    }

    String styleId;

    switch (style) {
      case HereStyle.lite:
        styleId = isDark ? 'lite.night' : 'lite.day';
        break;
      case HereStyle.topo:
        styleId = 'topo.day';
        break;
      case HereStyle.satellite:
        styleId = 'satellite.day';
        break;
      case HereStyle.hybrid:
        styleId = 'lite.satellite.day';
        break;
      case HereStyle.logistics:
        styleId = 'logistics.day';
        break;
      case HereStyle.explore:
      default:
        styleId = isDark ? 'explore.night' : 'explore.day';
        break;
    }

    return 'https://maps.hereapi.com/v3/base/mc/{z}/{x}/{y}/png8?style=$styleId&apiKey=${layer.hereToken}';
  }

  String get _hereAttribution {
    if (layer.source != MapSource.here) {
      return _layrzAttributionLight;
    }

    if (layer.hereToken == null) {
      return _layrzAttributionLight;
    }

    if (layer.hereToken!.isEmpty) {
      return _layrzAttributionLight;
    }

    final style = layer.hereLayers?.firstOrNull;

    if (style == null) {
      return _layrzAttributionLight;
    }

    String attribution;

    switch (style) {
      case HereStyle.topo:
      case HereStyle.satellite:
      case HereStyle.hybrid:
      case HereStyle.logistics:
        attribution = layer.attributionUrl;
        break;
      case HereStyle.explore:
      case HereStyle.lite:
      default:
        attribution = isDark ? (layer.attributionUrlDark ?? _layrzAttributionDark) : (layer.attributionUrl);
        break;
    }

    return attribution;
  }

  String get _googleAttribution {
    if (layer.source != MapSource.google) {
      return _layrzAttributionLight;
    }

    if (layer.googleToken == null) {
      return _layrzAttributionLight;
    }

    if (layer.googleToken!.isEmpty) {
      return _layrzAttributionLight;
    }

    final style = layer.googleLayers?.firstOrNull;

    if (style == null) {
      return _layrzAttributionLight;
    }

    return layer.attributionUrl;
  }

  String get _layrzAttributionLight => 'https://cdn.layrz.com/resources/layrz/logo/normal.png';
  String get _layrzAttributionDark => 'https://cdn.layrz.com/resources/layrz/logo/white.png';

  String get _customUrl {
    if (layer.source != MapSource.custom) {
      return _osmUrl;
    }

    if (isDark) {
      return layer.rasterServerDark ?? layer.rasterServerLight ?? _osmUrl;
    }

    return layer.rasterServerLight ?? _osmUrl;
  }

  String get _customAttribution {
    if (layer.source != MapSource.custom) {
      return _layrzAttributionLight;
    }

    if (isDark) {
      return layer.attributionUrlDark ?? layer.attributionUrl;
    }

    return layer.attributionUrl;
  }

  int get buffer => 0;

  Map<String, String> get headers => layer.source == MapSource.google
      ? {
          // Set cache to 30 days
          'Cache-Control': 'max-age=2592000',
        }
      : {};

  TileLayer _buildTile({required String urlTemplate}) {
    return TileLayer(
      urlTemplate: urlTemplate,
      minZoom: widget.minZoom,
      maxZoom: widget.maxZoom,
      minNativeZoom: widget.minZoom.toInt(),
      maxNativeZoom: widget.maxZoom.toInt(),
      tileProvider: widget.isCancellable
          ? CancellableNetworkTileProvider(headers: headers)
          : NetworkTileProvider(headers: headers),
      keepBuffer: buffer,
      panBuffer: buffer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (layer.source == MapSource.osm) ...[
          _buildTile(urlTemplate: _osmUrl),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.network(
                _layrzAttributionLight,
                width: 80,
                height: 20,
                filterQuality: FilterQuality.medium,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
        ] else if (layer.source == MapSource.mapbox) ...[
          _buildTile(urlTemplate: _mapboxUrl),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.network(
                _mapboxAttribution,
                width: _scaleWidth(layer),
                height: _scaleHeight(layer),
                filterQuality: FilterQuality.medium,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
        ] else if (layer.source == MapSource.here) ...[
          _buildTile(urlTemplate: _hereUrl),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.network(
                _hereAttribution,
                width: _scaleWidth(layer),
                height: _scaleHeight(layer),
                filterQuality: FilterQuality.medium,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
        ] else if (layer.source == MapSource.google) ...[
          FutureBuilder<String?>(
            future: _fetchGoogleAuth(layer: layer),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return _buildTile(urlTemplate: snapshot.data!);
                }
              }

              return const SizedBox.expand();
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.network(
                _googleAttribution,
                width: _scaleWidth(layer),
                height: _scaleHeight(layer),
                filterQuality: FilterQuality.medium,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
        ] else ...[
          _buildTile(urlTemplate: _customUrl),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.network(
                _customAttribution,
                width: 80,
                height: 20,
                filterQuality: FilterQuality.medium,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
        ],
      ],
    );
  }

  double _scaleWidth(MapLayer layer) {
    double aspectRatio = layer.attributionWidth / layer.attributionHeight;
    double height = ThemedTileLayer.reservedAttributionHeight;

    return height * aspectRatio;
  }

  double _scaleHeight(MapLayer layer) {
    return ThemedTileLayer.reservedAttributionHeight;
  }

  Future<String?> _fetchGoogleAuth({required MapLayer layer}) async {
    final googleMapsKey = layer.googleToken;
    if (googleMapsKey == null) {
      return _osmUrl;
    }

    final prefs = await SharedPreferences.getInstance();

    final googleSession = prefs.getString('google.maps.${layer.id}.token');
    final googleExpiration = prefs.getInt('google.maps.${layer.id}.expiration');

    if (googleSession != null && googleExpiration != null) {
      if (googleExpiration > DateTime.now().secondsSinceEpoch) {
        return 'https://tile.googleapis.com/v1/2dtiles/{z}/{x}/{y}?session=$googleSession&key=$googleMapsKey';
      }
    }

    final style = layer.googleLayers?.firstOrNull;

    if (style == null) {
      return _osmUrl;
    }

    try {
      final params = {
        'mapType': _convertGoogleStyle(style),
        'language': 'en-US',
        'scale': 'scaleFactor1x',
        'layerTypes': _convertGoogleTypes(style),
      };

      debugPrint('Google maps request: $params');
      final response = await http.post(
        Uri.parse('https://tile.googleapis.com/v1/createSession?key=$googleMapsKey'),
        body: jsonEncode(params),
      );
      if (response.statusCode != 200) {
        debugPrint('Error fetching google maps url: ${response.statusCode}');
        return null;
      }

      final data = jsonDecode(response.body);

      prefs.setString('google.maps.${layer.id}.token', data['session']);
      prefs.setInt('google.maps.${layer.id}.expiration', int.parse(data['expiry']));

      return 'https://tile.googleapis.com/v1/2dtiles/{z}/{x}/{y}?session=${data['session']}&key=$googleMapsKey';
    } catch (e) {
      debugPrint('Error fetching google maps url: $e');
      return null;
    }
  }

  String _convertGoogleStyle(GoogleMapLayer style) {
    switch (style) {
      case GoogleMapLayer.roadmap:
        return 'roadmap';
      case GoogleMapLayer.satellite:
        return 'satellite';
      case GoogleMapLayer.terrain:
        return 'terrain';
      case GoogleMapLayer.hybrid:
        return 'satellite';
      default:
        return 'roadmap';
    }
  }

  List<String> _convertGoogleTypes(GoogleMapLayer style) {
    debugPrint('Google maps style: $style');
    switch (style) {
      case GoogleMapLayer.terrain:
      case GoogleMapLayer.hybrid:
        return ['layerRoadmap'];
      // return ['roadmap'];
      case GoogleMapLayer.satellite:
      case GoogleMapLayer.roadmap:
      default:
        return [];
    }
  }
}
