import 'package:flutter/material.dart';
import 'package:kwiz/pages/viewquizzes/view_quizzes.dart';
import 'package:kwiz/services/database.dart';

class ViewCategories extends StatefulWidget {
  const ViewCategories({super.key});

  @override
  //State<ViewCategoriesScreen> createState() => ViewCategoriesState();
  ViewCategoriesState createState() => ViewCategoriesState();
}

class ViewCategoriesState extends State<ViewCategories> {
  DatabaseService service = DatabaseService();
  List? categories;
  int catLength = 0;
  List? _displayedItems = [];
  int fillLength = 0;

  final TextEditingController _controller = TextEditingController();
//Loading Data from the database
  Future<void> loaddata() async {
    categories = await service.getCategories();
    categories!.insert(0, 'All');
    catLength = categories!.length;
    _displayedItems = categories;
    fillLength = _displayedItems!.length;
  }

//This ensures that category tiles are populated and that we can search for a category
  @override
  void initState() {
    super.initState();
    _displayedItems = categories;
    loaddata().then((value) {
      setState(() {});
    });
  }

//We dispose the controller to ensure that the relevant tiles that match the search term in the serach bar appear
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//This method is used o control the search bar
  void _onSearchTextChanged(String text) {
    setState(() {
      _displayedItems = categories!
          .where((item) => item.toLowerCase().contains(text.toLowerCase()))
          .toList();
      fillLength = _displayedItems!.length;
    });
  }

  bool shadowColor = false;
  double? scrolledUnderElevation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 57, 82),
      appBar: _displayedItems == null ? null :AppBar(
        title: const Text(
          'Catalogue',
          style: TextStyle(
              fontFamily: 'TitanOne',
              fontSize: 45,
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
      resizeToAvoidBottomInset: false,
      //This condition diplays a circular progress indiactor that will appear untill all categories are displayed
      body: _displayedItems == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              //The entire body is wrapped with a container so that we can get the background with a gradient effect
              child: Container(
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        //This text field was modified such that it functions as a search bar
                        child: TextField(
                          controller: _controller,
                          onChanged: _onSearchTextChanged,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 45, 64, 96),
                            hintText: 'Search Catalogue',
                            hintStyle: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.search,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: const BorderSide(
                                  width: 50, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        //This GridView diplays all available categories as tiles
                        child: GridView.builder(
                            itemCount: fillLength,
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              //This methpd allows us to move to the next page depending on which tile (category) the user picks
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewQuizzes(
                                            chosenCategory:
                                                _displayedItems?[index])),
                                  );
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Colors.red,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromARGB(255, 230, 131, 44),
                                          Color.fromARGB(255, 244, 112, 72),
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 50, 0, 0),
                                      child: Column(
                                        children: [
                                          Text(
                                            _displayedItems?[index],
                                            style: TextStyle(
                                                fontFamily: 'Nunito',
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                                    .withOpacity(1.0)),
                                          ),
                                          const SizedBox(height: 10),
                                          //This loads an icon respective to the category
                                          Image.asset(
                                              '${'assets/images/' + _displayedItems?[index]}.png',
                                              height: 48,
                                              width: 48,
                                              scale: 0.5,
                                              opacity:
                                                  const AlwaysStoppedAnimation<
                                                      double>(1)),
                                        ],
                                      ),
                                    )),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
