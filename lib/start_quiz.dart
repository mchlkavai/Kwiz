import 'package:flutter/material.dart';
import 'package:kwiz/take_quiz.dart';
import 'package:kwiz/services/database.dart';
import 'package:kwiz/Models/quizzes.dart';

class StartQuiz extends StatefulWidget {
  //This global variable will be passed onto the take_quiz screen
  final String chosenQuiz;
  const StartQuiz({super.key, required this.chosenQuiz});
  @override
  StartQuizState createState() => StartQuizState();
}

class StartQuizState extends State<StartQuiz> {
  late String info = '';
  late String category = '';
  late String title = '';
  late String dateCreated = '';
  String date = '';
  late String quizID = widget.chosenQuiz;
  bool _isLoading = true;
  DatabaseService service =
      DatabaseService(); //This database service allows me to use all the functions in the database.dart file

//Depending on the quiz chosen by the user on the previous page, this loads the quiz's information namely its title and description
  Future<void> loaddata() async {
    Quiz? details;
    details = await service.getQuizInformationOnly(quizID: quizID);
    title = details!.quizName;
    info = details.quizDescription;
    category = details.quizCategory;
    dateCreated = details.quizDateCreated;
    date = dateCreated.substring(0, 10);
  }

//This ensures that the quiz information and category image/gif have loaded
  @override
  void initState() {
    super.initState();
    _startLoading();
    loaddata().then((value) {
      setState(() {});
    });
  }

//Used to control the Circular Progress indicator
  void _startLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 57, 82),
      resizeToAvoidBottomInset: false,
      appBar: _isLoading
          ? null
          :AppBar(
        title: Text(
          title,
          style: const TextStyle(
              fontFamily: 'TitanOne',
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        backgroundColor: const Color.fromARGB(255, 27, 57, 82),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      //The entire body is wrapped with a SingleChild Scroll view that ensures that the page is scrollable vertically so that the user can always see all the components
      body: _isLoading 
          ? const Center(
              child: CircularProgressIndicator(),
            )
          :SafeArea(
        child: SingleChildScrollView(
          child: Container(
            //The entire body is wrapped with a container so that we can get the background with a gradient effect
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 27, 57, 82),
                  Color.fromARGB(255, 5, 12, 31),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 5, left: 5, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                            //This loads the gif repsective to the quiz's category
                            'assets/images/$category.gif',
                            height: 500,
                            width: 500,
                            scale: 0.5,
                            opacity:
                                const AlwaysStoppedAnimation<double>(
                                    1)),
                  ),
                  //This container displays the selected quiz's information and the start button
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: const Color.fromARGB(255, 45, 64, 96),
                    ),
                    padding: const EdgeInsets.fromLTRB( 15,10,15,0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //This widget displays the quiz's title
                          Text(
                            title,
                            style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                decoration: TextDecoration.underline),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            //This widget displays the quiz's information
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                text: info,
                                style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 28,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          // RichText(
                          //   textAlign: TextAlign.left,
                          //   //This widget displays the date the quiz was created
                          //   text: TextSpan(
                          //     text: 'Date Created: $date',
                          //     style: const TextStyle(
                          //         fontFamily: 'Nunito',
                          //         fontSize: 26,
                          //         fontWeight: FontWeight.w400,
                          //         color: Colors.white),
                          //   ),
                          // ),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.orange,
                                    Colors.deepOrange
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50)),
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal),
                                ),
                                //This event takes us to the take_quiz screen
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            QuizScreen(quizID)),
                                  );
                                },
                                child: const Text(
                                  'Start',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
