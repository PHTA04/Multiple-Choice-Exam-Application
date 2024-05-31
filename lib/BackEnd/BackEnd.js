var express = require('express');
var bodyParser = require("body-parser");
var cors = require('cors');
var app = express();
var mysql = require('mysql2');
const async = require('async');
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

app.post('/insertExam', function (req, res) {
    const { tenDeThi, tenMonHoc } = req.body;

    const getMonHocQuery = "SELECT maMonHoc FROM MonHoc WHERE tenMonHoc = ?";
    const insertExamQuery = "INSERT INTO DeThi (tenDeThi, maMonHoc) VALUES (?, ?)";

    con.query(getMonHocQuery, [tenMonHoc], function (err, monHocResults) {
        if (err) {
            console.error("Error fetching maMonHoc:", err);
            res.status(500).send("Internal server error");
            return;
        }

        if (monHocResults.length === 0) {
            res.status(400).send("Môn học không tồn tại");
            return;
        }

        const maMonHoc = monHocResults[0].maMonHoc;

        con.query(insertExamQuery, [tenDeThi, maMonHoc], function (err, results) {
            if (err) {
                console.error("Error inserting exam:", err);
                res.status(500).send("Internal server error");
                return;
            }
            res.status(200).send("Đề thi đã được thêm thành công.");
        });
    });
});

app.post('/insertListOfExamQuestion', function (req, res) {
    const { tenDeThi, danhSachCauHoi } = req.body;

    const getDeThiQuery = "SELECT maDeThi FROM DeThi WHERE tenDeThi = ?";
    const getMaCauHoiQuery = "SELECT maCauHoi FROM CauHoi WHERE ndCauHoi = ?";
    const insertListOfExamQuestionQuery = "INSERT INTO DanhSachCauHoiDeThi (maDeThi, maCauHoi) VALUES ?";

    con.query(getDeThiQuery, [tenDeThi], function (err, deThiResults) {
        if (err) {
            console.error("Error fetching maDeThi:", err);
            res.status(500).send("Internal server error");
            return;
        }

        if (deThiResults.length === 0) {
            res.status(400).send("Đề thi không tồn tại");
            return;
        }

        const maDeThi = deThiResults[0].maDeThi;

        // Mảng chứa các cặp (maDeThi, maCauHoi) để chèn vào bảng danhSachCauHoiDeThi
        let values = [];

        // Truy vấn maCauHoi cho từng ndCauHoi và xây dựng mảng values
        async.eachSeries(danhSachCauHoi, function(ndCauHoi, callback) {
            con.query(getMaCauHoiQuery, [ndCauHoi], function (err, maCauHoiResults) {
                if (err) {
                    console.error("Error fetching maCauHoi:", err);
                    callback(err);
                    return;
                }

                if (maCauHoiResults.length === 0) {
                    console.error("Không tìm thấy maCauHoi cho ndCauHoi:", ndCauHoi);
                    callback("Không tìm thấy maCauHoi cho ndCauHoi: " + ndCauHoi);
                    return;
                }

                const maCauHoi = maCauHoiResults[0].maCauHoi;
                values.push([maDeThi, maCauHoi]);

                callback();
            });
        }, function(err) {
            if (err) {
                res.status(500).send("Internal server error");
                return;
            }

            // Chèn các cặp (maDeThi, maCauHoi) vào bảng danhSachCauHoiDeThi
            con.query(insertListOfExamQuestionQuery, [values], function (err, results) {
                if (err) {
                    console.error("Error inserting question of exam:", err);
                    res.status(500).send("Internal server error");
                    return;
                }
                res.status(200).send("Câu hỏi đã được thêm vào đề thi thành công.");
            });
        });
    });
});

app.post('/getTenDeThiList', function (req, res) {
    const { tenMonHoc } = req.body;
    const sql = "SELECT tenDeThi FROM DeThi WHERE maMonHoc IN (SELECT maMonHoc FROM MonHoc WHERE tenMonHoc = ?)";
    
    con.query(sql, [tenMonHoc], function(err, results) {
        if (err) {
            console.error("Lỗi khi lấy danh sách tên đề thi:", err);
            res.status(500).send("Internal server error");
            return;
        }

        if (results.length === 0) {
            res.status(200).json(null);
        } else {
            const tenDeThiList = results.map(row => row.tenDeThi);
            res.status(200).json(tenDeThiList);
        }
    });
});

