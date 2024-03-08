import 'package:flutter/material.dart';

class GuessesWidget extends StatelessWidget{
  final guessLeaves;
  final guessEnters;

  final enterSelected;
  final leaveSelected;
  final Function(int) switchSelectionCallback;

  const GuessesWidget({super.key, required this.guessEnters, required this.guessLeaves, required this.enterSelected, required this.leaveSelected, required this.switchSelectionCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.1),
        borderRadius: const BorderRadius.all(Radius.circular(40))
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Column(
        children: [
          GuessElement(guessNum: guessEnters, displayText: 'Felszáll: ', isSelected: enterSelected, switchSelectionCallback: switchSelectionCallback, num: 1,),
          const SizedBox(height: 20),
          GuessElement(guessNum: guessLeaves, displayText: 'Leszáll: ', isSelected: leaveSelected, switchSelectionCallback: switchSelectionCallback, num: 2,),
        ],
      ),
    );
  }
}

class GuessElement extends StatelessWidget{
  final guessNum;
  final displayText;
  final isSelected;
  final Function(int) switchSelectionCallback;
  final int num;


  const GuessElement({super.key, required this.guessNum, required this.displayText, required this.isSelected, required this.switchSelectionCallback, required this.num});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Flexible(child: Icon(Icons.tips_and_updates_outlined)),
        Expanded(
          flex: 3,
          child: Text(
            displayText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: TextButton(
            onPressed: (){
              switchSelectionCallback(num);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(isSelected ? .3 : .1)),
              foregroundColor: MaterialStateProperty.all(Colors.white)
            ),
            child: Text(
              '$guessNum db utas',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),
            ),
          )
        )
      ],
    );
  }
}