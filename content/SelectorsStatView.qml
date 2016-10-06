import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "."
/*!
\qmltype SelectorsStatView

\brief SelectorsStatView
\section2 Licensing
\legalese
@copyright GNU GENERAL PUBLIC LICENSE  
 Version 3, 29 June 2007
\endlegalese
*/
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
        id: rectangle
        width: root.width
        height: root.height
        x: 0
        y: 0   // making this item draggable, so don't use anchors
        antialiasing: true        
        MouseArea {
            anchors.fill: parent
            drag.target: rectangle
            drag.axis: Drag.XAndYAxis
            onClicked: console.log("Click in rectangle")
            drag.filterChildren: false
        }
        Rectangle {
            id: rectangleTitle
            width: root.width - 20
            x: rectangle.x + 10
            y: rectangle.y + 10
            height: 20
            color: "#ffffff"
            Text {
                id: title
                text: (mainRect.formswitch == "indicator") ? mainRect.currentCountry1 : mainRect.currentIndicator1Name
                font.pixelSize: 18
            }
        }
        TableView {
            id: selectorStat
            width: root.width - 20
            height: 200
            x: rectangle.x + 10
            y: rectangle.y + 40
            frameVisible: true
            alternatingRowColors: false
            backgroundVisible: true
            model: statModel
            MouseArea {
                anchors.fill: parent
                propagateComposedEvents: true
                drag.target: rectangle
                drag.axis: Drag.XAndYAxis
                onClicked: {
                    console.log("clicked selectorStat")
                    console.log("table height : ",selectorStat.height)
                    mouse.accepted = false
                }
            }
            headerDelegate: Rectangle {
                id: tablehead
                height: textItem.implicitHeight * 1.2
                width: textItem.implicitWidth
                color: "lightsteelblue"                
                Text {
                    id: textItem
                    anchors.fill: parent
                    text: styleData.value
                    elide: Text.ElideRight
                    font: Qt.font({ pixelSize: 18 })
                    renderType: Text.NativeRendering
                }
            }
            rowDelegate: Rectangle {
               id: tablerow
               height: 90
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
    
                Label {
                    id: label
                    objectName: "label"
                    width: parent.width
                    height: parent.height
                    wrapMode: Text.WordWrap
                    //horizontalAlignment: styleData.textAlignment
                    text: styleData.value !== undefined ? styleData.value : ""
                }
            }
            TableViewColumn {
                id: countryColumn
                title: mainRect.formswitch == "country" ? qsTr("Country") : qsTr("Indicator")
                role: "formswitch"
                movable: true
                resizable: false
                width: (selectorStat.viewport.width / 8) * 3
            }
            TableViewColumn {
                id: meanColumn
                title: qsTr("Mean")
                role: "mean"
                movable: true
                resizable: false
                width: selectorStat.viewport.width / 8
            }
            TableViewColumn {
                id: slopeColumn
                title: qsTr("Slope")
                role: "slope"
                movable: true
                resizable: false
                width: selectorStat.viewport.width / 8
            }
            TableViewColumn {
                id: determinationColumn
                title: qsTr("Determination")
                role: "determination"
                movable: true
                resizable: false
                width: selectorStat.viewport.width / 8
            }
            TableViewColumn {
                id: meanrateColumn
                title: qsTr("Meanrate")
                role: "meanrate"
                movable: true
                resizable: false
                width: selectorStat.viewport.width / 8
            }
            TableViewColumn {
                id: correlationColumn
                title: qsTr("Correlation")
                role: "correlation"
                movable: true
                resizable: false
                width: selectorStat.viewport.width / 8
            }
        }
    }

    ListModel {
        id: statModel
    }
    /*!
        \qmlmethod drawStat()
        Fills the stat table with value passed as properties in esood.qml.
    */
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