app.post('/insertTest', function (req, res) {
    const {
        tenDeThi,
        tenBaiThi,
        thoiGianLamBai,
        ngayBatDau,
        ngayKetThuc,
        gioBatDau,
        gioKetThuc,
        soLanLamBai,
        choPhepXemLai
    } = req.body;

    const getDeThiQuery = "SELECT maDeThi FROM DeThi WHERE tenDeThi = ?";
    const insertTestQuery = "INSERT INTO BaiThi (tenBaiThi, thoiGianLamBai, ngayBatDau, ngayKetThuc, gioBatDau, gioKetThuc, soLanLamBai, choPhepXemLai, maDeThi) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    con.query(getDeThiQuery, [tenDeThi], function (err, deThiResults) {
        if (err) {
            console.error("Error fetching maDeThi:", err);
            res.status(500).send("Internal server error");
            return;
        }

        if (deThiResults.length === 0) {
            res.status(400).send("Đề thi không tồn tại");
            return;
        }

        const maDeThi = deThiResults[0].maDeThi;

        con.query(insertTestQuery, [tenBaiThi, thoiGianLamBai, ngayBatDau, ngayKetThuc, gioBatDau, gioKetThuc, soLanLamBai, choPhepXemLai, maDeThi], function (err, results) {
            if (err) {
                console.error("Error inserting test:", err);
                res.status(500).send("Internal server error");
                return;
            }
            res.status(200).send("Bài thi đã được thêm thành công.");
        });
    });
});

app.get('/getTest', function (req, res) {
    const sql = "SELECT * FROM BaiThi";
    
    con.query(sql, function(err, results) {
        if (err) {
            console.error("Lỗi khi lấy thông tin bài thi:", err);
            res.status(500).send("Internal server error");
            return;
        }

        const baiThiList = results.map(row => ({
            maBaiThi: row.maBaiThi,
            tenBaiThi: row.tenBaiThi,
            thoiGianLamBai: row.thoiGianLamBai,
            ngayBatDau: row.ngayBatDau,
            ngayKetThuc: row.ngayKetThuc,
            gioBatDau: row.gioBatDau,
            gioKetThuc: row.gioKetThuc,
            soLanLamBai: row.soLanLamBai,
            choPhepXemLai: row.choPhepXemLai,
            maDeThi: row.maDeThi
        }));

        res.status(200).json(baiThiList);
    });
});

app.post('/getDanhSachCauHoiDeThi', function (req, res) {
    const { maBaiThi } = req.body;

    // Truy vấn để lấy mã đề thi dựa trên mã bài thi
    const sqlSelectMaDeThi = "SELECT maDeThi FROM BaiThi WHERE maBaiThi = ?";

    con.query(sqlSelectMaDeThi, [maBaiThi], function (err, results) {
        if (err) {
            console.error("Lỗi khi lấy mã đề thi:", err);
            res.status(500).send("Internal server error");
            return;
        }

        if (results.length === 0) {
            res.status(404).send("Không tìm thấy bài thi với mã tương ứng");
            return;
        }

        const maDeThi = results[0].maDeThi;

        // Truy vấn để lấy danh sách mã câu hỏi từ mã đề thi
        const sqlSelectMaCauHoi = "SELECT maCauHoi FROM DanhSachCauHoiDeThi WHERE maDeThi = ?";
        con.query(sqlSelectMaCauHoi, [maDeThi], function (err, results) {
            if (err) {
                console.error("Lỗi khi lấy danh sách mã câu hỏi:", err);
                res.status(500).send("Internal server error");
                return;
            }

            if (results.length === 0) {
                res.status(404).send("Không tìm thấy câu hỏi cho đề thi này");
                return;
            }

            const maCauHoiList = results.map(row => row.maCauHoi);

            // Truy vấn để lấy chi tiết câu hỏi dựa trên danh sách mã câu hỏi
            const sqlSelectCauHoiDetails = `
                SELECT 
                    maCauHoi, ndCauHoi, imageCauHoi, loaiCauHoi, dapAnA, dapAnB, dapAnC, dapAnD, 
                    dapAnE, dapAnF, dapAnG, dapAnH, dapAnDung, idImage 
                FROM 
                    CauHoi 
                WHERE 
                    maCauHoi IN (?)
            `;

            con.query(sqlSelectCauHoiDetails, [maCauHoiList], function (err, results) {
                if (err) {
                    console.error("Lỗi khi lấy chi tiết câu hỏi:", err);
                    res.status(500).send("Internal server error");
                    return;
                }

                const cauHoiDetails = results.map(row => {
                    let dapAnDungParsed;
                    try {
                        dapAnDungParsed = JSON.parse(row.dapAnDung);
                    } catch (e) {
                        console.error("Lỗi khi parse dapAnDung:", e);
                        dapAnDungParsed = row.dapAnDung; // Hoặc bạn có thể đặt giá trị mặc định khác
                    }

                    return {
                        maCauHoi: row.maCauHoi,
                        ndCauHoi: row.ndCauHoi,
                        imageCauHoi: row.imageCauHoi,
                        loaiCauHoi: row.loaiCauHoi,
                        dapAnA: row.dapAnA,
                        dapAnB: row.dapAnB,
                        dapAnC: row.dapAnC,
                        dapAnD: row.dapAnD,
                        dapAnE: row.dapAnE,
                        dapAnF: row.dapAnF,
                        dapAnG: row.dapAnG,
                        dapAnH: row.dapAnH,
                        dapAnDung: dapAnDungParsed,
                        idImage: row.idImage
                    };
                });

                res.status(200).json(cauHoiDetails);
            });
        });
    });
});

