import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Paquete de Syncfusion para gráficos

class GraficaScreen extends StatefulWidget {
  const GraficaScreen({super.key});

  @override
  _GraficaScreenState createState() => _GraficaScreenState();
}

class _GraficaScreenState extends State<GraficaScreen> {
  Map<String, dynamic>? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> document = await FirebaseFirestore.instance
          .collection('datos')
          .doc('sAxmCjvcqQTh7kAonfYv') // Reemplaza con tu ID de documento
          .get();

      setState(() {
        data = document.data();
        isLoading = false;
      });
    } catch (e) {
      print('Error obteniendo los datos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráficas Deslizables'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data != null
              ? PageView(
                  children: [
                    _buildBarChart(), // Gráfico de barras: Cantidad por Día
                    _buildLineChart(), // Gráfico de líneas: Cantidad por Día y Hora
                    _buildRadialBarChart(), // Gráfico radial: Cantidad por Día
                  ],
                )
              : const Center(
                  child: Text('No hay datos disponibles'),
                ),
    );
  }

  // Gráfico de barras mostrando la cantidad de alimentos por día
  Widget _buildBarChart() {
    List<BarChartData> barData = [
      BarChartData('Lunes', 200, const Color.fromARGB(255, 199, 118, 219)),
      BarChartData('Martes', 150, const Color.fromARGB(255, 0, 140, 255)),
      BarChartData('Miércoles', 100, const Color.fromARGB(255, 248, 59, 255)),
      BarChartData('Jueves', 250, const Color.fromARGB(255, 76, 119, 175)),
      BarChartData('Viernes', 300, Colors.blue),
      BarChartData('Sábado', 400, Colors.indigo),
      BarChartData('Domingo', 350, Colors.purple),
    ];

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        height: 300, // Ajusta la altura aquí para hacerla más pequeña
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(text: 'Cantidad de Alimentos por Día'),
          legend: Legend(isVisible: false),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            ColumnSeries<BarChartData, String>(
              dataSource: barData,
              xValueMapper: (BarChartData data, _) => data.day,
              yValueMapper: (BarChartData data, _) => data.amount,
              name: 'Cantidad',
              dataLabelSettings: DataLabelSettings(isVisible: true),
              pointColorMapper: (BarChartData data, _) => data.color, // Asigna el color desde los datos
            ),
          ],
        ),
      ),
    );
  }

  // Gráfico de líneas mostrando la cantidad de alimentos por día y hora
  Widget _buildLineChart() {
    List<BarChartData> hourlyData = [
      BarChartData('Lunes\n08:00', 200, Colors.purpleAccent),
      BarChartData('Lunes\n12:00', 150, Colors.purpleAccent),
      BarChartData('Martes\n08:00', 180, Colors.purpleAccent),
      BarChartData('Martes\n12:00', 120, Colors.purpleAccent),
      BarChartData('Miércoles\n08:00', 160, Colors.purpleAccent),
      BarChartData('Miércoles\n12:00', 140, Colors.purpleAccent),
      BarChartData('Jueves\n08:00', 220, Colors.purpleAccent),
      BarChartData('Jueves\n12:00', 130, Colors.purpleAccent),
      BarChartData('Viernes\n08:00', 250, Colors.purpleAccent),
      BarChartData('Viernes\n12:00', 270, Colors.purpleAccent),
      BarChartData('Sábado\n08:00', 300, Colors.purpleAccent),
      BarChartData('Sábado\n12:00', 320, Colors.purpleAccent),
      BarChartData('Domingo\n08:00', 280, Colors.purpleAccent),
      BarChartData('Domingo\n12:00', 290, const Color.fromARGB(255, 64, 114, 251)),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(text: 'Cantidad de Alimentos por Día y Hora'),
        legend: Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries>[
          LineSeries<BarChartData, String>(
            dataSource: hourlyData,
            xValueMapper: (BarChartData data, _) => data.day,
            yValueMapper: (BarChartData data, _) => data.amount,
            name: 'Cantidad',
            dataLabelSettings: DataLabelSettings(isVisible: true),
            color: Colors.purpleAccent, // Color del gráfico
          ),
        ],
      ),
    );
  }

  // Gráfico radial mostrando la cantidad de alimentos por día
  Widget _buildRadialBarChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCircularChart(
        title: ChartTitle(text: 'Gráfico Radial de Alimentos por Día'),
        legend: Legend(isVisible: true),
        series: <CircularSeries>[
          RadialBarSeries<BarChartData, String>(
            dataSource: _createBarChartData(),
            xValueMapper: (BarChartData data, _) => data.day,
            yValueMapper: (BarChartData data, _) => data.amount,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            maximumValue: 400, // Ajusta según tus datos
            radius: '80%',
            pointColorMapper: (BarChartData data, _) {
              // Mapeo de colores para cada porción del gráfico radial
              return data.day == 'Lunes' ? const Color.fromARGB(255, 60, 153, 230) :
                     data.day == 'Martes' ? Colors.purple :
                     data.day == 'Miércoles' ? Colors.blueAccent :
                     data.day == 'Jueves' ? Colors.purpleAccent :
                     data.day == 'Viernes' ? Colors.lightBlue :
                     data.day == 'Sábado' ? Colors.indigo :
                     Colors.deepPurple; // Color para Domingo
            },
          ),
        ],
      ),
    );
  }

  // Genera datos para el gráfico radial
  List<BarChartData> _createBarChartData() {
    return [
      BarChartData('Lunes', 200, const Color.fromARGB(255, 54, 105, 244)),
      BarChartData('Martes', 150, const Color.fromARGB(255, 222, 119, 243)),
      BarChartData('Miércoles', 100, const Color.fromARGB(255, 34, 223, 236)),
      BarChartData('Jueves', 250, const Color.fromARGB(255, 158, 76, 175)),
      BarChartData('Viernes', 300, Colors.blue),
      BarChartData('Sábado', 400, Colors.indigo),
      BarChartData('Domingo', 350, Colors.purple),
    ];
  }
}

// Clase para representar los datos del gráfico de barras
class BarChartData {
  final String day;
  final double amount;
  final Color color; // Nuevo campo para el color

  BarChartData(this.day, this.amount, this.color);
}
