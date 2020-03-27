import 'package:google_maps_cluster_manager/src/cluster_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Cluster<T> {
  final LatLng location;
  final Iterable<ClusterItem<T>> markers;

  Cluster(this.markers)
      : this.location = LatLng(
            markers.fold<double>(0.0, (p, c) => p + c.location.latitude) /
                markers.length,
            markers.fold<double>(0.0, (p, c) => p + c.location.longitude) /
                markers.length);

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
    double zoom = 12.3;
    LatLng center = LatLng(48.141988471740895, 11.577429659664631);

    // TODO: find bounding box of clusteritems and calculate zoom level and center position.
    // Could tihs be done early and saved as a property of this cluster?
    return [zoom, center];
  }

  @override
  String toString() {
    return 'Cluster of $count $T (${location.latitude}, ${location.longitude})';
  }
}
