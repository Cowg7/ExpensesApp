import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_f/category_selection_widget.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => new _AddPageState();
}

class _AddPageState extends State<AddPage>{
  late String category;
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Categorias'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close,
            color: Colors.blueGrey,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        _categorySelector(),
        _currentValue(),
        _numPad(),
        _submit(),
      ],
    );
  }

  Widget _categorySelector () {
  return Container(
      height: 80.0,
      child: CategorySelectionWidget(
        categories: {
          "Compras": Icons.shopping_cart,
          "Salud": Icons.medical_services,
          "Comida": Icons.restaurant,
          "Servicios": Icons.home,
          "Vehículo": Icons.drive_eta,
          "Tarjetas": Icons.credit_card,
          "Bancos": Icons.account_balance,
          "Deporte": Icons.fitness_center,
          "Mascota": Icons.pets,
          "Diversión": Icons.party_mode,
          "Ahorros": Icons.savings,
          "Viajes": Icons.travel_explore_sharp,
          "Entretenimiento": Icons.movie,
          "Emergencias": Icons.emergency,
          "Otros": Icons.more_horiz_sharp,
        },
        onValueChanged: (newCategory) => category = newCategory,
      ),
    );
  }

  Widget _currentValue () {
    var realValue = value / 100.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35.0),
      child: Text("\$${realValue.toStringAsFixed(2)}",
        style: TextStyle(
          fontSize: 50.0,
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  //widget para establecer los numeros del pad y la accion que realiza
  Widget _num(String text, double height){
    return GestureDetector(
      behavior: HitTestBehavior.opaque,            //detectamos los gestos
      onTap: () {//accion que se realiza cuando se presiona el boton
        setState(() {
          if(text == " "){
            //NO BORRAR, SI SE BORRA SE CAE TODO xd
          }else{
            value = (value * 10 + int.parse(text));//obtenemos el valor del numero multiplicando 0*10 y le sumamos el valor del texto 
          }
        });
      },
      //diseño de los numeros del pad
      child: Container(
        height : height,
        child: Center(
            child: Text(
              text, 
              style: TextStyle(
                fontSize: 45,
                color: Colors.blueGrey,
            ),
          )
        ),
      ),
    );
  }

  Widget _numPad (){
    return Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          var height = constraints.biggest.height / 4;
        return Table(
          border: TableBorder.all(
            color: Colors.blueGrey,
            width: 1.0,
            borderRadius: BorderRadius.circular(10)
          ),
          children: [
            TableRow(
              children: [
                _num("1", height),
                _num("2", height),
                _num("3", height),
              ]
            ),
            TableRow(
              children: [
                _num("4", height),
                _num("5", height),
                _num("6", height),
              ]
            ),
            TableRow(
              children: [
                _num("7", height),
                _num("8", height),
                _num("9", height),
              ]
            ),
            TableRow(
              children: [
                _num(" ", height),
                _num("0", height),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,  
                  onTap: () {
                    setState(() {
                      value = (value ~/ 10);//obtenemos el valor del numero dividiendo entre 10 
                    });
                  },
                  child: Container(
                    height: height,
                    child: Center(
                      child: Icon(
                        Icons.backspace,
                        color: Colors.blueGrey,
                        size: 45.00,
                        ),
                      ),
                  ),
                ),
              ])
          ],
        );
      }),
    );
  }

  Widget _submit (){
    return Container(
      height: 50.00,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueAccent),
      child: MaterialButton(
        child: Text("Añadir",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.00
            ),
          ),
          onPressed: () {
            if (value > 0 && category != " "){
              FirebaseFirestore.instance
                .collection('expenses')
                .doc()
              .set({
                "category": category,
                "value": value/100,
                "month": DateTime.now().month,
                "day": DateTime.now().day,
              });
              Navigator.of(context).pop();
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content:Text("Ingresa un monto y selecciona una categoria")
              ));
            }
          },
      ),
    );
  }
}