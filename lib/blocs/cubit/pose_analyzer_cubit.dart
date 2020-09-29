import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:meta/meta.dart';
import 'package:tflite/tflite.dart';

part 'pose_analyzer_state.dart';

class PoseAnalyzerCubit extends Cubit<PoseAnalyzeState> {
  bool isDetecting = false;
  bool modelLoading = false;

  PoseAnalyzerCubit() : super(PoseAnalyzerInitial());

  Future<void> loadModel() async {
    await Tflite.loadModel(
        model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");

    this.emit(PoseAnalyzerReady());
  }

  void detect(CameraImage img) async {
    if (!this.modelLoading) {
      this.modelLoading = true;
      await this.loadModel();
      this.modelLoading = false;
    }
    if (this.isDetecting) {
      return;
    }
    this.isDetecting = true;
    List recognitions = await Tflite.runPoseNetOnFrame(
      bytesList: img.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: img.height,
      imageWidth: img.width,
      numResults: 2,
    );

    if (recognitions.length == 0) {
      this.emit(PoseAnalyzeResult(PoseResult.none));
    } else {
      this.emit(PoseAnalyzeResult(PoseResult.squatting));
    }
    this.isDetecting = false;
  }
}
