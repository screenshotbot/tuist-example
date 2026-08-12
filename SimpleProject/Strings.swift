//
//  Strings.swift
//  SimpleProject
//
//  Translations for the chat app.
//
//  These live in Swift rather than a `.strings` catalog on purpose: snapshot
//  tests can then pick a language by setting `\.locale` on the view under test,
//  and the rendered text never depends on the simulator's language settings or
//  on which resources happened to be copied into the test host bundle.
//

import SwiftUI

struct Strings {
    // Chrome
    let appTitle: String
    let search: String
    let tabChats: String
    let tabCalls: String
    let tabSettings: String

    // Presence
    let online: String
    /// Formatted with the contact's first name.
    let typingFormat: String
    /// Formatted with a time, e.g. "last seen at 09:41".
    let lastSeenFormat: String
    /// Formatted with a member count.
    let membersFormat: String

    // Dates
    let today: String
    let yesterday: String

    // Composer + attachments
    let messagePlaceholder: String
    let photo: String
    let voiceMessage: String
    let unreadDivider: String

    // Empty state
    let emptyTitle: String
    let emptyBody: String
    let emptyAction: String

    // Group names (people's names are left untranslated)
    let groupDevTeam: String
    let groupFamily: String

    // Conversation list previews
    let previewDevTeam: String
    let previewPriya: String
    let previewFamily: String
    let previewSam: String
    let previewJonas: String
    let previewAlerts: String

    // The thread rendered by the chat detail snapshots
    let threadHello: String
    let threadReply: String
    let threadPhotoCaption: String
    let threadShipIt: String
    let threadOneMore: String
    let threadBadge: String
    let threadAlreadyDone: String
    let threadThanks: String

    /// Picks the translation for a locale, falling back to English.
    static func forLocale(_ locale: Locale) -> Strings {
        switch locale.identifier.prefix(2) {
        case "es": return .spanish
        case "ja": return .japanese
        case "de": return .german
        case "ar": return .arabic
        default: return .english
        }
    }
}

extension Strings {
    static let english = Strings(
        appTitle: "Messages",
        search: "Search",
        tabChats: "Chats",
        tabCalls: "Calls",
        tabSettings: "Settings",
        online: "online",
        typingFormat: "%@ is typing…",
        lastSeenFormat: "last seen at %@",
        membersFormat: "%d members",
        today: "Today",
        yesterday: "Yesterday",
        messagePlaceholder: "Message",
        photo: "Photo",
        voiceMessage: "Voice message",
        unreadDivider: "Unread messages",
        emptyTitle: "No conversations yet",
        emptyBody: "Start a new chat and it will show up right here.",
        emptyAction: "Start a chat",
        groupDevTeam: "Dev Team",
        groupFamily: "Family",
        previewDevTeam: "Ana: build 412 is green ✅",
        previewPriya: "See you at six!",
        previewFamily: "Mum: don't forget Sunday lunch",
        previewSam: "Invoice is on its way over",
        previewJonas: "Perfect, thanks for the quick turnaround",
        previewAlerts: "Your deploy finished in 3m 12s",
        threadHello: "Morning! Did you get a chance to look at the new mockups?",
        threadReply: "Just opened them. The empty state reads so much better now 🙌",
        threadPhotoCaption: "Went with the softer gradient in the end",
        threadShipIt: "Ship it. I'll re-record the snapshots tonight.",
        threadOneMore: "Perfect. One more thing —",
        threadBadge: "Could the unread badge use the accent colour instead?",
        threadAlreadyDone: "Already done, pushing the change now.",
        threadThanks: "You're a star, thank you!"
    )

