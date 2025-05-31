part of 'record_cubit.dart';

 
@immutable 
abstract class RecordState extends Equatable { 
  const RecordState();

  @override
  List<Object> get props => [];
}

class RecordInitial extends RecordState {}

class RecordOn extends RecordState {
  final Duration duration; 
  const RecordOn({required this.duration});

  @override
  List<Object> get props => [duration];
}

class RecordStopped extends RecordState {

  final Duration? duration;
  final String? path; 


  const RecordStopped({this.duration, this.path});

  @override
  List<Object> get props => [duration ?? Duration.zero, path ?? ''];
}

class RecordPermissionDenied extends RecordState {

  const RecordPermissionDenied();
}

class RecordError extends RecordState {

  final String message;
  const RecordError(this.message);

  @override
  List<Object> get props => [message];
}
