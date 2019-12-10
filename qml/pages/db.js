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

function dbGetOperations(){
    var stat = "Последние операции: \n";
    var db = dbGetHandle();
    db.transaction(function (tx) {
    var results = tx.executeSql(
                'SELECT rowid, type, sum FROM IncomesAndExpenses ORDER BY rowid DESC LIMIT 10 ')

    for (var i = 0; i < results.rows.length; i++){
        stat += ((i+1) + ") "+ (results.rows.item(i).type === "расход"? "-" :"+") + results.rows.item(i).sum+"\n")
    }
    listmodel.append({
                  results: stat
              });
    })
}

function dbGetOperationsPoints(call){
    var res = [];
    var db = dbGetHandle();
    db.transaction(function (tx) {
    var results = tx.executeSql(
                'SELECT rowid, type, sum FROM IncomesAndExpenses ORDER BY rowid DESC LIMIT 10 ')

    for (var i = 0; i < results.rows.length; i++){
       //res.push(results.rows.item(i).type === "расход"? 0-results.rows.item(i).sum : results.rows.item(i).sum)
        res.push(results.rows.item(i).sum)

    }
    call(res)
    })
}

function dbGetMostPopularExpenses(){
    var stat = "Самые популярные категории расходов: \n";
    var db = dbGetHandle();
    db.transaction(function (tx) {
    var results = tx.executeSql(
                'SELECT category, COUNT(category) FROM IncomesAndExpenses GROUP BY category ORDER BY COUNT(category) DESC LIMIT 10 ')

    for (var i = 0; i < results.rows.length; i++){
        stat += ((i+1) + ") "+ results.rows.item(i).category +"\n")
    }
    listmodel.append({
                  results: stat
              });
    })
}

function dbGetExpense(row_id)
{
    var db = dbGetHandle()
    db.transaction(function (tx) {
        var results = tx.executeSql(
                    'SELECT rowid, type, category,comment, sum FROM IncomesAndExpenses WHERE rowid=?', [row_id])

        for (var i = 0; i < results.rows.length; i++){
            lm.append({
                          id: results.rows.item(0).rowid,
                          category: results.rows.item(0).category,
                          comment: results.rows.item(0).comment,
                          type: results.rows.item(0).type,
                          sum: results.rows.item(0).sum
                      })
        }
    })
}

    function dbReadAll()
    {
        var db = dbGetHandle()
        db.transaction(function (tx) {
            var results = tx.executeSql(
                        'SELECT rowid, type, category, sum FROM IncomesAndExpenses order by rowid desc')
            for (var i = 0; i < results.rows.length; i++) {
                listmodel.append({
                                     id: results.rows.item(i).rowid,
                                     category: results.rows.item(i).category,
                                     type: results.rows.item(i).type,
                                     sum: results.rows.item(i).type == "расход"? "-%1".arg(results.rows.item(i).sum): "+%1".arg(results.rows.item(i).sum)
                                 })
            }
        })
    }
    function dbInsert(Rtype, Rcategory, Rsum, Rcomment)
    {
        var db = dbGetHandle()
        var rowid = 0;
        db.transaction(function (tx) {
            tx.executeSql('INSERT INTO IncomesAndExpenses VALUES(?, ?, ?, ?)',
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
            tx.executeSql('update IncomesAndExpenses set type = ?, category = ?, sum = ?, comment = ?  where rowid = ?', [Rtype, Rcategory, Rsum, Rcomment, RId])
        })
    }
