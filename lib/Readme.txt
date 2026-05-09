Hệ thống gọi main() ->  runApp(MyApp()).
Flutter tạo widget MyApp (stateless) và gọi build().
MaterialApp được tạo, đặt home là DefaultTabController.
DefaultTabController tạo ra InheritedWidget để cung cấp dữ liệu tab cho con cháu.
Scaffold được tạo, với AppBar có TabBar (3 tab) và body là TabBarView.
TabBarView tạo đồng thời cả 3 màn hình con: NoteListScreen, VocabListScreen, FlashcardScreen.
Mỗi màn hình con (StatefulWidget) gọi createState → tạo state tương ứng ->  gọi initState ->  gọi _loadNotes/_loadVocabs ->  bắt đầu truy vấn DB bất đồng bộ.
Lúc này, giao diện hiển thị lần đầu với danh sách rỗng (vì _notes khởi tạo [] và chưa có dữ liệu).
Sau khi Future hoàn thành, setState được gọi ->  rebuild màn hình đó với dữ liệu thật.


-- Người dùng thêm ghi chú mới

Nhấn nút FAB ở tab "Ghi chú".
onPressed của FAB push NoteEditScreen (không có note).
Màn hình NoteEditScreen hiện lên, người dùng nhập tiêu đề, nội dung, nhấn Lưu.
_save được gọi: do widget.note == null nên tạo Note mới với createdAt = DateTime.now(), gọi db.insertNote.
insertNote mở kết nối DB (nếu chưa mở) và chạy câu lệnh INSERT.
Sau khi insert xong, Navigator.pop(context) đóng màn hình edit, quay lại NoteListScreen.
Trong NoteListScreen, sau await Navigator.push(...), nó gọi _loadNotes().
_loadNotes lấy lại toàn bộ danh sách từ DB (bao gồm ghi chú mới) và setState ->  giao diện được cập nhật.

-- Sửa ghi chú
Nhấn vào một dòng trong danh sách → onTap push NoteEditScreen với note hiện tại.
Màn hình edit hiển thị dữ liệu cũ nhờ initState gán controller.
Người dùng sửa, nhấn Lưu ->  _save phát hiện widget.note != null -> tạo Note với id cũ, createdAt giữ nguyên, gọi db.updateNote.
updateNote chạy SQL UPDATE notes SET ... WHERE id = ?.
Quay lại danh sách, _loadNotes refresh.

-- Xóa ghi chú
Nhấn icon xóa → gọi _deleteNote(id) ->  db.deleteNote(id) ->  chạy DELETE FROM notes WHERE id = ?.
Gọi _loadNotes để cập nhật danh sách (xóa dòng đó trên giao diện).

-- THêm vocab
Chuyển sang tab "Từ vựng" (lúc này VocabListScreen đã có sẵn, không khởi tạo lại vì widget chưa bị hủy).
Nhấn FAB -> _showEditDialog() với vocab = null.
Điền từ, nghĩa, ví dụ, nhấn Lưu -> trong dialog, gọi db.insertVocab -> reload danh sách.
Tương tự sửa/xóa từ vựng.