    static let spanish = Strings(
        appTitle: "Mensajes",
        search: "Buscar",
        tabChats: "Chats",
        tabCalls: "Llamadas",
        tabSettings: "Ajustes",
        online: "en línea",
        typingFormat: "%@ está escribiendo…",
        lastSeenFormat: "última vez a las %@",
        membersFormat: "%d miembros",
        today: "Hoy",
        yesterday: "Ayer",
        messagePlaceholder: "Mensaje",
        photo: "Foto",
        voiceMessage: "Mensaje de voz",
        unreadDivider: "Mensajes sin leer",
        emptyTitle: "Aún no hay conversaciones",
        emptyBody: "Empieza un chat nuevo y aparecerá aquí mismo.",
        emptyAction: "Empezar un chat",
        groupDevTeam: "Equipo de desarrollo",
        groupFamily: "Familia",
        previewDevTeam: "Ana: la compilación 412 está en verde ✅",
        previewPriya: "¡Nos vemos a las seis!",
        previewFamily: "Mamá: no olvides la comida del domingo",
        previewSam: "La factura ya va en camino",
        previewJonas: "Perfecto, gracias por la rapidez",
        previewAlerts: "Tu despliegue terminó en 3 min 12 s",
        threadHello: "¡Buenos días! ¿Pudiste ver los nuevos diseños?",
        threadReply: "Acabo de abrirlos. El estado vacío se entiende mucho mejor 🙌",
        threadPhotoCaption: "Al final nos quedamos con el degradado más suave",
        threadShipIt: "Adelante. Vuelvo a grabar las capturas esta noche.",
        threadOneMore: "Perfecto. Una cosa más —",
        threadBadge: "¿La insignia de no leídos podría usar el color de acento?",
        threadAlreadyDone: "Ya está hecho, subo el cambio ahora.",
        threadThanks: "¡Eres genial, muchas gracias!"
    )

    static let german = Strings(
        appTitle: "Nachrichten",
        search: "Suchen",
        tabChats: "Chats",
        tabCalls: "Anrufe",
        tabSettings: "Einstellungen",
        online: "online",
        typingFormat: "%@ schreibt gerade…",
        lastSeenFormat: "zuletzt gesehen um %@",
        membersFormat: "%d Mitglieder",
        today: "Heute",
        yesterday: "Gestern",
        messagePlaceholder: "Nachricht",
        photo: "Foto",
        voiceMessage: "Sprachnachricht",
        unreadDivider: "Ungelesene Nachrichten",
        emptyTitle: "Noch keine Unterhaltungen",
        emptyBody: "Starte einen neuen Chat – er erscheint dann genau hier.",
        emptyAction: "Chat starten",
        groupDevTeam: "Entwicklungsteam",
        groupFamily: "Familie",
        previewDevTeam: "Ana: Build 412 ist grün ✅",
        previewPriya: "Bis um sechs!",
        previewFamily: "Mama: vergiss das Sonntagsessen nicht",
        previewSam: "Die Rechnung ist unterwegs",
        previewJonas: "Perfekt, danke für die schnelle Umsetzung",
        previewAlerts: "Dein Deployment lief in 3 Min. 12 Sek. durch",
        threadHello: "Guten Morgen! Konntest du dir die neuen Entwürfe schon ansehen?",
        threadReply: "Gerade geöffnet. Der leere Zustand liest sich jetzt viel besser 🙌",
        threadPhotoCaption: "Am Ende ist es doch der weichere Verlauf geworden",
        threadShipIt: "Dann raus damit. Ich nehme die Snapshots heute Abend neu auf.",
        threadOneMore: "Super. Noch eine Sache —",
        threadBadge: "Könnte das Ungelesen-Abzeichen die Akzentfarbe verwenden?",
        threadAlreadyDone: "Schon erledigt, ich pushe die Änderung gerade.",
        threadThanks: "Du bist die Beste, vielen Dank!"
    )

