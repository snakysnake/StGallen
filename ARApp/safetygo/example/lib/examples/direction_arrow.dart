import 'dart:async';
import 'dart:io';

import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:safetygo/network_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'dart:math';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:sensors/sensors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DirectionArrowWidget extends StatefulWidget {
  DirectionArrowWidget({Key? key}) : super(key: key);
  @override
  _LocalAndWebObjectsWidgetState createState() =>
      _LocalAndWebObjectsWidgetState();
}

class _LocalAndWebObjectsWidgetState extends State<DirectionArrowWidget> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  List<ARNode?> localObjectNodes = [];
  Location location = Location();
  LocationData currentLocation =
      LocationData.fromMap({'latitude': 47.4284032, 'longitude': 9.3847552});
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

// For holding Co-ordinates as LatLng
  final List<LatLng> polyPoints = [];

//For holding instance of Polyline
  final Set<Polyline> polyLines = {};
// For holding instance of Marker
  final Set<Marker> markers = {};
  var data;

  // TODO: Assing this from notification.
  LatLng endLocation = LatLng(47.42796861302844, 9.385024598392855);

  late StreamSubscription<LocationData> locationSubscription;

  @override
  void initState() {
    super.initState();
    retrieveLocation();
    getJsonData();
    // Start tracking user position
    trackDeviceMotion();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
    setMarkers();
  }

  setMarkers() {
    markers.add(
      Marker(
        markerId: MarkerId("Home"),
        position: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        infoWindow: InfoWindow(
          title: "Home",
          snippet: "Home Sweet Home",
        ),
      ),
    );
    markers.add(Marker(
      markerId: MarkerId("Destination"),
      position:
          LatLng(currentLocation.latitude!, currentLocation.longitude! + 10),
      infoWindow: InfoWindow(
        title: "Masjid",
        snippet: "5 star rated place",
      ),
    ));
    setState(() {});
  }

  Future<void> retrieveLocation() async {
    try {
      LocationData locationData = await location.getLocation();
      setState(() {
        currentLocation = locationData;
        endLocation = LatLng(locationData.latitude!, locationData.longitude!);
      });
    } catch (e) {
      print('Failed to get location: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();

    stopListeningToLocation();

    arSessionManager!.dispose();
  }

  // Stop listening to location updates (wherever you need to stop)
  void stopListeningToLocation() {
    if (!locationSubscription.isPaused) {
      locationSubscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direction'),
      ),
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    flex: 3,
                    child: ARView(
                      onARViewCreated: onARViewCreated,
                      planeDetectionConfig:
                          PlaneDetectionConfig.horizontalAndVertical,
                    )),
                Expanded(
                    flex: 2,
                    child: (currentLocation.latitude != null &&
                            currentLocation.longitude != null
                        ? GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(currentLocation.latitude!,
                                  currentLocation.longitude!),
                              zoom: 15,
                            ),
                            markers: markers,
                            polylines: polyLines,
                          )
                        : CircularProgressIndicator())),
              ],
            ),
            (currentLocation.latitude != null &&
                    currentLocation.longitude != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Latitude: ${currentLocation.latitude}'),
                      Text('Longitude: ${currentLocation.longitude}'),
                    ],
                  )
                : CircularProgressIndicator()),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: onLocalObjectAtOriginButtonPressed,
                    child: Text("Show me the safe route!"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showAnimatedGuide: false,
          showPlanes: false,
          // customPlaneTexturePath: "Images/triangle.png",
          showWorldOrigin: false,
          handleTaps: false,
        );
    this.arObjectManager!.onInitialize();
  }

  Future<void> onLocalObjectAtOriginButtonPressed() async {
    if (!this.localObjectNodes.isEmpty) {
      for (var node in this.localObjectNodes) {
        this.arObjectManager!.removeNode(node!);
      }
      this.localObjectNodes = [];
    }
    for (int i = 0; i < 10; ++i) {
      var newNode = ARNode(
        type: NodeType.localGLTF2,
        uri: "Models/direction_arrow/scene.gltf", // Adjust the path as needed
        scale: vector_math.Vector3(0.2, 0.2, 0.2),
        position: vector_math.Vector3(0.0, -0.9, -0.9 - i),
        rotation: vector_math.Vector4(0.0, 1.0, 0.0, 45.5),
      );
      bool? didAddLocalNode = await this.arObjectManager!.addNode(newNode);
      this.localObjectNodes.add((didAddLocalNode!) ? newNode : null);
    }
  }

  Future<vector_math.Vector3?> getCurrentUserPosition() async {
    Matrix4? userPose = await arSessionManager?.getCameraPose();
    if (userPose != null) {
      vector_math.Vector3 userPosition = vector_math.Vector3(
        userPose.getColumn(3).x,
        userPose.getColumn(3).y,
        userPose.getColumn(3).z,
      );
      return userPosition;
    }
    return null;
  }

  Future<void> initLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Request location permissions
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    bool trackCalled = false;

    // Subscribe to location updates
    locationSubscription =
        location.onLocationChanged.listen((LocationData newLocation) {
      // Update previous location
      setState(() {
        if (!trackCalled) {
          trackCalled = true;
          trackUserPosition();
          trackCalled = false;
        }
      });
    });
  }

  void trackDeviceMotion() async {
    await initLocation();

    bool trackCalled = false;

    accelerometerEvents.listen((AccelerometerEvent event) {
      // Convert accelerometer data into a Vector3 instance
      vector_math.Vector3 acceleration =
          vector_math.Vector3(event.x, event.y, event.z);
      if (!trackCalled) {
        trackCalled = true;
        trackUserPosition();
        trackCalled = false;
      }
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      // Convert gyroscope data into a Vector3 instance
      vector_math.Vector3 rotationRate =
          vector_math.Vector3(event.x, event.y, event.z);
      if (!trackCalled) {
        trackCalled = true;
        trackUserPosition();
        trackCalled = false;
      }
    });
  }

  // Continuously track user position (example)
  void trackUserPosition() async {
    // Update user position based on device motion or ARKit/ARCore
    vector_math.Vector3? userPosition = await getCurrentUserPosition();

    // Check for intersection with each arrow
    while (!localObjectNodes.isEmpty && isUserNearAnyArrow(userPosition)) {
      // User crossed the arrow, trigger event
      handleArrowCrossed();
    }
  }

  // Check if user is near the arrow (example)
  bool isUserNearAnyArrow(vector_math.Vector3? userPosition) {
    if (userPosition == null) return false;
    if (localObjectNodes.isEmpty) return false;
    double distanceThreshold = 1.0; // Adjust threshold as needed

    for (var arrowPosition in localObjectNodes) {
      if (arrowPosition == null) return true;
      double distance = userPosition.distanceTo(arrowPosition.position);

      if (distance < distanceThreshold) {
        print(
            'Result: User Position: ${userPosition.toString()}, Arrow Position: ${arrowPosition.toString()},  ${distance}, ${distance < distanceThreshold}');
        return true;
      }
    }
    return false;
  }

