import 'package:flutter/material.dart';
import '../widgets/info_card.dart';

import 'package:provider/provider.dart';
import '/servicie/ble_controller.dart';
import 'config_screen.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String formatTime(int millis) {
  final duration = Duration(milliseconds: millis);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  return '${hours.toString().padLeft(2, '0')}:'
         '${minutes.toString().padLeft(2, '0')}:'
         '${seconds.toString().padLeft(2, '0')}';
}

  @override
  Widget build(BuildContext context) {

  final ble = context.watch<BLEController>();
  final timeOn = ble.lastData?.timeon ?? 0;
  
    return Scaffold(
      body: SafeArea(
        child:
        Padding(padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            
            Row(
              children: [
                Expanded(child: InfoCard(
                  title: 'Motor', 
                  icon: Icons.electric_bolt_outlined ,
                  height: 180,
                   child: MiIndicadorCircular(porcentaje: ((ble.lastData?.corriente ?? 0) / 10.0).clamp(0.0, 1.0)), 
                  ),

                ),
                

                Expanded(child: InfoCard(
                  title: 'Operacion',
                  icon: Icons.timer,
                  height: 180,
                  child: buildStyledValueText(
                    text: ble.isConnected
                      ? formatTime(timeOn)
                      : '00:00:00',
                  ),
                )

                ),
                
                

                
              ],
            ),
             const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: InfoCard(
                  title: 'Temperatura',
                  icon: Icons.thermostat_outlined,
                  height: 180, 
                  child: buildStyledValueText( text: ble.isConnected ?  '${ble.lastData?.temperatura }°C': "°C",), 
                  
                  ),

                ),
               

                Expanded(child: InfoCard(
                  title: 'Velocidad',
                  icon: Icons.speed,
                  height: 180,
                  child: MiIndicadorCircular(
                      porcentaje: ble.isConnected ? ((ble.lastData?.rpm ?? 0)/3000).toDouble().clamp(0.0, 1) : 0,
                      ),
                  )
                ),
                
                
              ],
            ),
            const SizedBox(height: 20),
          Row(
            children: [ Expanded(
              child:
              GestureDetector(
                onTap: () => showConfigBottomSheet(context),
                child: InfoCard(
                title: 'Estado',
                icon: ble.isConnected ? Icons.bluetooth_connected_rounded : Icons.bluetooth,
                height: 110,
                child: ontap(
                  value: !ble.isConnected  ? 'Desconectado' : (ble.lastData?.estado ?? false) ? 'Encendido'  : 'Apagado',
                  isStatus: !ble.isConnected ,
                  isStatusColor: ble.lastData?.estado ?? false,
                   onTap: () {
                   
                    if (ble.lastData!.estado) {
                      ble.sendCommand("apagar");
                    } else {
                      ble.sendCommand("encender");
                    }
                  },
                ),
              ),
              ),
           ),
            ],
          ),
            
            const SizedBox(width: 16),
            
            const Spacer(),
          ],
        ),
        )
        ),
      
     
    );
  }




}




class MedidorRpm extends StatelessWidget {
  final double rpm;
  final double maxRpm;

  const MedidorRpm({
    super.key,
    required this.rpm,
    this.maxRpm = 5000,
  });

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: maxRpm,
          showTicks: false,
          showLabels: false,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.2,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          ranges: [
            GaugeRange(
              startValue: 0,
              endValue: maxRpm,

              gradient: SweepGradient(
                colors: [const Color.fromARGB(13, 33, 149, 243), const Color.fromARGB(177, 33, 149, 243), Colors.blue],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ],
          pointers: [
            NeedlePointer(
              value: rpm,
              needleColor: Colors.blueGrey,
              needleLength: 1,
              needleStartWidth: 1,
              needleEndWidth: 2,
              knobStyle: const KnobStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                
                knobRadius: 0.08,
              ),
              enableAnimation: true,
              animationType: AnimationType.easeOutBack,
            ),
          ],
          annotations: [
            GaugeAnnotation(
              widget: Text(
                '${rpm.toStringAsFixed(0)}\nRPM',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              angle: 90,
              positionFactor: 0.6,
            ),
          ],
        ),
      ],
    );
  }
}

