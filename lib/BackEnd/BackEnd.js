var express = require('express');
var bodyParser = require("body-parser");
var cors = require('cors');
var app = express();
var mysql = require('mysql2');
app.use(cors());
app.use(express.static('public'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }))


var con = mysql.createConnection({
    host: "127.0.0.1",
    port: "3306",
    user: "root",
    password: "123456",
    insecureAuth : true,
    database: "thitracnghiem"
});

app.post('/insertSubject', function (req, res) {
    const { maMonHoc, tenMonHoc } = req.body;
    const sqlSelect = "SELECT COUNT(*) as count FROM MonHoc WHERE maMonHoc = ?";
    const sqlInsert = "INSERT INTO MonHoc (maMonHoc, tenMonHoc) VALUES (?, ?)";
    
    con.query(sqlSelect, [maMonHoc], function(err, result) {
        if (err) {
            console.error("Error checking existing subject:", err);
            res.status(500).send("Internal server error");
            return;
        }

        const count = result[0].count;
        if (count > 0) {
            res.status(200).send("Mã môn học đã tồn tại.");
            return;
        }

        con.query(sqlInsert, [maMonHoc, tenMonHoc], function(err, result) {
            if (err) {
                console.error("Error inserting subject:", err);
                res.status(500).send("Internal server error");
                return;
            }
            res.status(200).send("Môn học đã được thêm thành công.");
        });
    });
});

app.get('/getMonHoc', function (req, res) {
    const sql = "SELECT maMonHoc, tenMonHoc FROM MonHoc";
    
    con.query(sql, function(err, results) {
        if (err) {
            console.error("Lỗi khi lấy danh sách môn học:", err);
            res.status(500).send("Internal server error");
            return;
        }

        const monHocList = results.map(row => ({
            maMonHoc: row.maMonHoc,
            tenMonHoc: row.tenMonHoc
        }));

        res.status(200).json(monHocList);
    });
});

app.get('/getTenMonHocList', function (req, res) {
    const sql = "SELECT tenMonHoc FROM MonHoc";
    
    con.query(sql, function(err, results) {
        if (err) {
            console.error("Lỗi khi lấy danh sách tên môn học:", err);
            res.status(500).send("Internal server error");
            return;
        }

        const tenMonHocList = results.map(row => row.tenMonHoc);
        console.log(tenMonHocList);
        res.status(200).json(tenMonHocList);
    });
});

app.post('/updateSubject', function (req, res) {
    const { maMonHoc, tenMonHoc } = req.body;

    // Truy vấn để kiểm tra xem mã môn học có tồn tại không
    const sqlSelectCount = "SELECT COUNT(*) as count FROM MonHoc WHERE maMonHoc = ?";
    con.query(sqlSelectCount, [maMonHoc], function(err, results) {
        if (err) {
            console.error("Error checking existing subject:", err);
            res.status(500).send("Internal server error");
            return;
        }

        const count = results[0].count;
        if (count === 0) {
            res.status(400).send("Mã môn học không tồn tại.");
            return;
        }

        // Nếu mã môn học tồn tại, thực hiện cập nhật
        const sqlUpdate = "UPDATE MonHoc SET maMonHoc = ?, tenMonHoc = ? WHERE maMonHoc = ?";
        con.query(sqlUpdate, [maMonHoc, tenMonHoc, maMonHoc], function(err, results) {
            if (err) {
                console.error("Error updating subject:", err);
                res.status(500).send("Internal server error");
                return;
            }
            res.status(200).send("Cập nhật môn học thành công.");
        });
    });
});


app.post('/deleteSubject', function (req, res) {
    const { maMonHoc } = req.body;

    // Truy vấn để kiểm tra xem mã môn học có tồn tại không
    const sqlSelectCount = "SELECT COUNT(*) as count FROM MonHoc WHERE maMonHoc = ?";
    con.query(sqlSelectCount, [maMonHoc], function(err, results) {
        if (err) {
            console.error("Error checking existing subject:", err);
            res.status(500).send("Internal server error");
            return;
        }

        const count = results[0].count;
        if (count === 0) {
            res.status(400).send("Mã môn học không tồn tại.");
            return;
        }

        // Nếu mã môn học tồn tại, thực hiện xóa
        const sqlDelete = "DELETE FROM MonHoc WHERE maMonHoc = ?";
        con.query(sqlDelete, [maMonHoc], function(err, results) {
            if (err) {
                console.error("Error deleting subject:", err);
                res.status(500).send("Internal server error");
                return;
            }
            res.status(200).send("Môn học đã được xóa thành công.");
        });
    });
});