// app.post('/insertDiem', function (req, res) {
//     const {
//         maBaiThi,
//         maSoSinhVien,
//         soCauDung,
//         soCauSai,
//         thoiGianHoanThanhBaiThi,
//         ngayLamBai,
//         gioLamBai,
//         soLanLamBai
//     } = req.body;

//     const sqlInsertDiem = `INSERT INTO Diem (maBaiThi, maSoSinhVien, soCauDung, soCauSai, thoiGianHoanThanhBaiThi, ngayLamBai, gioLamBai, soLanLamBai)
//                            VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;

//     con.query(sqlInsertDiem, [maBaiThi, maSoSinhVien, soCauDung, soCauSai, thoiGianHoanThanhBaiThi, ngayLamBai, gioLamBai, soLanLamBai], function (err, result) {
//         if (err) {
//             console.error("Error inserting score:", err);
//             res.status(500).send("Internal server error");
//             return;
//         }
//         res.status(200).send("Score has been inserted successfully.");
//     });
// });

app.post('/insertDiem', function (req, res) {
    const {
      maBaiThi,
      maSoSinhVien,
      soCauDung,
      soCauSai,
      thoiGianHoanThanhBaiThi,
      ngayLamBai,
      gioLamBai,
      soLanLamBai
    } = req.body;
  
    const sqlInsertDiem = `INSERT INTO Diem (maBaiThi, maSoSinhVien, soCauDung, soCauSai, thoiGianHoanThanhBaiThi, ngayLamBai, gioLamBai, soLanLamBai)
                           VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;
  
    con.query(sqlInsertDiem, [maBaiThi, maSoSinhVien, soCauDung, soCauSai, thoiGianHoanThanhBaiThi, ngayLamBai, gioLamBai, soLanLamBai], function (err, result) {
      if (err) {
        console.error("Error inserting score:", err);
        res.status(500).send("Internal server error");
        return;
      }
      // Trả về maDiem được chèn vào
      const maDiem = result.insertId;
      res.status(200).json({ maDiem: maDiem });
    });
});
  

app.post('/insertXemLaiBaiThi', function (req, res) {
    const {danhSachCauHoi, danhSachDapAnDung, danhSachDapAnSinhVienChon, maDiem} = req.body;

    const sqlInsertXemLai = `INSERT INTO XemLaiBaiThi (danhSachCauHoi, danhSachDapAnDung, danhSachDapAnSinhVienChon, maDiem)
                             VALUES (?, ?, ?, ?)`;

    const danhSachCauHoiJson = JSON.stringify(danhSachCauHoi);
    const danhSachDapAnDungJson = JSON.stringify(danhSachDapAnDung);
    const danhSachDapAnSinhVienChonJson = JSON.stringify(danhSachDapAnSinhVienChon);

    con.query(sqlInsertXemLai, [danhSachCauHoiJson, danhSachDapAnDungJson, danhSachDapAnSinhVienChonJson, maDiem], function (err, result) {
        if (err) {
            console.error("Error inserting review test:", err);
            res.status(500).send("Internal server error");
            return;
        }
        res.status(200).send("Review test has been inserted successfully.");
    });
});


var server = app.listen(2612, function () {
    var host = server.address().address
    var port = server.address().port
    console.log("Server is listening at http://%s:%s", host, port)
})