import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_f/graph_widget.dart';

class MonthWidget extends StatefulWidget {
  @override
  final List<DocumentSnapshot> docs;
  final double total;
  final List<double> perDay;
  final Map<String, double> categorias;

  MonthWidget({Key? key, required this.docs}) : 
    total = docs.map((doc) => doc['value']) //para validar e iniciar el total
            .fold(0.0, (a, b) => a+b), //hace la sumatoria del total
    perDay = List.generate(31, (int index){
              return docs.where((doc) => doc['day'] == (index + 1)) //el doc y where son filtrados en memoria (no en la query)
              .map((doc) => doc['value']) //para validar e iniciar el total
            .fold(0.0, (a, b) => a+b); //hace la lista de 31 dias
            }),
    categorias = docs.fold({}, (Map<String, double>map, docs){
            if(!map.containsKey(docs['category'])){
              map[docs['category']] = 0.0;
            }

            double? categoryValue = map[docs['category']];
            var docValue = docs['value'];
            double sum = categoryValue! + docValue;

            map[docs['category']] = sum;
            return map;
    }),
    super (key: key);

  _MontWidgetState createState() => _MontWidgetState();
}

class _MontWidgetState extends State<MonthWidget>{
  @override
  Widget build(BuildContext context) {
    print(widget.categorias);
    return Expanded(
      child: Column(
        children: <Widget>[
            _expenses(), //se llama al widget de gastos creado
            _graph(), //se llama al widget del grafico creado
            //separador del graficpo y la lista de categorias
            Container(
              color: Colors.blueAccent.withOpacity(0.15),//color del separador
              height: 24.0,//grosor del separador
            ),
            _list(),
        ],
      ),
    );
  }

  Widget _expenses() {
    return Container(
      child: Column(
          children: <Widget>[
          Text("\$${widget.total.toStringAsFixed(2)}",//llamamos al total y le mandamos el valor de la db
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40.0,
            ),
          ),
          Text("Total Gastos",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: const Color.fromARGB(255, 22, 171, 245),
            ),
          ),
        ],
      ),
    );
  }


  //widgety del grafico
  Widget _graph() {
    return Container(
      height: 250.0,
      alignment: Alignment.bottomCenter,
      child: GraphWidget(
        data: widget.perDay,//le pasamos los datos que sacamos de la query
      ),
    );
  }

  //widget de los items de la lista
  Widget _item(IconData icon, String nombre, int percent, double value){
    return ListTile(
      leading: Icon(icon, size: 42.0),
      title: Text(nombre,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0
                  ),
                ),
      subtitle: Text("$percent% de gastos", 
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blueGrey,
                  ),
                ),
      trailing: Text("\$$value", style: 
                TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey,
                ),
              ),
    );
  }

  //widget de las categorias de la lista
  Widget _list() {
    return Expanded(
      child: ListView.separated( // para poner los separadores
        itemCount: widget.categorias.keys.length, // cantidad de items en la lista 
        itemBuilder: (BuildContext context, int index){
                    var key = widget.categorias.keys.elementAt(index);
                    var data = widget.categorias[key];
                    //key=categoria, 100*data! ~/ es para sacar el porcentaje de gastos, data=total del gasto
                    return _item(Icons.attach_money_sharp, key, (100 * data! ~/ widget.total), data);// crea los datos de la lista de categorias
                    }, 
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.blueAccent.withOpacity(0.15),//color del separador
            height: 8.0,//grosor del separador
          );
        },
      ),
    );
  }

}