    static let japanese = Strings(
        appTitle: "メッセージ",
        search: "検索",
        tabChats: "チャット",
        tabCalls: "通話",
        tabSettings: "設定",
        online: "オンライン",
        typingFormat: "%@さんが入力中…",
        lastSeenFormat: "最終接続 %@",
        membersFormat: "メンバー%d人",
        today: "今日",
        yesterday: "昨日",
        messagePlaceholder: "メッセージ",
        photo: "写真",
        voiceMessage: "ボイスメッセージ",
        unreadDivider: "未読メッセージ",
        emptyTitle: "まだ会話がありません",
        emptyBody: "新しいチャットを始めると、ここに表示されます。",
        emptyAction: "チャットを始める",
        groupDevTeam: "開発チーム",
        groupFamily: "家族",
        previewDevTeam: "Ana: ビルド412はグリーンです ✅",
        previewPriya: "6時にね！",
        previewFamily: "母: 日曜のランチを忘れないでね",
        previewSam: "請求書をこれから送ります",
        previewJonas: "完璧です、迅速な対応ありがとう",
        previewAlerts: "デプロイが3分12秒で完了しました",
        threadHello: "おはよう！新しいモックアップは見てもらえた？",
        threadReply: "今開いたところ。空の状態がすごく分かりやすくなったね 🙌",
        threadPhotoCaption: "結局やわらかいグラデーションにしました",
        threadShipIt: "これでいこう。今夜スナップショットを撮り直すね。",
        threadOneMore: "完璧。もうひとつだけ —",
        threadBadge: "未読バッジをアクセントカラーにできますか？",
        threadAlreadyDone: "もう対応済みです。今プッシュします。",
        threadThanks: "さすがです、ありがとう！"
    )

    static let arabic = Strings(
        appTitle: "الرسائل",
        search: "بحث",
        tabChats: "المحادثات",
        tabCalls: "المكالمات",
        tabSettings: "الإعدادات",
        online: "متصل الآن",
        typingFormat: "%@ يكتب الآن…",
        lastSeenFormat: "آخر ظهور %@",
        membersFormat: "%d أعضاء",
        today: "اليوم",
        yesterday: "أمس",
        messagePlaceholder: "رسالة",
        photo: "صورة",
        voiceMessage: "رسالة صوتية",
        unreadDivider: "رسائل غير مقروءة",
        emptyTitle: "لا توجد محادثات بعد",
        emptyBody: "ابدأ محادثة جديدة وستظهر هنا مباشرة.",
        emptyAction: "بدء محادثة",
        groupDevTeam: "فريق التطوير",
        groupFamily: "العائلة",
        previewDevTeam: "Ana: الإصدار 412 ناجح ✅",
        previewPriya: "أراك في السادسة!",
        previewFamily: "أمي: لا تنسَ غداء الأحد",
        previewSam: "الفاتورة في طريقها إليك",
        previewJonas: "ممتاز، شكرًا على السرعة",
        previewAlerts: "اكتمل النشر خلال 3 د 12 ث",
        threadHello: "صباح الخير! هل تمكّنت من مراجعة التصاميم الجديدة؟",
        threadReply: "فتحتها للتو. حالة الفراغ أصبحت أوضح بكثير 🙌",
        threadPhotoCaption: "اخترنا في النهاية التدرّج اللوني الأنعم",
        threadShipIt: "لننشرها إذًا. سألتقط الصور من جديد الليلة.",
        threadOneMore: "ممتاز. أمر أخير —",
        threadBadge: "هل يمكن أن تستخدم شارة غير المقروء لون التمييز؟",
        threadAlreadyDone: "تم ذلك بالفعل، أرفع التعديل الآن.",
        threadThanks: "أنت رائعة، شكرًا جزيلًا!"
    )
}

// MARK: - Environment

private struct StringsKey: EnvironmentKey {
    static let defaultValue = Strings.english
}

extension EnvironmentValues {
    /// Views read their copy from here; `ChatRootView` and the snapshot helpers
    /// derive it from `\.locale`.
    var strings: Strings {
        get { self[StringsKey.self] }
        set { self[StringsKey.self] = newValue }
    }
}

extension View {
    /// Renders this view in `locale`, wiring up both the copy and the layout
    /// direction (Arabic flips to right-to-left).
    func chatLocale(_ locale: Locale) -> some View {
        environment(\.locale, locale)
            .environment(\.strings, Strings.forLocale(locale))
            .environment(\.layoutDirection, locale.identifier.hasPrefix("ar") ? .rightToLeft : .leftToRight)
    }
}
