import 'package:chat_app/dependencies_injection.dart';
import 'package:chat_app/helper/network/socket_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:uuid/uuid.dart';

enum CallState {
  CallStateNew,
  CallStateRinging,
  CallStateInvite,
  CallStateConnected,
  CallStateBye,
}

class Session {
  Session({required this.sid, required this.pid});
  String pid;
  String sid;
  RTCPeerConnection? pc;
  RTCDataChannel? dc;
  // List<RTCIceCandidate> remoteCandidates = [];
}

class MySignaling {
  final String url;
  final Map<String, Session> _sessions = {};
  final _selfId = const Uuid().v4();
  final SocketService _socket = sl<SocketService>();

  MySignaling(this.url);

  Function(Session session, CallState state)? onCallStateChange;
  Function(Map<String, dynamic> event)? onPeersUpdate;
  Function(MediaStream stream)? onLocalStream;
  Function(Session session, MediaStream stream)? onAddRemoteStream;
  Function(Session session, MediaStream stream)? onRemoveRemoteStream;

  void close() {}

  Future<void> connect() async {}

  void accept(String sid) {
    var session = _sessions[sid];
    if (session == null) {
      return;
    }
    // _createAnswer(session);
  }

  void reject(String sid) {
    var session = _sessions[sid];
    if (session == null) {
      return;
    }
    bye(session.sid);
  }

  void bye(String sid) {
    _send('bye', {
      'session_id': sid,
      'from': _selfId,
    });
    var sess = _sessions[sid];
    if (sess != null) {
      _closeSession(sess);
    }
  }

  void _send(event, data) {
    var request = {
      'type': event,
      'data': data,
    };
    _socket.emit('STREAM_SEND', data);
  }

  _closeSession(Session sess) {

  }
}
