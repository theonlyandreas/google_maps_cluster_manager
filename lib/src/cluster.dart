import 'dart:math';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_cluster_manager/src/cluster_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/src/radiusToZoom.dart';

class Cluster<T> {
  final LatLng location;
  final double meanValue;
  final Iterable<ClusterItem<T>> markers;

  Cluster(this.markers)
      : this.location = LatLng(
            markers.fold<double>(0.0, (p, c) => p + c.location.latitude) /
                markers.length,
            markers.fold<double>(0.0, (p, c) => p + c.location.longitude) /
                markers.length),
        this.meanValue = markers.fold<double>(0.0, (currentMean, item) {
          if (item.value != null)
            return currentMean + item.value;
          else
            return currentMean;
        });

  Iterable<T> get items => markers.map((m) => m.item);

  int get count => markers.length;

  bool get isMultiple => markers.length > 1;

  String getId() {
    return location.latitude.toString() +
        "_" +
        location.longitude.toString() +
        "_$count";
  }

  /// returns zoom level and Center LatLng location, such that GoogleMaps animated
  /// to that position will show all ClusterItems contained in this Cluster.
  List<dynamic> get zoomAndCenter {
    // TODO: find bounding box of clusteritems and calculate zoom level and center position.
    // Could this be done early and saved as a property of this cluster?

    Coordinates center = Coordinates(location.latitude, location.longitude);
    List<double> dists = markers.map((m) {
      Coordinates markerCoord =
          Coordinates(m.location.latitude, m.location.longitude);
      return GeoFirePoint.distanceBetween(to: markerCoord, from: center);
    }).toList();

    // find maximum value
    double radius = dists.reduce(max);

    double key = radiusToZoom.keys.firstWhere((rad) {
      return radius <= rad;
    });
    double zoom = 0.92 * radiusToZoom[key];

    print('DEBUG - in zoomAndCenter:\n' +
        'location: $location\n' +
        'markers is empty?: ${markers.isEmpty}\n' + 
        'Radius: $radius\n' + 
        'Zoom: $zoom');

    return [zoom, location];
  }

  @override
  String toString() {
    return 'Cluster of $count $T (${location.latitude}, ${location.longitude})';
  }
}
