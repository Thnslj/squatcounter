import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squatter/blocs/cubit/pose_analyzer_cubit.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

class Camera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CameraDescription>>(
        future: availableCameras(),
        builder: (context, AsyncSnapshot<List<CameraDescription>> snapshot) {
          if (snapshot.hasData) {
            return CameraInner(snapshot.data.first);
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class CameraInner extends StatefulWidget {
  final CameraDescription camera;

  CameraInner(
    this.camera,
  );

  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<CameraInner> {
  CameraController controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    {
      controller = new CameraController(
        widget.camera,
        ResolutionPreset.high,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        controller.startImageStream((CameraImage img) {
          BlocProvider.of<PoseAnalyzerCubit>(context).detect(img);
        });
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller),
    );
  }
}
