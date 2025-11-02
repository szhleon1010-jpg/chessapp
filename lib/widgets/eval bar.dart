import 'package:flutter/material.dart';

class EvalBar extends StatelessWidget {
  final int score;
  final bool mate;
  const EvalBar({super.key, required this.score, required this.mate});
  double _normalizeScore(int score) {
    if(mate){
      return (score >=0) ? 1 : 0 ;
    }
    // Clamp between -1000 and +1000 cp
    double eval = score.toDouble().clamp(-1000, 1000);
    // Convert to 0–1, where 1 = white completely winning
    return (eval + 1000) / 2000;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      child: Stack(
        children: [
          Container(color: Colors.black,),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedFractionallySizedBox(
              duration: Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              alignment: Alignment.bottomCenter,
              heightFactor: _normalizeScore(score),
                child: Container(color: Colors.white,)
            )
          )
        ],
      ),
    );
  }
}
