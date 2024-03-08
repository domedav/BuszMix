import 'dart:ui';
import 'package:buszmix/guesses_widget.dart';
import 'package:buszmix/mix_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{

  Future<void> saveInt(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }
  Future<int?> getInt(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color.fromRGBO(0x2A, 0x2A, 0x2A, 1.0), // navigation bar color
      statusBarColor: Color.fromRGBO(0x12, 0x12, 0x12, 1.0), // status bar color
    ));

    Future.delayed(Duration.zero, ()async{
      final num = await getInt('guessStreak');
      setState(() {
        guessStreak = num ?? 0;
      });
    });
  }

  void doGuess(){
    HapticFeedback.lightImpact();
    setState(() {
      showBlur = true;
    });
  }

  void mixGuessResult(bool win){
    HapticFeedback.lightImpact();
    setState(() {
      enterParse = '';
      leaveParse = '';
      guessLeaves = 0;
      guessEnters = 0;
      showBlur = false;
      if(win){
        guessStreak++;
        saveInt('guessStreak', guessStreak);
      }
      else{
        guessStreak = 0;
        saveInt('guessStreak', 0);
      }
    });
  }

  int guessEnters = 0;
  int guessLeaves = 0;

  int guessStreak = 0;

  bool enterSelected = true;
  bool leaveSelected = false;

  String enterParse = '';
  String leaveParse = '';

  bool showBlur = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              verticalDirection: VerticalDirection.up,
              children: [
                GuessInputField(callback: (button){
                  if(button == -1){
                    setState(() {
                      changeSelectedString('0');
                      changeSelected(0);
                    });
                    return;
                  }
                  else if(button == -2){
                    setState(() {
                      if(getSelectedString().length == 1){
                        changeSelectedString('0');
                        changeSelected(0);
                        return;
                      }
                      changeSelectedString(getSelectedString().substring(0, getSelectedString().length - 1));
                      setState(() {
                        changeSelected(int.parse(getSelectedString()));
                      });
                    });
                    return;
                  }

                  changeSelectedStringAdd('$button');
                  setState(() {
                    changeSelected(int.parse(getSelectedString()));
                  });
                }),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Tipped meg mizu lesz!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900
                              ),
                            ),
                          ),
                        ),
                        GuessesWidget(guessEnters: guessEnters, guessLeaves: guessLeaves, enterSelected: enterSelected, leaveSelected: leaveSelected, switchSelectionCallback: (press){
                          if(press == 1 && enterSelected){
                            return;
                          }
                          else if(press == 2 && leaveSelected){
                            return;
                          }
                  
                          setState(() {
                            enterSelected = !enterSelected;
                            leaveSelected = !leaveSelected;
                          });
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                          child: FilledButton(
                            onPressed: (){
                              doGuess();
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              backgroundColor: MaterialStateProperty.all(Colors.green.withOpacity(.5))
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.done_rounded,
                                    size: 32,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Tipp',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700
                                    ),
                                  )
                                ],
                              ),
                            )
                          ),
                        ),
                        Visibility(
                          visible: guessStreak > 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                            child: Text(
                              'Tipp streak: $guessStreak',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 22,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: showBlur,
              child: Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 13, sigmaY: 13),
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: showBlur,
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: const BorderRadius.all(Radius.circular(40))
                  ),
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Na, bejött?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 32
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.tips_and_updates_rounded),
                          const SizedBox(width: 8),
                          Text(
                            'Felszáll: $guessEnters ember',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.tips_and_updates_rounded),
                          const SizedBox(width: 8),
                          Text(
                            'Leszáll: $guessLeaves ember',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FilledButton(
                            onPressed: (){
                              mixGuessResult(false);
                            },
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                                backgroundColor: MaterialStateProperty.all(Colors.red.withOpacity(.6))
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: const Text(
                                'Nem',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700
                                ),
                              )
                            )
                          ),
                          FilledButton(
                              onPressed: (){
                                mixGuessResult(true);
                              },
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(Colors.white),
                                  backgroundColor: MaterialStateProperty.all(Colors.green.withOpacity(.6))
                              ),
                              child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: const Text(
                                    'Igen',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700
                                    ),
                                  )
                              )
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  void changeSelected(int val){
    HapticFeedback.lightImpact();
    setState(() {
      if(enterSelected){
        guessEnters = val;
        return;
      }
      guessLeaves = val;
    });
  }

  String getSelectedString(){
    if(enterSelected){
      return enterParse.substring(0, enterParse.length > 8 ? 8 : enterParse.length);
    }
    return leaveParse.substring(0, leaveParse.length > 8 ? 8 : leaveParse.length);
  }

  void changeSelectedString(String str){
    HapticFeedback.lightImpact();
    if(enterSelected){
      enterParse = str;
      return;
    }
    leaveParse = str;
  }
  void changeSelectedStringAdd(String str){
    HapticFeedback.lightImpact();
    if(enterSelected){
      if(enterParse == '0' && str == '0'){
        return;
      }
      enterParse += str;
      return;
    }
    if(leaveParse == '0' && str == '0'){
      return;
    }
    leaveParse += str;
  }

}