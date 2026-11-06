# Neon Draw iOS (Vẽ Tranh Neon Phát Sáng) 🎨✨

Ứng dụng vẽ tranh Neon phát sáng đỉnh cao cho hệ điều hành iOS (iPhone & iPad), được chuyển đổi và đồng bộ **100% đầy đủ mọi tính năng, giao diện, hiệu ứng và mẫu vẽ** từ phiên bản Android (`VETRANH-ADR`). Dự án được viết hoàn toàn bằng **Swift 5 / SwiftUI + UIKit CoreGraphics**, tối ưu hóa hiệu năng vẽ mượt mà 60/120fps (ProMotion) và sẵn sàng mở bằng Xcode để chạy trên thiết bị thật cũng như Simulator.

---

## 🌟 Tính Năng Nổi Bật (Giống y hệt VETRANH-ADR)

### 1. 🖌️ 6 Loại Cọ Vẽ Hiệu Ứng Neon Phát Sáng Sống Động
- **Neon Glow (Neon)**: Nét vẽ phát sáng nhiều lớp: lớp quầng sáng tỏa rộng bên ngoài (Outer Glow), dải màu neon chính rực rỡ ở giữa và lõi sáng trắng tinh khiết bên trong (Crisp White Core).
- **Rainbow (Cầu vồng)**: Tự động đổi dải quang phổ màu tuần hoàn (Hue Cycling) mượt mà theo từng nét vẽ, quầng hào quang phát sáng rực rỡ.
- **Stars (Ngôi sao)**: Rải các ngôi sao 5 cánh phát sáng dọc theo đường di chuyển của ngón tay/Apple Pencil, có quầng sáng và tâm trắng; tự động chuyển sắc cầu vồng khi bật Rainbow.
- **Beads (Chuỗi hạt)**: Vẽ chuỗi hạt ngọc tròn phát quang với đốm phản chiếu bóng sáng 3D chân thực.
- **Ribbon (Ruy băng)**: Dải ruy băng neon kép chạy song song hai bên nét vẽ mềm mại.
- **Fireworks (Pháo hoa)**: Các chùm pháo hoa 8 tia phát sáng bung nở dọc theo nét cọ cùng điểm sáng trắng ở trung tâm.

### 2. 🌀 4 Chế Độ Vẽ Đối Xứng (Symmetry Modes)
- **1x (Tự do)**: Chế độ vẽ thông thường.
- **2x (Gương đối xứng)**: Phản chiếu lật ngang qua trục giữa khung hình.
- **4x (4 Hướng)**: Xoay và phản chiếu đối xứng qua 4 góc phần tư.
- **8x (Kính vạn hoa - Kaleidoscope)**: Tạo hoa văn Mandala / vạn hoa huyền ảo 8 phân vùng kỳ diệu.

### 3. 🎨 Bộ Sưu Tập 100 Mẫu Định Hình Vector (Stencils)
Bao gồm trọn vẹn **100 mẫu vẽ vector** chia làm 4 danh mục với thẻ preview thumbnail vector phát sáng chân thực:
- **❤️ Dễ thương / Cute (25 mẫu)**: Trái tim, Ngôi sao, Cầu vồng, Bánh kem, Kem ốc quế, Dâu tây, Cherry, Donut, Dưa hấu, Bơ, Táo, Chuối, Kẹo, Kẹo mút, Trà sữa, Burger, Pizza, Chiếc nơ, Bong bóng, Kính râm, Cà phê, Hộp quà, Chiếc ô, Chiếc chuông, Hoa tulip.
- **🐾 Động vật / Animals (25 mẫu)**: Mèo con, Cún con, Con bướm, Khủng long, Cá heo, Cánh cụt, Thỏ trắng, Gấu trúc, Gấu nâu, Sư tử, Hổ con, Khỉ, Voi, Hươu cao cổ, Cáo đỏ, Cú mèo, Ếch, Gà con, Vịt con, Cá vàng, Bạch tuộc, Cá voi xanh, Cua, Ốc sên, Ong mật.
- **🚀 Vũ trụ & Huyền ảo / Cosmic (25 mẫu)**: Tên lửa, Mặt trăng sao, Vương miện, Kim cương, Nốt nhạc, Sao Thổ, Đĩa bay UFO, Phi hành gia, Sao băng, Kính thiên văn, Trái đất, Sao chổi, Sấm sét, Ngân hà xoắn ốc, Đũa thần, Cầu pha lê, Khiên, Thần kiếm, Lâu đài, Ngọn lửa, Bông tuyết, Đồng hồ cát, La bàn, Chìa khóa vàng, Bình phép.
- **🌸 Mandala & Hoa văn (25 mẫu)**: Hoa sen, Mặt trời, Mạng nhện, Hoa 8 cánh, Sao 12 đỉnh, Hoa hồng, Vòng tim, Kính vạn hoa, Hướng dương, Đuôi công, Sacred Geometry, Vô cực, Âm dương, Nút thắt Celtic, Luân xa, Vòng lá, Làn sóng, Tổ ong, Lục giác David, Lưới thoi, Xoắn ốc, Cánh bướm Mandala, Tia sáng Sunburst, Hoa sự sống, Vòng Zen Enso.
- **Nút bật/tắt hiển thị đường viền hướng dẫn (Eye Toggle)** tiện lợi.
- **Nét vẽ sạch khi xuất ảnh**: Đường viền mẫu chỉ hỗ trợ người dùng tô theo và sẽ tự động được ẩn khi lưu hoặc chia sẻ tác phẩm.

