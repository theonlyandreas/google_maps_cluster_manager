import 'dart:math';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_cluster_manager/src/cluster_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

    print('DEBUG - in zoomAndCenter:\n' +
        'location: $location\n' +
        'markers is empty?: ${markers.isEmpty}');

    Coordinates center = Coordinates(location.latitude, location.longitude);
    List<double> dists = markers.map((m) {
      Coordinates markerCoord =
          Coordinates(m.location.latitude, m.location.longitude);
      return GeoFirePoint.distanceBetween(to: markerCoord, from: center);
    }).toList();

    Map<double, double> radiusToZoom = {
      0.105: 19.0,
      0.121: 18.786,
      0.136: 18.623,
      0.159: 18.399,
      0.205: 18.027,
      0.24: 17.802,
      0.28: 17.580,
      0.341: 17.297,
      0.39: 17.101,
      0.41: 17.032,
      0.463: 16.853,
      0.483: 16.794,
      0.539: 16.636,
      0.566: 16.566,
      0.604: 16.472,
      0.633: 16.404,
      0.697: 16.265,
      0.753: 16.154,
      0.842: 15.991,
      0.992: 15.755,
      1.27: 15.399,
      1.641: 15.029,
      1.969: 14.766,
      2.422: 14.467,
      2.89: 14.212,
      3.395: 13.980,
      3.942: 13.764,
      4.737: 13.499,
      5.774: 13.214,
      7.291: 12.877,
      7.928: 12.756,
      8.68: 12.625,
      9.596: 12.480,
      12.095: 12.146,
      15.475: 11.790,
      19.231: 11.476,
      24.438: 11.130,
      26.473: 11.014,
      29.535: 10.856,
      34.11: 10.648,
      39.581: 10.432,
      46.146: 10.210,
      49.616: 10.105,
      59.448: 9.843,
      66.81: 9.673,
      78.745: 9.435,
      91.994: 9.209,
      113.316: 8.905,
      150.487: 8.491,
      189.785: 8.151,
      236.426: 7.828,
      270.253: 7.631,
      294.664: 7.503,
      368.972: 7.168,
      450.062: 6.870,
      477.946: 6.780,
      544.0: 6.583,
      611.624: 6.405,
      654.4: 6.301,
      738.324: 6.114,
      850.654: 5.892,
      890.45: 5.820,
      922.007: 5.765,
      983.735: 5.662,
      1229.149: 5.299,
      1253.485: 5.266,
      1274.099: 5.239,
      1333.818: 5.162,
      1433.323: 5.040,
      1551.485: 4.903,
      1670.232: 4.773,
      1692.555: 4.750,
      1785.252: 4.653,
      2129.424: 4.321,
      2498.097: 3.9942,
      2806.468: 3.729,
      3160.407: 3.421,
      3460.315: 3.137,
      3584.991: 3.0,
    };

    // find maximum value
    double radius = dists.reduce(max);

    double key = radiusToZoom.keys.firstWhere((rad) {
      return radius <= rad;
    });
    double zoom = radiusToZoom[key];

    return [zoom, location];
  }

  @override
  String toString() {
    return 'Cluster of $count $T (${location.latitude}, ${location.longitude})';
  }
}