app.post('/insertTopic', function (req, res) {
    const { tenChuDe, tenMonHoc } = req.body;

    // Truy vấn để lấy maMonHoc dựa trên tenMonHoc
    const sqlSelectMonHoc = "SELECT maMonHoc FROM MonHoc WHERE tenMonHoc = ?";
    con.query(sqlSelectMonHoc, [tenMonHoc], function(err, results) {
        if (err) {
            console.error("Error retrieving maMonHoc:", err);
            res.status(500).send("Internal server error");
            return;
        }

        if (results.length === 0) {
            // Không tìm thấy môn học với tên tương ứng
            res.status(404).send("Không tìm thấy môn học với tên tương ứng");
            return;
        }

        const maMonHoc = results[0].maMonHoc;

        // Sau khi có maMonHoc, thêm chủ đề vào bảng ChuDe
        const sqlInsertChuDe = "INSERT INTO ChuDe (tenChuDe, maMonHoc) VALUES (?, ?)";
        con.query(sqlInsertChuDe, [tenChuDe, maMonHoc], function(err, results) {
            if (err) {
                console.error("Error inserting topic:", err);
                res.status(500).send("Internal server error");
                return;
            }

            res.status(200).send("Chủ đề đã được thêm thành công.");
        });
    });
});

app.get('/getTopic', function (req, res) {
    const sql = "SELECT ChuDe.maChuDe, ChuDe.tenChuDe, MonHoc.tenMonHoc FROM ChuDe INNER JOIN MonHoc ON ChuDe.maMonHoc = MonHoc.maMonHoc";
    
    con.query(sql, function(err, results) {
        if (err) {
            console.error("Lỗi khi lấy danh sách chủ đề:", err);
            res.status(500).send("Internal server error");
            return;
        }

        const chuDeList = results.map(row => ({
            maChuDe: row.maChuDe,
            tenChuDe: row.tenChuDe,
            tenMonHoc: row.tenMonHoc
        }));

        res.status(200).json(chuDeList);
    });
});

app.post('/getTenChuDeList', function (req, res) {
    const { tenMonHoc } = req.body;
    const sql = "SELECT tenChuDe FROM ChuDe WHERE maMonHoc IN (SELECT maMonHoc FROM MonHoc WHERE tenMonHoc = ?)";
    
    con.query(sql, [tenMonHoc], function(err, results) {
        if (err) {
            console.error("Lỗi khi lấy danh sách tên chủ đề:", err);
            res.status(500).send("Internal server error");
            return;
        }

        if (results.length === 0) {
            // Nếu không tìm thấy chủ đề nào, trả về null
            res.status(200).json(null);
        } else {
            const tenChuDeList = results.map(row => row.tenChuDe);
            res.status(200).json(tenChuDeList);
        }
    });
});

app.post('/updateTopic', function (req, res) {
    const { maChuDe, tenChuDe, tenMonHoc } = req.body;

    // Kiểm tra xem mã chủ đề có tồn tại không
    const sqlSelectChuDeCount = "SELECT COUNT(*) as count FROM ChuDe WHERE maChuDe = ?";
    con.query(sqlSelectChuDeCount, [maChuDe], function(err, results) {
        if (err) {
            console.error("Error checking existing topic:", err);
            res.status(500).send("Internal server error");
            return;
        }

        const count = results[0].count;
        if (count === 0) {
            res.status(400).send("Mã chủ đề không tồn tại.");
            return;
        }

        // Truy vấn để lấy mã môn học dựa trên tên môn học
        const sqlSelectMonHoc = "SELECT maMonHoc FROM MonHoc WHERE tenMonHoc = ?";
        con.query(sqlSelectMonHoc, [tenMonHoc], function(err, results) {
            if (err) {
                console.error("Error retrieving maMonHoc:", err);
                res.status(500).send("Internal server error");
                return;
            }

            if (results.length === 0) {
                res.status(404).send("Không tìm thấy môn học với tên tương ứng");
                return;
            }

            const maMonHoc = results[0].maMonHoc;

            // Nếu tồn tại mã môn học, thực hiện cập nhật chủ đề
            const sqlUpdateChuDe = "UPDATE ChuDe SET tenChuDe = ?, maMonHoc = ? WHERE maChuDe = ?";
            con.query(sqlUpdateChuDe, [tenChuDe, maMonHoc, maChuDe], function(err, results) {
                if (err) {
                    console.error("Error updating topic:", err);
                    res.status(500).send("Internal server error");
                    return;
                }
                res.status(200).send("Cập nhật chủ đề thành công.");
            });
        });
    });
});