### 4. 🖼️ Nhập Ảnh Nền Tùy Chỉnh (Background Photo)
- Tải ảnh từ Thư viện ảnh (Photo Library) để vẽ nét neon trực tiếp đè lên ảnh chân dung, phong cảnh hoặc ảnh vẽ.
- Tùy chọn thay đổi ảnh nền hoặc xóa ảnh nền chỉ với một chạm.

### 5. 🌈 Bảng Màu Neon Rực Rỡ & Thanh Trượt Cỡ Nét
- **12 màu sắc neon đặc trưng**: Neon Cyan (`#00FFFF`), Neon Pink (`#FF007F`), Lime Green (`#39FF14`), Electric Yellow (`#FFE600`), Neon Orange (`#FF5F1F`), Electric Purple (`#BC13FE`), Sky Azure (`#007FFF`), Deep Rose (`#FF1493`), Mint Glow (`#00FF80`), Neon Red (`#FF3131`), Neon Violet (`#9D00FF`), Glowing White (`#FFFFFF`).
- Thanh trượt kích thước cọ (8px – 80px) với chấm tròn preview co giãn và đổi màu trực tiếp.
- Nút **Xóa sạch khung vẽ (Clear Canvas)** có hộp thoại xác nhận an toàn.

### 6. 💾 Lưu Vào Thư Viện Ảnh & Chia Sẻ Tác Phẩm
- Lưu ảnh chất lượng cao vào Thư viện ảnh của iOS với quyền `NSPhotoLibraryAddUsageDescription`.
- Hộp thoại lưu thành công (Save Success Dialog) hiển thị ảnh thumbnail đã lưu, nút **Xem ảnh trong Photos**, **Chia sẻ** và **Tiếp tục vẽ**.
- Tích hợp chuẩn iOS Share Sheet (`UIActivityViewController`) để gửi ảnh qua AirDrop, Tin nhắn, Zalo, Messenger, Instagram,...

### 7. 🌐 Đa Ngôn Ngữ Tức Thì (Bilingual: Tiếng Việt & English)
- Chuyển đổi ngôn ngữ trực tiếp ngay trong ứng dụng qua nút biểu tượng cờ `🇻🇳 VI` / `🇬🇧 EN`.
- Toàn bộ giao diện, tiêu đề hộp thoại, thông báo Toast, tên 100 mẫu vẽ và danh mục đều được dịch chuẩn xác.

---

## 📁 Cấu Trúc Dự Án (Project Structure)

