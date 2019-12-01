function dbInit()
{
    var db = LocalStorage.openDatabaseSync("IncomesAndExpenses", "1.0", "Track finances", 1000000)
    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS IncomesAndExpenses (type text, category text, sum float, comment text)')
        })
    } catch (err) {
        console.log("Error creating table in database: " + err)
    };
}

function dbGetHandle()
{
    try {
        var db = LocalStorage.openDatabaseSync("IncomesAndExpenses", "1.0", "Track finances", 1000000)

    } catch (err) {
        console.log("Error opening database: " + err)
    }
    return db
}
function dbReadAll()
{
    var db = dbGetHandle()
    db.transaction(function (tx) {
        var results = tx.executeSql(
                    'SELECT rowid, category, sum FROM notes order by rowid desc')
        for (var i = 0; i < results.rows.length; i++) {
            listmodel.append({
                                 id: results.rows.item(i).rowid,
                                 note: results.rows.item(i).note
                             })
        }
    })
}
function dbInsert(Rtype, Rcategory, Rsum, Rcomment)
{
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT INTO notes VALUES(?, ?, ?, ?)',
                      [Rtype, Rcategory, Rsum, Rcomment])
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
    return rowid;
}

function dbDeleteRow(RId)
{
    var db = dbGetHandle()
    db.transaction(function (tx) {
        tx.executeSql('delete from IncomesAndExpenses where rowid = ?', [RId])
    })
}

function dbUpdateRow(RId, Rtype, Rcategory, Rsum, Rcomment)
{
    var db = dbGetHandle()
    db.transaction(function (tx) {
        tx.executeSql('update IncomesAndExpenses set type = ?,  where rowid = ?', [RId])
    })
}
