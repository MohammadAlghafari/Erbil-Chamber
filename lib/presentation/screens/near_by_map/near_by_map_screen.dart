import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../infrastructure/common_response/company_response.dart';

class NearByMapScreen extends StatefulWidget {
  NearByMapScreen(
      {Key key, @required this.nearByCompanies, @required this.deviceLocation})
      : super(key: key);

  final List<CompanyResponse> nearByCompanies;
  final Position deviceLocation;
  @override
  _NearByMapScreenState createState() => _NearByMapScreenState();
}

class _NearByMapScreenState extends State<NearByMapScreen>
    with AutomaticKeepAliveClientMixin {
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.nearByCompanies.length; i++) {
      markers.add(Marker(
        markerId: MarkerId(
          widget.nearByCompanies[i].id,
        ),
        infoWindow: InfoWindow(title: widget.nearByCompanies[i].commercialName),
        position: LatLng(widget.nearByCompanies[i].latitude,
            widget.nearByCompanies[i].longitude),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GoogleMap(
      onMapCreated: (controller) {
        controller.showMarkerInfoWindow(MarkerId(widget.nearByCompanies[0].id));
      },
      compassEnabled: true,
      mapToolbarEnabled: true,
      myLocationEnabled: true,
      gestureRecognizers: Set()
        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
        ..add(
          Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()),
        )
        ..add(
          Factory<HorizontalDragGestureRecognizer>(
              () => HorizontalDragGestureRecognizer()),
        )
        ..add(
          Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
        ),
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.deviceLocation.latitude,
          widget.deviceLocation.longitude,
        ),
        zoom: 12,
      ),
      markers: markers,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
