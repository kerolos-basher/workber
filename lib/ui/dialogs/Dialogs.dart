import 'dart:async';

import 'package:berry_market/ui/dialogs/MessageDialog.dart';
import 'package:berry_market/utilities/Anims.dart';
import 'package:berry_market/utilities/General.dart';
import 'package:berry_market/utilities/NotificationMsg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class Dialogs {
  static Future<bool> showMessageDialog(
      BuildContext context, String title, String msg,
      [final yesConfirm]) async {
    return await showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return MessageDialog(title, msg, yesConfirm);
        },
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.4),
        barrierLabel: '',
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
            scale: anim1.value,
            child: Opacity(
              opacity: anim1.value,
              child: child,
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300));
  }

  static showNotiMsg(BuildContext context, String msg,
      {int secEndDuration = 4}) {
    Playback playback = Playback.PLAY_FORWARD;

    if (General.overly != null) {
      try {
        General.overly.remove();
      } catch (e) {}
    }
    General.overly = OverlayEntry(builder: (context) {
      return Scale(
        playback: playback,
        alignment: Alignment.bottomCenter,
        child: NotificationMsgAlert(msg ?? ""),
      );
    });

    Navigator.of(context).overlay.insert(General.overly);
    int oldHash = General.overly.hashCode;
    Timer(Duration(seconds: secEndDuration), () {
      if (General.overly.hashCode == oldHash) {
        playback = Playback.PLAY_REVERSE;
        General.overly?.markNeedsBuild();
        Timer(Duration(milliseconds: 600), () {
          General.overly.remove();
          General.overly = null;
        });
      }
    });
  }
}
