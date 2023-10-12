import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore, QuerySnapshot;
import 'package:proyecto_f/mont_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  late PageController _controller;
  int currentPage = 9;
  Stream<QuerySnapshot>? _query;

  @override
  void initState(){
    super.initState();
    _query = FirebaseFirestore.instance
            .collection('expenses')
            .where("month", isEqualTo: currentPage + 1)
            .snapshots();

  

    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );
  }  
  
  Widget _bottomAction(IconData icon){
    return InkWell(
      child: Padding(padding: const EdgeInsets.all(8.0), //sombreado botones
      child: Icon(icon), //para mostrar los iconos
      ),
      onTap: (){}, // se muestra la sombra al tocar los botones
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row( //creamos la fila de abajo para los botones
          mainAxisSize: MainAxisSize.max, //les damos el tamaño max
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, //los alineamos para que quede el mismo espacio entre cada uno
          children: <Widget>[ //creamos los widgets(botones)
          _bottomAction(Icons.history),//boton 1
          _bottomAction(Icons.pie_chart),//boton 2
          SizedBox(width: 48.0,),//añadimos boton vacio para que quede bien el boton añadir
          _bottomAction(Icons.wallet),//boton 3
          _bottomAction(Icons.settings),
          ],//boton 4
        ), 
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,//centramos el boton de añadir
        floatingActionButton: FloatingActionButton(//le ponemos accion al boton
          child: Icon(Icons.add),//mostramos el icono del boton
          onPressed: () {
            Navigator.of(context).pushNamed('/add');
          },//funcion que se hace al presionar
        ),
        body: _body(),
    );
  }

  Widget _body(){
    return SafeArea(//para no tocar el area del notch del dispositivo
      child: Column(//todo el body de la app
        children: <Widget>[
          _selector(),
          StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data){
              if(data.hasData){
                return MonthWidget(
                  docs: data.data!.docs,
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }, 
          ),
        ],
      ),
    );
  }

  Widget _pageItem(String nombre, int position){
    //variable para alinear
    var _alignment;

    //definimos el estilo del mes segun este la pagina seleccionada
    final selected = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight. bold,
    color: Colors. blueGrey,
    );
    //estilo para la pagina no seleccionada
    final unselected = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight. normal,
    color: Colors. blueGrey.withOpacity(0.4),
    );


    //si la pos es igual, se centra
    if (position == currentPage){
      _alignment = Alignment.center;
    }
    //si es mayor a la pagina act, se centra a la der (el que sigue se centra a la der)
    else if (position > currentPage){
      _alignment = Alignment.centerRight;
    }    
    // si no, se centra a la izq (el que sigue se centra a la izq)
    else{
      _alignment = Alignment.centerLeft;
    }

    return Align(
      alignment: _alignment,
      child: Text(nombre, 
                  style: position == currentPage ? selected : unselected),
    );
  }

//widget para seleccionar mes
  Widget _selector(){
    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage){
          setState(() {
            currentPage = newPage; //actualiza la pagina actual
            _query = FirebaseFirestore.instance
            .collection('expenses')
            .where("month", isEqualTo: currentPage + 1)
            .snapshots();
          });
        },
        controller: _controller,
        children: <Widget>[
          _pageItem("Enero",0),
          _pageItem("Febrero",1),
          _pageItem("Marzo",2),
          _pageItem("Abril",3),
          _pageItem("Mayo",4),
          _pageItem("Junio",5),
          _pageItem("Julio",6),
          _pageItem("Agosto",7),
          _pageItem("Septiembre",8),
          _pageItem("Octubre",9),
          _pageItem("Noviembre",10),
          _pageItem("Diciembre",11),
        ],
      ),
    );
  }
}