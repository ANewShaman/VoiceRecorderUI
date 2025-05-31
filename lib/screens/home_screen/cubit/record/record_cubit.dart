import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../constants/paths.dart';
import '../../../../constants/recorder_constants.dart';
import 'package:record/record.dart'; 
import 'package:flutter/foundation.dart'; 
import'package:equatable/equatable.dart';

part 'record_state.dart';

class RecordCubit extends Cubit<RecordState> {
  RecordCubit() : super(RecordInitial());

  final AudioRecorder _audioRecorder = AudioRecorder();
  Timer? _timer; 
  Stopwatch _stopwatch = Stopwatch(); 

  void startRecording() async {
    final permissions = await [
      Permission.storage,
      Permission.microphone,
    ].request();

    final permissionsGranted = permissions[Permission.storage]!.isGranted &&
        permissions[Permission.microphone]!.isGranted;

    if (permissionsGranted) {
      try {
        _timer?.cancel();
        _stopwatch.reset();

        final appFolder = Directory(Paths.recording);
        if (!await appFolder.exists()) {
          await appFolder.create(recursive: true);
        }

        final filepath = '${Paths.recording}/${DateTime.now().millisecondsSinceEpoch}${RecorderConstants.fileExtention}';

        await _audioRecorder.start(RecordConfig(), path: filepath);
        debugPrint('Audio recording started to: $filepath');

        _stopwatch.start(); 
        emit(RecordOn(duration: Duration.zero));
        debugPrint('Timer started from 0:00.');
        _timer = Timer.periodic(const Duration(milliseconds: 100), (_) async {
          final currentDuration = _stopwatch.elapsed;

  
          if (currentDuration.inSeconds >= 10) {
            _stopwatch.stop(); 
            _timer?.cancel(); 
            await _audioRecorder.stop(); 
            debugPrint('Audio recording and timer stopped automatically at 0:10.');

            emit(RecordStopped(duration: const Duration(seconds: 10)));
          } else {
            if (state is RecordOn) {
              emit(RecordOn(duration: currentDuration));
            }
          }
        });

      } catch (e) {
        debugPrint('Error during recording start: $e');
        emit(RecordError('Failed to start recording: $e'));
      }
    } else {
      debugPrint('Permission not granted');
      emit(const RecordPermissionDenied()); 
    }
  }

  Future<void> stopRecording() async {
    try {
      _timer?.cancel();
      _timer = null;

      _stopwatch.stop();

      final path = await _audioRecorder.stop();
      debugPrint('Audio recording stopped. Output path: $path');

      emit(RecordStopped(duration: _stopwatch.elapsed, path: path)); 
      _stopwatch.reset();
    } catch (e) {
      debugPrint('Error during recording stop: $e');
      emit(RecordError('Failed to stop recording: $e'));
    }
  }

  Future<Amplitude> getAmplitude() async {
    return await _audioRecorder.getAmplitude();
  }

  Stream<double> aplitudeStream() async* {
    while (true) {
      await Future.delayed(
        Duration(milliseconds: RecorderConstants.amplitudeCaptureRateInMilliSeconds),
      );
      final ap = await _audioRecorder.getAmplitude();
      yield ap.current;
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel(); // Ensure timer is cancelled
    _stopwatch.stop(); // Ensure stopwatch is stopped
    _audioRecorder.dispose(); // Dispose of the audio recorder
    return super.close();
  }
}
