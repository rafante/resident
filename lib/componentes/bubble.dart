import 'package:resident/imports.dart';

class Bubble extends StatelessWidget {
  Bubble(
      {this.message,
      this.time,
      this.delivered,
      this.isMe,
      this.autor,
      this.onTap,
      this.link});

  final String message, time;
  final String autor;
  final Function onTap;
  final delivered, isMe;
  final bool link;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.greenAccent.shade100 : Colors.white;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
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
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      right: Tela.de(context).x(48.0),
                      top: Tela.de(context).y(15.0)),
                  child: Text(
                    message,
                    style: TextStyle(
                        color: link ? Colors.blueAccent : Colors.black,
                        decoration: link
                            ? TextDecoration.underline
                            : TextDecoration.none),
                  ),
                ),
                Positioned(
                  bottom: Tela.de(context).y(0.0),
                  right: Tela.de(context).x(0.0),
                  child: Row(
                    children: <Widget>[
                      Text(time,
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: Tela.de(context).abs(10.0),
                          )),
                      SizedBox(width: Tela.de(context).x(3.0)),
                      Icon(
                        icon,
                        size: Tela.de(context).abs(12.0),
                        color: Colors.black38,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: Tela.de(context).x(48.0),
                      top: Tela.de(context).y(0.0)),
                  child: Text(
                    autor,
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class BubbleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .9,
        title: Text(
          'Putra',
          style: TextStyle(color: Colors.green),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.green,
          ),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.videocam,
              color: Colors.green,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.call,
              color: Colors.green,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.green,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Bubble(
              message: 'Hi there, this is a message',
              time: '12:00',
              delivered: true,
              isMe: false,
            ),
            Bubble(
              message: 'Whatsapp like bubble talk',
              time: '12:01',
              delivered: true,
              isMe: false,
            ),
            Bubble(
              message: 'Nice one, Flutter is awesome',
              time: '12:00',
              delivered: true,
              isMe: true,
            ),
            Bubble(
              message: 'I\'ve told you so dude!',
              time: '12:00',
              delivered: true,
              isMe: false,
            ),
          ],
        ),
      ),
    );
  }
}
