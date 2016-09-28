import QtQuick 2.7
import "."
/*!
\qmltype Button
\brief Declarative for standard button.
\section2 Licensing
\legalese
@copyright GNU GENERAL PUBLIC LICENSE  
 Version 3, 29 June 2007
\endlegalese
*/ 
Rectangle {
    id: button
    /*! /internal */
    signal clicked
    /*! /internal */
    property alias text: txt.text
    /*! /internal */
    property bool buttonEnabled: false
    width: Math.max(64, txt.width + 16)
    height: 32
    color: "transparent"
    radius: 3
    border.color: "#333333"
    MouseArea {
        anchors.fill: parent
        onClicked: button.clicked()
    }
    Text {
        anchors.centerIn: parent
        font.pixelSize: 20
        font.weight: Font.DemiBold
        font.family: "Verdana"
        id: txt
        color: "#000000"
    }
}
