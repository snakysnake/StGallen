import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart'; // For Vector3 and Matrix4

class ARScreenTest extends StatefulWidget {
  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreenTest> {
  ARObjectManager? _arObjectManager;
  ARNode? _currentNode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR Screen'),
      ),
      body: ARView(
        onARViewCreated: _onARViewCreated,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _moveObjectToNewLocation(),
        child: Icon(Icons.move_down),
      ),
    );
  }

  void _onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    _arObjectManager = arObjectManager;
  }

  void _moveObjectToNewLocation() async {
    if (_arObjectManager != null) {
      // Remove existing object if it exists
      if (_currentNode != null) {
        _arObjectManager!.removeNode(_currentNode!);
      }

      // Create a new ARNode at a different location
      final newNode = ARNode(
        type: NodeType.localGLTF2,
        uri: "Models/direction_arrow/scene.gltf", // Adjust the path as needed
        position: Vector3(0, 0, -1), // New position
        scale: Vector3.all(0.2),
      );

      // Add the new node to the AR scene
      final added = await _arObjectManager!.addNode(newNode);
      if (added!) {
        setState(() {
          _currentNode = newNode;
        });
      } else {
        print('Failed to add node');
      }
    }
  }
}
