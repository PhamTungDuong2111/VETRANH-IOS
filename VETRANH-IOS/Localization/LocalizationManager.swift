//
//  LocalizationManager.swift
//  VETRANH-IOS
//

import SwiftUI
import Combine

public final class LocalizationManager: ObservableObject {
    public static let shared = LocalizationManager()

    private let keyLanguage = "neon_draw_app_language"

    @Published public var isVietnamese: Bool {
        didSet {
            UserDefaults.standard.set(isVietnamese ? "vi" : "en", forKey: keyLanguage)
        }
    }

    private init() {
        let saved = UserDefaults.standard.string(forKey: keyLanguage) ?? "en"
        self.isVietnamese = (saved == "vi")
    }

    public func setLanguage(vietnamese: Bool) {
        self.isVietnamese = vietnamese
    }

    public func text(_ key: String, _ args: CVarArg...) -> String {
        let format: String
        if isVietnamese {
            format = viStrings[key] ?? enStrings[key] ?? key
        } else {
            format = enStrings[key] ?? key
        }
        if args.isEmpty {
            return format
        } else {
            return String(format: format, arguments: args)
        }
    }

    private let enStrings: [String: String] = [
        "app_name": "Neon Draw",
        "undo": "Undo",
        "redo": "Redo",
        "symmetry": "Symmetry",
        "stencil_badge": "Templates",
        "photo_bg": "Background",
        "share": "Share",
        "save": "Save",
        "clear": "Clear",
        "close": "Close",
        "size_label": "Size: %ddp",
        "brush_neon": "Neon",
        "brush_rainbow": "Rainbow",
        "brush_stars": "Stars",
        "brush_beads": "Beads",
        "brush_ribbon": "Ribbon",
        "brush_fireworks": "Fireworks",
        "dialog_templates_title": "✨ Neon Doodle Templates",
        "dialog_templates_subtitle": "Select a glowing stencil guide to trace & draw",
        "cat_all": "All (100)",
        "cat_cute": "❤️ Cute (25)",
        "cat_animals": "🐾 Animals (25)",
        "cat_cosmic": "🚀 Cosmic (25)",
        "cat_mandala": "🌸 Mandala (25)",
        "btn_remove_stencil": "✕ Remove Stencil (Freehand)",
        "save_success_title": "🎉 Artwork Saved!",
        "save_success_location": "Image saved to Photo Gallery (Pictures/NeonDraw)",
        "btn_view_photo": "👁️ View Image",
        "btn_share_saved": "📤 Share",
        "btn_continue_drawing": "Continue Drawing",
        "dialog_clear_title": "Clear Canvas?",
        "dialog_clear_msg": "Are you sure you want to clear your entire drawing?",
        "dialog_clear_confirm": "Clear All",
        "dialog_clear_cancel": "Cancel",
        "dialog_language_title": "🌐 Select Language",
        "lang_english": "🇬🇧 English (Default)",
        "lang_vietnamese": "🇻🇳 Tiếng Việt",
        "toast_canvas_cleared": "Canvas cleared ✨",
        "toast_stencil_selected": "Selected: %@ %@! Trace along the glow lines ✨",
        "toast_freehand_mode": "Switched to Freehand drawing mode",
        "toast_photo_loaded": "Background added! Draw neon on your photo ✨",
        "toast_photo_error": "Cannot load image: %@",
        "toast_permission_needed": "Photo Library permission needed to save images!",
        "toast_save_success": "Artwork saved successfully to Gallery!",
        "toast_save_error": "Failed to save artwork: %@",
        "toast_lang_changed": "Language changed to English",
        "clear_photo_prompt": "Background Photo Options",
        "remove_photo": "Remove Photo",
        "change_photo": "Change Photo",

        // Music & Video Strings
        "music": "Music",
        "music_settings": "🎵 Background Music",
        "music_subtitle": "Select track or turn off sound",
        "music_off": "Music Off (Muted)",
        "music_on": "Music Playing",
        "video_replay_title": "🎬 Drawing Timelapse Video",
        "video_step_by_step": "🎬 Step-by-Step Video",
        "step_counter": "Stroke: Step %1$d / %2$d",
        "change_music": "Music",
        "export_mp4_video": "🎥 Export Video (MP4)",
        "exporting_video": "Encoding MP4 video… %1$d%%",
        "video_export_success": "🎉 Video exported to Gallery (Movies/NeonDraw)!",
        "video_export_error": "Failed to export video",
        "replay": "Replay",
        "speed": "Speed"
    ]

