import QtQuick 2.0
import Sailfish.Silica 1.0
import "db.js" as JS
import QtQuick.LocalStorage 2.0

//Page {
//    id: page
//    property var id


//    allowedOrientations: Orientation.All

//    SilicaListView {
//        id: listView3
//        model: 20
//        anchors.fill: parent
//        header: PageHeader {
//            title: qsTr("Edit Page")
//        }
//        delegate: BackgroundItem {
//            id: delegate

////            Label {
////                x: Theme.horizontalPageMargin
////                text: qsTr("Item") + " " + id
////                anchors.verticalCenter: parent.verticalCenter
////                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
////            }
//            TextEdit {
//                x: Theme.horizontalPageMargin
//                    text: id
//                    font.family: "Helvetica"
//                    font.pointSize: 20
//                    anchors.verticalCenter: parent.verticalCenter
//                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
//                    focus: true
//                }
//            onClicked: console.log("Clicked " + index)
//        }
//        VerticalScrollDecorator {}
//    }
//}
Page {
    property var expenseId
    //    canAccept: sumField.acceptableInput && sumField.text.length > 0

    id: page

    allowedOrientations: Orientation.All
    Component.onCompleted: {
        JS.dbInit()
    }

    SilicaFlickable {
        id: listView
        anchors.fill: parent
        //        header: PageHeader {
        //            title: qsTr("Edit")

        //        SilicaListView{
        //            id: listview
        //            model: ListModel{
        //                id: lm
        //                Component.onCompleted: JS.dbGetExpense(expenseId)
        //            }
        //            anchors.fill: parent
        //            header: PageHeader {
        //                title: qsTr("Edit")
        //            }
        ColumnView{
            id: cv
            width: parent.width
            itemHeight: Theme.itemSizeSmall
            model: ListModel{
                id: lm
                Component.onCompleted: JS.dbGetExpense(expenseId)
            }
            delegate: BackgroundItem {
                id:delegate
                width: parent.width

                TextField {
                    x: Theme.horizontalPageMargin
                    text:"Сумма: %1".arg(sum)
                    placeholderText: "Сумма = %1".arg(sum)
                    font.family: "Helvetica"
                    font.pointSize: 20
                    anchors.verticalCenter: parent.verticalCenter
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor

                }
                onClicked: console.log(sum)
            }
            VerticalScrollDecorator {}
        }
        //    }
    }
}

