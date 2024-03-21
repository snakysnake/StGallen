import 'dart:io';

import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_archive/flutter_archive.dart';

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

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
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
            ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: onLocalObjectAtOriginButtonPressed,
                    child: Text("Direction"),
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
    location.onLocationChanged.listen((LocationData newLocation) {
      print("Location Tracked");
      trackUserPosition();
    });
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
        scale: Vector3(0.2, 0.2, 0.2),
        position: Vector3(0.0, -0.9, -0.9 - i),
        rotation: Vector4(0.0, 1.0, 0.0, 45.5),
      );
      bool? didAddLocalNode = await this.arObjectManager!.addNode(newNode);
      this.localObjectNodes.add((didAddLocalNode!) ? newNode : null);
    }
  }

  Future<Vector3?> getCurrentUserPosition() async {
    Matrix4? userPose = await arSessionManager?.getCameraPose();
    if (userPose != null) {
      Vector3 userPosition = Vector3(
        userPose.getColumn(3).x,
        userPose.getColumn(3).y,
        userPose.getColumn(3).z,
      );
      return userPosition;
    }
    return null;
  }

  // Continuously track user position (example)
  void trackUserPosition() async {
    // Update user position based on device motion or ARKit/ARCore
    Vector3? userPosition = await getCurrentUserPosition();

    // Check for intersection with each arrow
    while (!localObjectNodes.isEmpty &&
        isUserNearArrow(userPosition, localObjectNodes[0]?.position)) {
      // User crossed the arrow, trigger event
      handleArrowCrossed();
    }
  }

  // Check if user is near the arrow (example)
  bool isUserNearArrow(Vector3? userPosition, Vector3? arrowPosition) {
    if (userPosition == null) return true;
    if (arrowPosition == null) return true;
    double distanceThreshold = 0.5; // Adjust threshold as needed
    double distance = userPosition.distanceTo(arrowPosition);

    // Log user position
    print('User Position: ${userPosition.toString()}');

    // Log arrow position
    print('Arrow Position: ${arrowPosition.toString()}');

    return distance < distanceThreshold;
  }

// Event handler for when an arrow is crossed (example)
  void handleArrowCrossed() async {
    this.arObjectManager!.removeNode(localObjectNodes[0]!);
    this.localObjectNodes.remove(localObjectNodes[0]!);

    var newNode = ARNode(
      type: NodeType.localGLTF2,
      uri: "Models/direction_arrow/scene.gltf", // Adjust the path as needed
      scale: Vector3(0.2, 0.2, 0.2),
      position: Vector3(0.0, -0.9,
          localObjectNodes[localObjectNodes.length - 1]!.position.z - 1),
      rotation: Vector4(0.0, 1.0, 0.0, 45.5),
    );
    bool? didAddLocalNode = await this.arObjectManager!.addNode(newNode);
    this.localObjectNodes.add((didAddLocalNode!) ? newNode : null);
  }
}
