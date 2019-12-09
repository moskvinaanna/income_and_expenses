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
                    validator: IntValidator { bottom: 0; top: 10000000 }
                    inputMethodHints: Qt.ImhDigitsOnly
                }
                ComboBox {
                    id: combobox
                    width: 480
                    label: "Тип"
                    x: 25
                    y: 350
                    currentIndex: type == "pacход" ? 0 : 1

                    menu: ContextMenu {
                        MenuItem { text: "расход" }
                        MenuItem { text: "доход" }
                    }
                }

                Button{
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 700
                    text: "Сохранить изменения"
                    onClicked: function(){
                        JS.dbUpdateRow(expenseId, combobox.value, tfcat.text, tfsum.text, tfdesc.text);
                        pageStack.pop()
                    }
                }
            }
            VerticalScrollDecorator {}
        }
    }
}

