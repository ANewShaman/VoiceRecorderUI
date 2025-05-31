import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rapid_note/screens/home_screen/widgets/simple_modulation_screen.dart';

class RecordingsListScreen extends StatefulWidget {
  static const String routeName = '/recordings-list'; 
  
  @override
  _RecordingsListScreenState createState() => _RecordingsListScreenState();
}

class _RecordingsListScreenState extends State<RecordingsListScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> recordings = [
    'Recording 1 - 05:30',
    'Recording 2 - 02:15',
    'Recording 3 - 07:45',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recordings'),
        backgroundColor: const Color.fromARGB(255, 154, 93, 253),
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        itemCount: recordings.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey[900],
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                recordings[index],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.play_arrow, color: const Color.fromARGB(255, 255, 255, 255)),
                onPressed: () async {
                  await _audioPlayer.stop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SimpleModulationScreen(),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
  height: 60,
  color: const Color.fromARGB(255, 154, 93, 253),
  child: Center(
    child: StreamBuilder<PlayerState>(
      stream: _audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.playing) {
          return IconButton(
            icon: Icon(Icons.stop, color: Colors.blueGrey),
            onPressed: () => _audioPlayer.stop(),
          );
        }
        return Icon(
          Icons.music_note, 
          color: Colors.white,
          size: 20, 
        );
      },
    ),
  ),
),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}