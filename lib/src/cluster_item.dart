import 'package:geoflutterfire/src/util.dart' show Util;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClusterItem<T> {
  final LatLng location;
  final String geohash;
  final T item;

  ClusterItem(this.location, {this.item})
      : geohash = Util.encode4(location.latitude, location.longitude, 20);
}
