import QtQuick 2.0
import Sailfish.Silica 1.0
import "db.js" as JS
import QtQuick.LocalStorage 2.0

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
        SilicaGridView{
            id: cv
            anchors.fill: parent
            model: ListModel{
                id: lm
                Component.onCompleted: JS.dbGetExpense(expenseId)
            }
            delegate: Rectangle {
                id:delegate
                width: parent.width
                Label{
                    id: lbcat
                    x: 50
                    y: 50
                    text: "Категория: "
                }
                TextField {
                    id: tfcat
                    text: category
                    font.family: "Helvetica"
                    font.pointSize: 20
                    anchors.left: lbcat.right
                    anchors.top: lbcat.top
                }
                Label{
                    id: lbdesc
                    anchors.left: lbcat.left
                    x: 50
                    y: 150
                    text: "Комментарий: "
                }

                TextField {
                    id: tfdesc
                    text: comment
                    font.family: "Helvetica"
                    font.pointSize: 20
                    anchors.left: lbdesc.right
                    y: 150
                }
                Label{
                    id: lbsum
                    x: 50
                    y: 250
                    text: "Сумма: "
                }

                TextField {
                    id: tfsum
                    text: sum
                    font.family: "Helvetica"
                    font.pointSize: 20
                    anchors.left: lbsum.right
                    y: 250
                }

                Button{
                    anchors.horizontalCenter: parent.width/2
                    y: 400
                    text: "Сохранить изменения"
                    onClicked: function(){
                        lm.append({id: JS.dbUpdateRow(expenseId, "расход", category, sum, comment), category: "не еда"});
                        pageStack.pop()
                    }
                }
            }
            VerticalScrollDecorator {}
        }
    }
}

