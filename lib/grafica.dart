import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pie_chart/pie_chart.dart'; // Asegúrate de tener el paquete pie_chart en tu pubspec.yaml

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
        isLoading = false; // Asegúrate de detener la carga en caso de error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfica de Anillo'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data != null
              ? Center(
                  child: PieChart(
                    dataMap: _generateDataMap(data!), // Llamamos a la función para generar el mapa de datos
                    animationDuration: const Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 2.5, // Ajusta el tamaño
                    colorList: _generateColorList(), // Llamamos a la función para generar la lista de colores
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    centerText: "Días",
                    legendOptions: LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      legendShape: BoxShape.circle,
                      legendTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                  ),
                )
              : const Center(
                  child: Text('No hay datos disponibles'),
                ),
    );
  }

  void _showSnackbar(BuildContext context, String key, String value) {
    final snackBar = SnackBar(
      content: Text('Día: $key, Valor: $value'),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Map<String, double> _generateDataMap(Map<String, dynamic> data) {
    Map<String, double> dataMap = {};
    data.forEach((key, value) {
      double numericValue = double.tryParse(value.toString()) ?? 0; // Convertir a numérico
      dataMap[key] = numericValue; // Añadir al mapa de datos
    });
    return dataMap;
  }

  List<Color> _generateColorList() {
    return [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
    ];
  }
}
