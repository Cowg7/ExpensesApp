import 'package:flutter/material.dart';

class CategorySelectionWidget extends StatefulWidget{
  final Map<String, IconData> categories;
  final Function(String) onValueChanged;

  const CategorySelectionWidget({super.key, required this.categories, required this.onValueChanged});

  @override
  _CategorySelectionWidgetState createState() => _CategorySelectionWidgetState();
}

class CategoryWidget extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool selected;

  const CategoryWidget({super.key, required this.name, required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: selected ? Colors.blueAccent : 
                Colors.grey,
                width: selected ? 3 : 1,
              )
            ),
            child: Icon(icon),
          ),
          Text(name)
        ],
      ),
    ); // TODO implement widget
  }
}

class _CategorySelectionWidgetState extends State<CategorySelectionWidget>{
  String currentItem = 'Compras';
  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    widget.categories.forEach((name, icon){
      widgets.add(
        GestureDetector(
          onTap: (){
            setState(() {
              currentItem = name;
            });
            widget.onValueChanged(name);
          },
          child: CategoryWidget(
            name: name,
            icon: icon,
            selected: name == currentItem,
          ),
        )
      );
    });
    return ListView(
      scrollDirection: Axis.horizontal,
      children: widgets,
    );
  }
}