// Event handler for when an arrow is crossed (example)
  void handleArrowCrossed() async {
    this.arObjectManager!.removeNode(localObjectNodes[0]!);
    this.localObjectNodes.remove(localObjectNodes[0]!);

    var newNode = ARNode(
      type: NodeType.localGLTF2,
      uri: "Models/direction_arrow/scene.gltf", // Adjust the path as needed
      scale: vector_math.Vector3(0.2, 0.2, 0.2),
      position: vector_math.Vector3(
          0.0,
          -0.9,
          localObjectNodes.isEmpty
              ? 0.0
              : localObjectNodes[localObjectNodes.length - 1]!.position.z - 1),
      rotation: vector_math.Vector4(0.0, 1.0, 0.0, 45.5),
    );
    bool? didAddLocalNode = await this.arObjectManager!.addNode(newNode);
    this.localObjectNodes.add((didAddLocalNode!) ? newNode : null);
  }

  void getJsonData() async {
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format

    NetworkHelper network = NetworkHelper(
      startLat:
          (currentLocation.latitude != null) ? currentLocation.latitude! : 0.0,
      startLng: (currentLocation.longitude != null)
          ? currentLocation.longitude!
          : 0.0,
      endLat: endLocation.latitude,
      endLng: endLocation.longitude,
    );

    try {
      // getData() returns a json Decoded data
      data = await network.getData();

      // We can reach to our desired JSON data manually as following
      LineString ls =
          LineString(data['features'][0]['geometry']['coordinates']);

      for (int i = 0; i < ls.lineString.length; i++) {
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }
      setPolyLines();
    } catch (e) {
      print(e);
    }
  }

  setPolyLines() {
    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      color: Colors.lightBlue,
      points: polyPoints,
    );
    polyLines.add(polyline);
    setState(() {});
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
