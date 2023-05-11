import 'package:flutter/material.dart';

class SelectionState extends ChangeNotifier {

  List<int> isSelectedSort = [0,0,0,0];
  int mainIndexSort = -1;
  int mainIndexCategories = -1;
  List<int> get isSelected => isSelectedSort;
 
  void updateSelection(int index) {
    mainIndexSort = index;
    isSelectedSort= [0,0,0,0];
    isSelectedSort[index] = isSelectedSort[index] == 0 ? 1 : 0;
    notifyListeners();
  }

  int getIndex(){
    return mainIndexSort;
  }

  
 
  void updateIndexCategories(int index) {
    mainIndexCategories = index;
    notifyListeners();
  }

  int getIndexCategories(){
    return mainIndexCategories;
  }
}

