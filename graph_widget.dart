import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class GraphWidget extends StatefulWidget {
  final List<double> data;

  const GraphWidget({Key? key, required this.data}) : super(key: key);
  @override
  _GraphWidgetState createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    var time;
    final measures = <String, double>{};

    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures['Gasto'] = datumPair.datum;
      });
    }

    print(time);
    print(measures);

    // Request a build.
    //setState(() {
    //_time = time;
    //_measures = measures;
    //});
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<double, int>> series = [
      charts.Series<double, int>(
        id: 'Gasto',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (value, index) => index ?? 0, // eje x
        measureFn: (value, _) => value, // eje y
        data: widget.data, // datos
        strokeWidthPxFn: (_, __) => 4, //grosor linea grafico
      ) 
    ];

    return charts.LineChart(series,
      animate: false,
      //modelo para seleccionar los puntos del grafico
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
      //se meustran los dias en el eje x en un intervalo de 5 dias
      domainAxis: charts.NumericAxisSpec(
          tickProviderSpec: charts.StaticNumericTickProviderSpec(
              [
                charts.TickSpec(0, label: '01'),
                charts.TickSpec(4, label: '05'),
                charts.TickSpec(9, label: '10'),
                charts.TickSpec(14, label: '15'),
                charts.TickSpec(19, label: '20'),
                charts.TickSpec(24, label: '25'),
                charts.TickSpec(29, label: '30'),
              ]
          )
      ),
      // se divide en 4 el eje y para mostrar la cantidad
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 4,
        ),
      ),
    );
  }
}
