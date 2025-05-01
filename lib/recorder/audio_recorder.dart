import 'package:record/record.dart';

class AudioRecorderClass {
  final _recorder = AudioRecorder();

  Future<void> start(RecordConfig config, {required String path}) async {
    await _recorder.start(
      config,
      path: path,
    );
  }

  Future<void> stop() async {
    await _recorder.stop();
  }

  void dispose() {
    _recorder.dispose();
  }
}
