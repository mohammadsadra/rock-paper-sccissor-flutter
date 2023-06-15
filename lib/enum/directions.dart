import 'package:flutter/foundation.dart';

enum Directions {
  top,
  bottom,
  // left,
  // right,
  // topRight,
  // topLeft,
  // bottomRight,
  // bottomLeft
}

extension DisplayName on Directions {
  String get name => describeEnum(this);
  String get displayTitle {
    switch (this) {
      case Directions.top:
        return 'top';
      case Directions.bottom:
        return 'bottom';
      // case Directions.left:
      //   return 'left';
      // case Directions.right:
      //   return 'right';
      // case Directions.topRight:
      //   return 'topRight';
      // case Directions.topLeft:
      //   return 'topLeft';
      // case Directions.bottomRight:
      //   return 'bottomRight';
      // case Directions.bottomLeft:
      //   return 'bottomLeft';
      default:
        return 'none';
    }
  }
}
