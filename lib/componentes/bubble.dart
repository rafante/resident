import 'package:resident/imports.dart';

class Bubble extends StatefulWidget {
  Bubble(
      {this.message,
      this.time,
      this.delivered,
      this.isMe,
      this.autor,
      this.onTap,
      this.link,
      this.audio});

  final String message, time;
  final String autor;
  final Function onTap;
  final delivered, isMe;
  final String link;
  final bool audio;
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  StreamSubscription soundStream;
  static FlutterSound flutterSound = new FlutterSound();
  AudioPlayer player;
  double pontoAudio = 0;
  int duracao = 0;
  AudioPlayerState playerState = AudioPlayerState.STOPPED;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AudioPlayer.logEnabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    final bg = widget.isMe ? Colors.greenAccent.shade100 : Colors.white;
    final align =
        widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final icon = widget.delivered ? Icons.done_all : Icons.done;
    final radius = widget.isMe
        ? BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(Tela.de(context).abs(3.0)),
          padding: EdgeInsets.all(Tela.de(context).abs(8.0)),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: _conteudo(),
        ),
      ],
    );
  }

  List<Widget> _audioContent() {
    IconButton botao = botaoAudio();

    return [
      Padding(
        padding: EdgeInsets.only(
            right: Tela.de(context).x(48.0), top: Tela.de(context).y(0.0)),
        child: Text(
          widget.autor,
          style: TextStyle(color: Colors.blueGrey),
        ),
      ),
      Container(
        width: Tela.de(context).x(264),
        child: Row(
          children: <Widget>[
            botao,
            Slider(
                onChanged: (_) {
                  controleAudio(_);
                },
                min: 0,
                max: 1,
                value: pontoAudio,
                label: pontoAudio.toString())
          ],
        ),
      )
    ];
  }

  List<Widget> _linkContent() {
    return [
      Stack(
        children: <Widget>[
          Text(
            widget.autor,
            style: TextStyle(color: Colors.blueGrey),
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: Tela.de(context).y(5),
              ),
              IconButton(
                icon: Icon(
                  Icons.image,
                  size: 40,
                ),
                onPressed: widget.onTap,
              ),
              Text(
                'Abrir',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: Tela.de(context).abs(12),
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              )
            ],
          )
        ],
      )
    ];
  }

  List<Widget> _simpleContent() {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.autor,
            style: TextStyle(color: Colors.blueGrey),
          ),
          Text(widget.message)
        ],
      )
    ];
  }

  Widget _conteudo() {
    List<Widget> widgs = [];
    if (widget.audio)
      widgs = _audioContent();
    else if (widget.link != null)
      widgs = _linkContent();
    else
      widgs = _simpleContent();

    return Stack(
      children: widgs,
    );
  }

  void controleAudio(double _) async {
    setState(() {
      pontoAudio = _;
      if (playerState == AudioPlayerState.PLAYING) {
        pausarAudio();
        resumirAudio();
      }
    });
  }

  void pararAudio() async {
    player.stop();
  }

  void resumirAudio() async {
    player.seek(Duration(milliseconds: (pontoAudio * duracao).toInt()));
    player.resume();
  }

  void pausarAudio() async {
    player.pause();
  }

  void tocarAudio() async {
    player = new AudioPlayer();
    player.audioPlayerStateChangeHandler = (_) {
      setState(() {
        playerState = _;
      });
    };
    String tempDir = await DownloadUpload.tempDir();
    String audioPath = '$tempDir/${widget.message}';

    int resultado = await player.play(audioPath, isLocal: true);
    if (pontoAudio > 0 &&
        pontoAudio < 1 &&
        playerState != AudioPlayerState.COMPLETED) {
      player.seek(Duration(milliseconds: (pontoAudio * duracao).toInt()));
    }
    print('deu? $resultado');
    if (resultado == 1) {
      player.durationHandler = (_) {
        if (duracao != _.inMilliseconds) {
          setState(() {
            duracao = _.inMilliseconds;
          });
        }
      };
      player.completionHandler = () {
        setState(() {
          pontoAudio = 0;
        });
      };
      player.positionHandler = (_) {
        setState(() {
          if (duracao != 0)
            pontoAudio = _.inMilliseconds / duracao;
          else
            pontoAudio = 0;
        });
      };
    }
  }

  Widget botaoAudio() {
    IconButton botao;
    switch (playerState) {
      case AudioPlayerState.STOPPED:
        botao = IconButton(
          icon: Icon(Icons.play_circle_filled),
          onPressed: () {
            tocarAudio();
          },
        );
        break;
      case AudioPlayerState.PAUSED:
        botao = IconButton(
          icon: Icon(Icons.play_circle_filled),
          onPressed: () {
            resumirAudio();
          },
        );
        break;
      case AudioPlayerState.PLAYING:
        botao = IconButton(
          icon: Icon(Icons.pause_circle_filled),
          onPressed: () {
            pausarAudio();
          },
        );
        break;
      case AudioPlayerState.COMPLETED:
        botao = IconButton(
          icon: Icon(Icons.play_circle_filled),
          onPressed: () {
            tocarAudio();
          },
        );
        break;
    }
    return botao;
  }
}
