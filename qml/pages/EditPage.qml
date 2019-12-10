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
                Component.onCompleted:{
                    if(expenseId !== 0)
                        JS.dbGetExpense(expenseId)
                    else
                        lm.append(
                                    {
                                        id: 0,
                                        category: "",
                                        comment: "",
                                        type: "",
                                        sum: ""
                                    }
                                    )
                }
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
                    placeholderText: "введите категорию"
                    width: 400
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
                    placeholderText: "введите комментарий"
                    width: 400
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
                    placeholderText: "введите сумму"
                    width: 400
                }
                ComboBox {
                    id: combobox
                    width: 480
                    label: "Тип"
                    x: 25
                    y: 350
                    menu: ContextMenu {
                        MenuItem { text: "расход" }
                        MenuItem { text: "доход" }
                    }


                    Component.onCompleted: {
                        console.log(type.toString() === "доход")
                        console.log(type === "доход")
                        currentIndex: type.toString() === "доход"? 1 : 0
                    }

//                    currentItem: type.toString() == "pacход" ? "расход" : "доход"
                }

                Button{
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 700
                    text: "Сохранить изменения"
                    onClicked: function(){
                        console.log(type)
                        console.log(combobox.value)
                        if (expenseId !== 0){
                            JS.dbUpdateRow(expenseId, combobox.value, tfcat.text, tfsum.text, tfdesc.text);}
                        else
                            JS.dbInsert(combobox.value, tfcat.text, tfsum.text, tfdesc.text)
                        pageStack.pop()
                    }
                }
            }
            VerticalScrollDecorator {}
        }
    }
}