```
VETRANH-IOS/
├── .gitignore
├── README.md
├── VETRANH-IOS.xcodeproj/
│   ├── project.pbxproj
│   └── xcshareddata/xcschemes/VETRANH-IOS.xcscheme
└── VETRANH-IOS/
    ├── App/
    │   ├── Info.plist                     # Cấu hình quyền Photos & ứng dụng
    │   ├── VETRANHApp.swift               # Điểm khởi chạy SwiftUI App
    │   └── ContentView.swift              # Màn hình chính kết nối toàn bộ tính năng
    ├── Core/
    │   ├── DrawingCanvasView.swift        # Engine vẽ CoreGraphics hiệu năng cao, đệm offscreen
    │   ├── TemplateShapes.swift           # Vector Bezier Path chuẩn xác cho 100 mẫu stencil
    │   └── TemplateThumbnailView.swift    # Thẻ preview vector thumbnail cho danh sách mẫu
    ├── Models/
    │   ├── DrawingModels.swift            # Stroke, BrushType, SymmetryMode
    │   └── StencilType.swift              # Định nghĩa 101 loại mẫu vẽ (NONE + 100 mẫu)
    ├── Localization/
    │   └── LocalizationManager.swift      # Quản lý ngôn ngữ song ngữ Tiếng Việt & English
    ├── Views/
    │   ├── TopToolbarView.swift           # Thanh công cụ trên (Undo, Redo, Đối xứng, Mẫu vẽ,...)
    │   ├── BottomToolbarView.swift        # Thanh công cụ dưới (Cọ, Kích thước, Bảng màu, Xóa)
    │   ├── TemplateGallerySheet.swift     # Modal chọn mẫu vẽ lưới 3 cột và bộ lọc 4 danh mục
    │   ├── SaveSuccessDialog.swift        # Hộp thoại phát sáng khi lưu tranh thành công
    │   └── ToastView.swift                # Thông báo HUD nổi phong cách Neon
    ├── Utilities/
    │   ├── Color+Extensions.swift         # Bảng màu 12 màu neon & tiện ích hex
    │   ├── ImagePicker.swift              # Trình chọn ảnh từ Photo Library (PHPicker)
    │   └── ShareSheet.swift               # Trình chia sẻ ảnh tiêu chuẩn iOS
    └── Assets.xcassets/
        ├── AccentColor.colorset
        └── AppIcon.appiconset
```

---

## 🚀 Hướng Dẫn Mở Bằng Xcode Và Build Lên Máy Thật

### Yêu cầu hệ thống:
- Máy Mac chạy hệ điều hành macOS Ventura hoặc Sonoma / Sequoia.
- Đã cài đặt **Xcode 14.0** trở lên (Khuyến nghị **Xcode 15** hoặc **Xcode 16**).
- Thiết bị iOS (iPhone / iPad) chạy iOS 15.0 trở lên hoặc iOS Simulator.

### Các bước thực hiện:

1. **Clone repository về máy Mac**:
   ```bash
   git clone https://github.com/PhamTungDuong2111/VETRANH-IOS.git
   cd VETRANH-IOS
   ```

2. **Mở dự án trong Xcode**:
   - Nhấp đúp vào file `VETRANH-IOS.xcodeproj` hoặc mở trong Terminal:
   ```bash
   open VETRANH-IOS.xcodeproj
   ```

3. **Cấu hình Signing & Capabilities (Để build lên máy thật)**:
   - Trong thanh Navigator bên trái Xcode, nhấp vào biểu tượng dự án xanh ở trên cùng `VETRANH-IOS`.
   - Chọn mục **TARGETS** -> `VETRANH-IOS`.
   - Chuyển sang tab **Signing & Capabilities**.
   - Tích chọn **Automatically manage signing**.
   - Tại mục **Team**, chọn Apple ID / Developer Team của bạn.
   - Nếu Bundle Identifier (`com.phamduong.neondraw`) bị trùng lặp, bạn có thể đổi thành dạng của riêng bạn (ví dụ: `com.phamduong.neondraw.app`).

4. **Chọn thiết bị và Chạy (Run)**:
   - Kết nối iPhone / iPad thật qua cáp Lightning / USB-C (hoặc chọn một thiết bị iPhone Simulator từ menu trên đỉnh Xcode).
   - Nhấn nút **Play (▶ / Cmd + R)** trên thanh công cụ Xcode để biên dịch và cài đặt trực tiếp lên máy thật.
   - Khi chạy lần đầu trên máy thật: Vào **Cài đặt (Settings) -> Cài đặt chung (General) -> Quản lý VPN & Thiết bị (VPN & Device Management)** trên iPhone, tin cậy chứng chỉ nhà phát triển của bạn để mở app.

---

## 📜 Giấy phép & Bản quyền
Dự án được xây dựng và đóng gói độc quyền cho tác giả **PhamTungDuong2111**.
Mọi thắc mắc hoặc yêu cầu bổ sung xin liên hệ qua email: `duongptth05816@gmail.com`.
