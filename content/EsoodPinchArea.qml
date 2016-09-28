import QtQuick 2.7
import QtQuick.Controls 1.4
import "."
/*!
\qmltype EsoodPinchArea
\brief Declarative of the pinch area and mouse area used in the different screens
\section2 Licensing
\legalese
@copyright GNU GENERAL PUBLIC LICENSE  
 Version 3, 29 June 2007
\endlegalese
*/    
    PinchArea {
        id: pinchArea
        pinch.target: root
        anchors.fill: parent
        /*! starting x position */
        property real m_x1: 0
        /*! starting y position */
        property real m_y1: 0
        /*! ending x position */
        property real m_x2: 0
        /*! ending y position */
        property real m_y2: 0
        /*! initial zoom factor */
        property real m_zoom1: 1
        /*! final zoom factor */
        property real m_zoom2: 1
        /*! maximum zoom factor */
        property real m_max: 2
        /*! minimum zoom factor */
        property real m_min: 0.5

        onPinchStarted: {
            console.log("Pinch Started")
            m_x1 = scaler.origin.x
            m_y1 = scaler.origin.y
            m_x2 = pinch.startCenter.x
            m_y2 = pinch.startCenter.y
            root.x = root.x + (pinchArea.m_x1-pinchArea.m_x2)*(1-pinchArea.m_zoom1)
            root.y = root.y + (pinchArea.m_y1-pinchArea.m_y2)*(1-pinchArea.m_zoom1)
        }
        onPinchUpdated: {
            console.log("Pinch Updated")
            m_zoom1 = scaler.xScale
            var dz = pinch.scale-pinch.previousScale
            var newZoom = m_zoom1+dz
            if (newZoom <= m_max && newZoom >= m_min) {
                m_zoom2 = newZoom
            }
        }
        MouseArea {
            id: dragArea
            hoverEnabled: true
            anchors.fill: parent            
            drag.target: root
            drag.axis: Drag.XAndYAxis
            drag.filterChildren: true
            onWheel: {
                console.log("Wheel Scrolled1:", pinchArea.m_x1, pinchArea.m_y1, pinchArea.m_x2, pinchArea.m_y2, pinchArea.m_zoom1 )      
                pinchArea.m_x1 = scaler.origin.x
                pinchArea.m_y1 = scaler.origin.y
                pinchArea.m_zoom1 = scaler.xScale

                pinchArea.m_x2 = mouseX
                pinchArea.m_y2 = mouseY
                console.log("Wheel Scrolled2:", pinchArea.m_x1, pinchArea.m_y1, pinchArea.m_x2, pinchArea.m_y2, pinchArea.m_zoom1 )

                var newZoom
                if (wheel.angleDelta.y > 0) {
                    newZoom = pinchArea.m_zoom1+0.1
                    if (newZoom <= pinchArea.m_max) {
                        pinchArea.m_zoom2 = newZoom
                    } else {
                        pinchArea.m_zoom2 = pinchArea.m_max
                    }
                } else {
                    newZoom = pinchArea.m_zoom1-0.1
                    if (newZoom >= pinchArea.m_min) {
                        pinchArea.m_zoom2 = newZoom
                    } else {
                        pinchArea.m_zoom2 = pinchArea.m_min
                    }
                }
                root.x = root.x + (pinchArea.m_x1-pinchArea.m_x2)*(1-pinchArea.m_zoom1)
                root.y = root.y + (pinchArea.m_y1-pinchArea.m_y2)*(1-pinchArea.m_zoom1)
            }
            MouseArea {
                anchors.fill: parent
                onClicked: console.log("Click in child")
            }
        }
    }
    