app.post('/deleteTopic', function (req, res) {
    const { maChuDe } = req.body;

    // Kiểm tra xem mã chủ đề có tồn tại không
    const sqlSelectChuDeCount = "SELECT COUNT(*) as count FROM ChuDe WHERE maChuDe = ?";
    con.query(sqlSelectChuDeCount, [maChuDe], function(err, results) {
        if (err) {
            console.error("Error checking existing topic:", err);
            res.status(500).send("Internal server error");
            return;
        }

        const count = results[0].count;
        if (count === 0) {
            res.status(400).send("Mã chủ đề không tồn tại.");
            return;
        }

        // Nếu tồn tại mã chủ đề, thực hiện xóa chủ đề
        const sqlDeleteChuDe = "DELETE FROM ChuDe WHERE maChuDe = ?";
        con.query(sqlDeleteChuDe, [maChuDe], function(err, results) {
            if (err) {
                console.error("Error deleting topic:", err);
                res.status(500).send("Internal server error");
                return;
            }
            res.status(200).send("Chủ đề đã được xóa thành công.");
        });
    });
});

app.post('/insertQuestion', function (req, res) {
    const {
        ndCauHoi,
        imageCauHoi,
        loaiCauHoi,
        dapAnA,
        dapAnB,
        dapAnC,
        dapAnD,
        dapAnE,
        dapAnF,
        dapAnG,
        dapAnH,
        dapAnDung,
        tenMonHoc,
        tenChuDe, 
        idImage
    } = req.body;

    // Truy vấn để lấy mã chủ đề dựa trên tên chủ đề
    const sqlSelectMaChuDe = "SELECT maChuDe FROM ChuDe WHERE tenChuDe = ?";

    con.query(sqlSelectMaChuDe, [tenChuDe], function (err, results) {
        if (err) {
            console.error("Lỗi khi lấy mã chủ đề:", err);
            res.status(500).send("Internal server error");
            return;
        }

        if (results.length === 0) {
            res.status(404).send("Không tìm thấy chủ đề với tên tương ứng");
            return;
        }

        const maChuDe = results[0].maChuDe;

        // Truy vấn để lấy mã môn học dựa trên tên môn học
        const sqlSelectMaMonHoc = "SELECT maMonHoc FROM MonHoc WHERE tenMonHoc = ?";
        con.query(sqlSelectMaMonHoc, [tenMonHoc], function (err, results) {
            if (err) {
                console.error("Lỗi khi lấy mã môn học:", err);
                res.status(500).send("Internal server error");
                return;
            }

            if (results.length === 0) {
                res.status(404).send("Không tìm thấy môn học với tên tương ứng");
                return;
            }

            const maMonHoc = results[0].maMonHoc;

            // Thêm câu hỏi vào cơ sở dữ liệu
            const sqlInsertQuestion = `INSERT INTO CauHoi (ndCauHoi, imageCauHoi, loaiCauHoi, dapAnA, dapAnB, dapAnC, dapAnD, dapAnE, dapAnF, dapAnG, dapAnH, dapAnDung, maChuDe, idImage) 
                                       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

            con.query(sqlInsertQuestion, [ndCauHoi, imageCauHoi, loaiCauHoi, dapAnA, dapAnB, dapAnC, dapAnD, dapAnE, dapAnF, dapAnG, dapAnH, JSON.stringify(dapAnDung), maChuDe, idImage], function (err, results) {
                if (err) {
                    console.error("Lỗi khi thêm câu hỏi:", err);
                    res.status(500).send("Internal server error");
                    return;
                }
                res.status(200).send("Câu hỏi đã được thêm thành công.");
            });
        });
    });
});

app.post('/getNoiDungCauHoiList', function (req, res) {
    const { tenChuDe } = req.body;

    // Truy vấn để lấy maChuDe dựa trên tenChuDe
    const sqlSelectMaChuDe = "SELECT maChuDe FROM ChuDe WHERE tenChuDe = ?";
    con.query(sqlSelectMaChuDe, [tenChuDe], function(err, results) {
        if (err) {
            console.error("Lỗi khi lấy mã chủ đề:", err);
            res.status(500).send("Internal server error");
            return;
        }

        if (results.length === 0) {
            res.status(404).send("Không tìm thấy chủ đề với tên tương ứng");
            return;
        }

        const maChuDe = results[0].maChuDe;

        // Truy vấn để lấy danh sách nội dung câu hỏi dựa trên maChuDe
        const sqlSelectNoiDungCauHoi = "SELECT ndCauHoi FROM CauHoi WHERE maChuDe = ?";
        con.query(sqlSelectNoiDungCauHoi, [maChuDe], function(err, results) {
            if (err) {
                console.error("Lỗi khi lấy danh sách nội dung câu hỏi:", err);
                res.status(500).send("Internal server error");
                return;
            }

            if (results.length === 0) {
                res.status(200).json([]);
                return;
            }

            const noiDungCauHoiList = results.map(row => row.ndCauHoi);
            res.status(200).json(noiDungCauHoiList);
        });
    });
});



var server = app.listen(2612, function () {
    var host = server.address().address
    var port = server.address().port
    console.log("Server is listening at http://%s:%s", host, port)
})