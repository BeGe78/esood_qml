import QtQuick 2.7
import "."
/*!
\qmltype TextTemplate
\brief Declarative for standard button.
\section2 Licensing
\legalese
@copyright GNU GENERAL PUBLIC LICENSE  
 Version 3, 29 June 2007
\endlegalese
*/ 
Item {id:container
//This Item is not needed really. The Text element could form the component
//directly. It is used to demonstrate how to get Text element properties at top
//level to be able to control them programmatically. You may need a container if you
//have two (or more) Text elements and/or combine a Text element with others element.
 width:500; height:500
 
//Bind Text element properties with properties at top level
 /*! /internal */
 property real topwidth: parent.width
 /*! /internal */
 property string label:"Sample text"
 /*! /internal */
 property color paint
 
 Text { id:template
 width:topwidth //Some properties of Text element take effect only
 //if width property is defined
 color:paint
 font.pointSize:12
 wrapMode: Text.WordWrap //If the text line length exceeds the width property
 //value the text will be wrapped (on word boundaries)
 text:label //A text property value is anything that results in to a string
 }
}
