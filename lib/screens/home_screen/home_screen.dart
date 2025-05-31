import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/app_colors.dart';
import '../../constants/recorder_constants.dart';
import 'widgets/audio_visualizer.dart';
import 'widgets/mic.dart';
import '../recordings_list/cubit/files/files_cubit.dart';
import '../recordings_list/view/recordings_list_screen.dart';
import '../../constants/concave_decoration.dart';
import 'cubit/record/record_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/homescreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: BlocBuilder<RecordCubit, RecordState>(
        builder: (context, state) {
          if (state is RecordStopped || state is RecordInitial) {
            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  _appTitle(),
                  const Spacer(),
                  NeumorphicMic(
                    onTap: () {
                      context.read<RecordCubit>().startRecording();
                      BlocProvider.of<RecordCubit>(context).emit(RecordOn(duration: Duration.zero));
                    },
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, _customRoute());
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor.withOpacity(0.5),
                            offset: const Offset(3, 3),
                            blurRadius: 5,
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.highlightColor.withOpacity(0.2),
                            AppColors.shadowColor.withOpacity(0.2),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.queue_music,
                            color: AppColors.accentColor,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'PREVIOUS NOTES',
                            style: TextStyle(
                              color: AppColors.accentColor,
                              fontSize: 20,
                              letterSpacing: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            );
          } else if (state is RecordOn) {
            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  _appTitle(),
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      StreamBuilder<double>(
                        initialData: RecorderConstants.decibleLimit,
                        stream: context.read<RecordCubit>().aplitudeStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return AudioVisualizer(amplitude: snapshot.data);
                          }
                          if (snapshot.hasError) {
                            return Text(
                              'Failed to load',
                              style: TextStyle(color: AppColors.accentColor),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      context.read<RecordCubit>().stopRecording();
                      context.read<FilesCubit>().getFiles();
                    },
                    child: Container(
                      decoration: ConcaveDecoration(
                        depression: 10,
                        colors: [
                          AppColors.highlightColor,
                          AppColors.shadowColor,
                        ],
                      ),
                      child: Icon(
                        Icons.stop,
                        color: AppColors.accentColor,
                        size: 50,
                      ),
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                'An Error occured',
                style: TextStyle(color: AppColors.accentColor),
              ),
            );
          }
        },
      ),
    );
  }

  Text _myNotes() {
    return Text(
      'PREVIOUS NOTES',
      style: TextStyle(
        color: AppColors.accentColor,
        fontSize: 20,
        letterSpacing: 5,
        shadows: [
          Shadow(
            offset: const Offset(3, 3),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _appTitle() {
    return Text(
      'VOICE RECORDER',
      style: TextStyle(
        color: AppColors.accentColor,
        fontSize: 23,
        letterSpacing: 4,
        fontWeight: FontWeight.w200,
        shadows: [
          Shadow(
            offset: const Offset(3, 3),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Route _customRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) =>
          RecordingsListScreen(),
    );
  }
}