    private let viStrings: [String: String] = [
        "app_name": "Neon Draw",
        "undo": "Hoàn tác",
        "redo": "Làm lại",
        "symmetry": "Đối xứng",
        "stencil_badge": "Mẫu vẽ",
        "photo_bg": "Ảnh nền",
        "share": "Chia sẻ",
        "save": "Lưu",
        "clear": "Xóa",
        "close": "Đóng",
        "size_label": "Cỡ nét: %ddp",
        "brush_neon": "Neon",
        "brush_rainbow": "Cầu vồng",
        "brush_stars": "Ngôi sao",
        "brush_beads": "Chuỗi hạt",
        "brush_ribbon": "Ruy băng",
        "brush_fireworks": "Pháo hoa",
        "dialog_templates_title": "✨ Bộ sưu tập mẫu vẽ Neon",
        "dialog_templates_subtitle": "Chọn mẫu định hình phát sáng để tô màu & vẽ theo",
        "cat_all": "Tất cả (100)",
        "cat_cute": "❤️ Dễ thương (25)",
        "cat_animals": "🐾 Động vật (25)",
        "cat_cosmic": "🚀 Vũ trụ (25)",
        "cat_mandala": "🌸 Mandala (25)",
        "btn_remove_stencil": "✕ Xóa mẫu vẽ (Vẽ tự do)",
        "save_success_title": "🎉 Lưu tranh thành công!",
        "save_success_location": "Ảnh đã được lưu vào Bộ sưu tập ảnh (Pictures/NeonDraw)",
        "btn_view_photo": "👁️ Xem ảnh",
        "btn_share_saved": "📤 Chia sẻ",
        "btn_continue_drawing": "Tiếp tục vẽ",
        "dialog_clear_title": "Xóa bản vẽ?",
        "dialog_clear_msg": "Bạn có chắc chắn muốn xóa toàn bộ nét vẽ trên khung tranh không?",
        "dialog_clear_confirm": "Xóa hết",
        "dialog_clear_cancel": "Hủy",
        "dialog_language_title": "🌐 Chọn ngôn ngữ",
        "lang_english": "🇬🇧 English (Mặc định)",
        "lang_vietnamese": "🇻🇳 Tiếng Việt",
        "toast_canvas_cleared": "Đã xóa toàn bộ nét vẽ ✨",
        "toast_stencil_selected": "Đã chọn: %@ %@! Hãy vẽ theo khung nhé ✨",
        "toast_freehand_mode": "Đã chuyển sang chế độ Vẽ tự do",
        "toast_photo_loaded": "Đã thêm ảnh nền! Hãy vẽ neon lên ảnh ✨",
        "toast_photo_error": "Không thể tải ảnh: %@",
        "toast_permission_needed": "Cần cấp quyền Thư viện ảnh để lưu tranh!",
        "toast_save_success": "Đã lưu ảnh thành công vào Thư viện!",
        "toast_save_error": "Không thể lưu ảnh: %@",
        "toast_lang_changed": "Đã chuyển sang Tiếng Việt",
        "clear_photo_prompt": "Tùy chọn Ảnh nền",
        "remove_photo": "Xóa ảnh nền",
        "change_photo": "Đổi ảnh khác",

        // Music & Video Strings
        "music": "Âm nhạc",
        "music_settings": "🎵 Nhạc nền",
        "music_subtitle": "Chọn bài hát nền hoặc tắt âm thanh",
        "music_off": "Đã tắt nhạc",
        "music_on": "Đang phát nhạc",
        "video_replay_title": "🎬 Video tái hiện nét vẽ",
        "video_step_by_step": "🎬 Video từng bước nét vẽ",
        "step_counter": "Nét vẽ: Bước %1$d / %2$d",
        "change_music": "Đổi nhạc",
        "export_mp4_video": "🎥 Xuất video (MP4)",
        "exporting_video": "Đang kết xuất video MP4… %1$d%%",
        "video_export_success": "🎉 Đã xuất video vào Thư viện (Movies/NeonDraw)!",
        "video_export_error": "Lỗi khi xuất video",
        "replay": "Tua lại",
        "speed": "Tốc độ"
    ]
}
