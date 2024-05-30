//
//  MapboxOptions.swift
//  locarie
//
//  Created by qiuty on 26/04/2024.
//

import MapboxMaps

func noScaleBarAndCompass() -> OrnamentOptions {
  .init(
    scaleBar: .init(visibility: .hidden),
    compass: .init(visibility: .hidden),
    logo: .init(position: .bottomLeading, margins: .init(x: 0, y: 150)),
    attributionButton: .init(position: .bottomLeading, margins: .init(x: 80, y: 149))
  )
}

func noScaleBarAndCompassOrnamentOptions(bottom: CGFloat) -> OrnamentOptions {
  .init(
    scaleBar: .init(visibility: .hidden),
    compass: .init(visibility: .hidden),
    logo: .init(position: .bottomLeading, margins: .init(x: 16, y: bottom)),
    attributionButton: .init(position: .bottomLeading, margins: .init(x: 100, y: bottom))
  )
}

func disabledAllGesturesOptions() -> GestureOptions {
  .init(
    panEnabled: false,
    pinchEnabled: false,
    rotateEnabled: false,
    pitchEnabled: false,
    doubleTapToZoomInEnabled: false,
    doubleTouchToZoomOutEnabled: false
  )
}
