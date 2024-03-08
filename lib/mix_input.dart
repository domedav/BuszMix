import 'package:flutter/material.dart';

class GuessInputField extends StatelessWidget{
  const GuessInputField({super.key, required this.callback});

  final Function(int) callback;

  void buttonPressed(int button){
    callback(button);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.1),
          borderRadius: const BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40))
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                GuessInputElement(num: 1, callback: buttonPressed),
                GuessInputElement(num: 2, callback: buttonPressed),
                GuessInputElement(num: 3, callback: buttonPressed),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                GuessInputElement(num: 4, callback: buttonPressed),
                GuessInputElement(num: 5, callback: buttonPressed),
                GuessInputElement(num: 6, callback: buttonPressed),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                GuessInputElement(num: 7, callback: buttonPressed),
                GuessInputElement(num: 8, callback: buttonPressed),
                GuessInputElement(num: 9, callback: buttonPressed),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                GuessInputElementIcon(num: -1, callback: buttonPressed, icon: Icons.clear_outlined,),
                GuessInputElement(num: 0, callback: buttonPressed),
                GuessInputElementIcon(num: -2, callback: buttonPressed, icon: Icons.backspace_outlined,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GuessInputElement extends StatelessWidget{
  const GuessInputElement({super.key, required this.callback, required this.num});

  final Function(int) callback;
  final int num;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 6,
      height: MediaQuery.of(context).size.width / 6,
      child: TextButton(
        onPressed: (){
          callback(num);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(.1)),
          foregroundColor: MaterialStateProperty.all(Colors.white)
        ),
        child: Text(
          '$num',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18
          ),
        )
      ),
    );
  }
}

class GuessInputElementIcon extends StatelessWidget{
  const GuessInputElementIcon({super.key, required this.callback, required this.num, required this.icon});

  final Function(int) callback;
  final int num;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 6,
      height: MediaQuery.of(context).size.width / 6,
      child: TextButton(
          onPressed: (){
            callback(num);
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(.1)),
              foregroundColor: MaterialStateProperty.all(Colors.white)
          ),
          child: Icon(
            icon,
          )
      ),
    );
  }
}