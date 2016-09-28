/*
@copyright GNU GENERAL PUBLIC LICENSE  
 Version 3, 29 June 2007
*/

import QtQuick 2.7
import QtCharts 2.1
import QtQuick.Controls 1.4
import "."

Rectangle {
    id: root
    width: 320
    height: 410
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    color: "white"
    transform: Scale {
        id: scaler
        origin.x: pinchArea.m_x2
        origin.y: pinchArea.m_y2
        xScale: pinchArea.m_zoom2
        yScale: pinchArea.m_zoom2
    }

    EsoodPinchArea { id: pinchArea }

    Rectangle {
        id: rectangleTitle
        width: root.width - 20
        height: 20
        color: "#ffffff"
        anchors.horizontalCenterOffset: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: title
            text: (mainRect.formswitch == "indicator") ? mainRect.currentCountry1 : mainRect.currentIndicator1Name
            font.pixelSize: 14
        }
    }
    TableView {
        id: selectorStat
        width: root.width - 20
        anchors.horizontalCenter: parent.horizontalCenter
        frameVisible: true
        alternatingRowColors: false
        backgroundVisible: true
        anchors.top: rectangleTitle.bottom
        anchors.topMargin: 20
        model: statModel
        headerDelegate: Rectangle {
            height: textItem.implicitHeight * 1.2
            width: textItem.implicitWidth
            color: "lightsteelblue"
            Text {
                id: textItem
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: styleData.textAlignment
                anchors.leftMargin: 2
                text: styleData.value
                font: Qt.font({ pixelSize: 16 })
                //elide: Text.ElideRight
                renderType: Text.NativeRendering
            }
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 1
                anchors.topMargin: 1
                width: 1
                color: "#ccc"
            }
        }
        rowDelegate: Rectangle {
           height: 60
           SystemPalette {
              id: myPalette;
              colorGroup: SystemPalette.Active
           }
           color: {
              var baseColor = styleData.alternate?myPalette.alternateBase:myPalette.base
              return styleData.selected?myPalette.highlight:baseColor
           }
           scale: 0.01
        }
        itemDelegate: Item {
            height: Math.max(60, label.implicitHeight)
            property int implicitWidth: label.implicitWidth + 20

            TextArea {
                id: label
                objectName: "label"
                width: parent.width
                height: parent.height
                anchors.leftMargin: 12
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: styleData.textAlignment
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1
                text: styleData.value !== undefined ? styleData.value : ""
            }
        }
        TableViewColumn {
            id: countryColumn
            title: mainRect.formswitch == "country" ? qsTr("Country") : qsTr("Indicator")
            role: "formswitch"
            movable: false
            resizable: true
            width: (selectorStat.viewport.width / 8) * 3
        }
        TableViewColumn {
            id: meanColumn
            title: qsTr("Mean")
            role: "mean"
            movable: false
            resizable: true
            width: selectorStat.viewport.width / 8
        }
        TableViewColumn {
            id: slopeColumn
            title: qsTr("Slope")
            role: "slope"
            movable: false
            resizable: true
            width: selectorStat.viewport.width / 8
        }
        TableViewColumn {
            id: determinationColumn
            title: qsTr("Determination")
            role: "determination"
            movable: false
            resizable: true
            width: selectorStat.viewport.width / 8
        }
        TableViewColumn {
            id: meanrateColumn
            title: qsTr("Meanrate")
            role: "meanrate"
            movable: false
            resizable: true
            width: selectorStat.viewport.width / 8
        }
        TableViewColumn {
            id: correlationColumn
            title: qsTr("Correlation")
            role: "correlation"
            movable: false
            resizable: true
            width: selectorStat.viewport.width / 8
        }
    }

    ListModel {
        id: statModel
    }

    function drawStat() {
        statModel.clear();
        statModel.append({
            "formswitch": (mainRect.formswitch == "country") ? mainRect.currentCountry1 : mainRect.currentIndicator1Name,
            "mean": mainRect.mean1,
            "slope": mainRect.coeflm1,
            "determination": mainRect.coeflm3_1,
            "meanrate": mainRect.meanrate1,
            "correlation": mainRect.cor            
        });
        statModel.append({
            "formswitch": (mainRect.formswitch == "country") ? mainRect.currentCountry2 : mainRect.currentIndicator2Name,
            "mean": mainRect.mean2,
            "slope": mainRect.coeflm2,
            "determination": mainRect.coeflm3_2,
            "meanrate": mainRect.meanrate2
        });
    }
}
