import 'package:admin/extensions/context.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PtzControl extends StatelessWidget {
  const PtzControl({
    super.key,
    required this.entityIdUp,
    required this.entityIdDown,
    required this.entityIdLeft,
    required this.entityIdRight,
  });

  final String entityIdUp;
  final String entityIdDown;
  final String entityIdLeft;
  final String entityIdRight;

  @override
  Widget build(BuildContext context) {
    final bloc = IotBloc.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.appLocalizations.pan_and_tilt,
            style:
                Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 17),
          ),
          const SizedBox(height: 8),
          Text(
            context.appLocalizations.control_ptz_panel,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Material(
            elevation: 2,
            shape: const CircleBorder(),
            shadowColor: Colors.black45,
            child: SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circular Gradient Background
                  Container(
                    width: 220,
                    height: 220,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(68, 206, 255, 0.5),
                          Color.fromRGBO(0, 130, 176, 0.5),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Inner Circle (empty space)
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),

                  // Up button
                  Transform.translate(
                    offset: const Offset(0, -80),
                    child: IconButton(
                      icon: Icon(
                        MdiIcons.arrowUpDropCircle,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        bloc.operateIotDevice(
                          entityIdUp,
                          "${entityIdUp.split(".").first}/press",
                          fromControls: true,
                        );
                      },
                    ),
                  ),

                  // Down button
                  Transform.translate(
                    offset: const Offset(0, 80),
                    child: IconButton(
                      icon: Icon(
                        MdiIcons.arrowDownDropCircle,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        bloc.operateIotDevice(
                          entityIdDown,
                          "${entityIdDown.split(".").first}/press",
                          fromControls: true,
                        );
                      },
                    ),
                  ),

                  // Left button
                  Transform.translate(
                    offset: const Offset(-80, 0),
                    child: IconButton(
                      icon: Icon(
                        MdiIcons.arrowLeftDropCircle,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        bloc.operateIotDevice(
                          entityIdLeft,
                          "${entityIdLeft.split(".").first}/press",
                          fromControls: true,
                        );
                      },
                    ),
                  ),

                  // Right button
                  Transform.translate(
                    offset: const Offset(80, 0),
                    child: IconButton(
                      icon: Icon(
                        MdiIcons.arrowRightDropCircle,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        bloc.operateIotDevice(
                          entityIdRight,
                          "${entityIdRight.split(".").first}/press",
                          fromControls: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
