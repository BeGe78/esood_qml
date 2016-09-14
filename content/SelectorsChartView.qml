/*
@copyright GNU GENERAL PUBLIC LICENSE  
 Version 3, 29 June 2007
*/

import QtQuick 2.7
import QtCharts 2.1
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
    property string charttitle: ""
    property string legend1: ""
    property string legend2: ""
    property bool same_scale: true
    property string unit: ""
    property string unit2: ""
    property int highvalue: 0
    property int lowvalue: 0
    property int highvalue2: 0
    property int lowvalue2: 0
    property int nbYticks: 0
    property int nbXticks: 0
    
    PinchArea {
        id: pinchArea
        pinch.target: root
        anchors.fill: parent
        property real m_x1: 0
        property real m_y1: 0
        property real m_y2: 0
        property real m_x2: 0
        property real m_zoom1: 1
        property real m_zoom2: 1
        property real m_max: 2
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
            //onPressed: console.log("Press in child")
        }
    }
    
    ListModel {
        id: model
    }

    ChartView {
        id: selectorChart
        title: root.charttitle
        titleFont: Qt.font({pixelSize: 12, bold: true, underline: true})
        legend.font: Qt.font({pixelSize: 12})
        width: root.width
        height: root.height
        x: 0
        y: 0   // making this item draggable, so don't use anchors
        antialiasing: true
        MouseArea {
            anchors.fill: parent
            drag.target: selectorChart
            drag.axis: Drag.XAndYAxis
            drag.minimumX: parent.width - box.width
            drag.maximumX: box.width - parent.width
            drag.minimumY: parent.height - box.height
            drag.maximumY: box.height - parent.height
        }

        ValueAxis {
            id: axisX
            labelsFont:Qt.font({pixelSize: 10})
            labelsAngle: -45
            titleText: qsTr("Year")
            min: mainRect.yearbegin
            max: mainRect.yearend
            tickCount: mainRect.yearend - mainRect.yearbegin - 1
            labelFormat: "%.0f"
        }
        ValueAxis {
            id: axisY
            titleText: root.unit
            labelsFont:Qt.font({pixelSize: 10})
            labelsAngle: -45
            min: root.lowvalue
            max: root.highvalue
            tickCount: root.nbYticks
            labelFormat: "%.1f"
        }
        ValueAxis {
            id: axisYb
            titleText: root.unit2
            labelsFont:Qt.font({pixelSize: 10})
            labelsAngle: -45
            min: root.lowvalue2
            max: root.highvalue2
            tickCount: root.nbYticks
            labelFormat: "%.1f"
        }
        
        SplineSeries {
            id: serie1
            name: root.legend1
            color: "#FFD52B1E"
            width: 2.0
            axisX: axisX
            axisY: axisY
        }
        SplineSeries {
            id: serie2
            name: root.legend2
            color: "#AF005292"
            width: 2.0
            axisX: axisX
            axisY: axisY
        }
        SplineSeries {
            id: serie2b
            name: root.legend2
            color: "#AF005292"
            width: 2.0
            axisX: axisX
            axisYRight: axisYb
        }
    }
    
    function drawChart() {
        var req = "http://localhost:3000/api/v1/selectors.json";
        if (!req)
            return;
        var xhr = new XMLHttpRequest;
        xhr.open("POST", req, true);
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                console.log( "SelectorsChartView xhr.responseText: " + xhr.responseText );
                var response = JSON.parse(xhr.responseText);
                if (xhr.status == 200) {
                    var myArr = response.data;
                    console.log( "SelectorsChartView Qt.locale(): " + Qt.locale().name );
                    serie1.removePoints(0, root.nbXticks);
                    serie2.removePoints(0, root.nbXticks);
                    serie2b.removePoints(0, root.nbXticks);
                    for(var i = 0; i < myArr.length; i++) {
                        serie1.append(myArr[i].x, myArr[i].y);
                        serie2.append(myArr[i].x, myArr[i].z);
                        serie2b.append(myArr[i].x, myArr[i].z);
                    }
                    root.charttitle = response.title;
                    root.legend1 = response.legend1;
                    root.legend2 = response.legend2;
                    root.unit = response.unit;
                    root.highvalue = response.highvalue;
                    root.lowvalue = response.lowvalue;
                    root.nbXticks = myArr.length;
                    root.nbYticks = response.nbticks;
                    axisY.labelFormat = response.label_format
                    if (response.same_scale) {
                        serie2.visible = true;
                        serie2b.visible = false;
                        axisYb.visible = false;
                    } else {
                        root.unit2 = response.unit2;
                        root.highvalue2 = response.highvalue2;
                        root.lowvalue2 = response.lowvalue2;
                        serie2.visible = false;
                        serie2b.visible = true;
                        axisYb.visible = true;
                        axisYb.labelFormat = response.label_format2
                    }
                } else {
                    listview.model.append("error CountriesIndex")
                }
            }
        }
        
        var params = 'form_switch=';
        params += mainRect.formswitch;
        params += '&year_begin=';
        params += mainRect.yearbegin;
        params += '&year_end=';
        params += mainRect.yearend;
        params += '&fake_indicator=';
        params += encodeURIComponent(mainRect.currentIndicator1);
        params += '&fake_indicator2=';
        params += encodeURIComponent(mainRect.currentIndicator2);
        params += '&fake_country1=';
        params += encodeURIComponent(mainRect.currentCountry1);
        params += '&fake_country2='
        params += encodeURIComponent(mainRect.currentCountry2);
        params += '&email='
        params += mainRect.email;
        params += '&auth_token='
        params += mainRect.auth_token;
        xhr.send(params);
    }
}
