import QtQuick 2.7
import QtCharts 2.1
import "."
/*!
\qmltype SelectorsChartView

\brief Dipslay the chart corresponding to the selected parameters.
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
    /*! title of the chart return by the API */
    property string charttitle: ""
    /*! legend of serie1 return by the API */
    property string legend1: ""
    /*! legend of serie2 return by the API */
    property string legend2: ""
    /*! true of both series have same scale return by the API */
    property bool same_scale: true
    /*! unit of serie1 return by the API */
    property string unit: ""
    /*! unit of serie2 return by the API */
    property string unit2: ""
    /*! highest value of serie1 return by the API */
    property int highvalue: 0
    /*! lowest value of serie1 return by the API */
    property int lowvalue: 0
    /*! highest value of serie2 return by the API */
    property int highvalue2: 0
    /*! lowest value of serie2 return by the API */
    property int lowvalue2: 0
    /*! number of ticks for the Y axis return by the API */
    property int nbYticks: 0
    /*! number of ticks for the X axis return by the API */
    property int nbXticks: 0
    
    EsoodPinchArea { id: pinchArea }
    
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
            /*
            drag.minimumX: parent.width - box.width
            drag.maximumX: box.width - parent.width
            drag.minimumY: parent.height - box.height
            drag.maximumY: box.height - parent.height
            */
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
    /*!
        \qmlmethod drawChart()
        AJAX post to create the chart via the ESoOD API
    */
    function drawChart() {
        var req = "https://bege.hd.free.fr/api/v1/selectors.json";
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
                    axisY.labelFormat = response.label_format;
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
                        axisYb.labelFormat = response.label_format2;
                    }
                    mainRect.mean1 = response.mean1;
                    mainRect.mean2 = response.mean2;
                    mainRect.coeflm1 = response.coeflm1;
                    mainRect.coeflm2 = response.coeflm2;
                    mainRect.coeflm3_1 = response.coeflm3_1;
                    mainRect.coeflm3_2 = response.coeflm3_2;
                    mainRect.meanrate1 = response.meanrate1;
                    mainRect.meanrate2 = response.meanrate2;
                    mainRect.cor = response.cor.toString();
                    selectorsStatView.drawStat();
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
        params += '&language=';
        params += mainRect.language;
        xhr.send(params);
    }
}
