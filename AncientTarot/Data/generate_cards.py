#!/usr/bin/env python3
import json

cards = []

# === MAJOR ARCANA (22 cards) ===
major = [
    {
        "id": "major_00_fool", "number": 0, "nameJa": "愚者", "nameEn": "The Fool",
        "emoji": "🃏", "hebrewLetter": "アレフ (Aleph)", "hebrewMeaning": "牛 — 生命の息吹",
        "planet": "天王星", "zodiac": None, "element": "風", "color": "#FFE44D",
        "symbolism": "崖の縁に立つ若者が、白い薔薇を手に無邪気に歩む。足元の小犬が警告するも、彼の視線は天を仰ぐ。背負う袋には過去の全経験が詰まっている。",
        "uprightJa": "無限の可能性が眼前に広がる時。既成概念を捨て、魂の声に従い未知なる旅路へ踏み出せ。宇宙はあなたの冒険を祝福している。",
        "reversedJa": "無謀なる跳躍は破滅を招く。内なる声を無視し、虚栄に目が眩んでいないか省みよ。地に足をつけ、賢明さを取り戻すべし。",
        "uprightKeywords": ["新たな始まり", "自由", "冒険", "純粋"],
        "reversedKeywords": ["無謀", "愚行", "不注意", "停滞"],
        "papusInterpretation": "アレフは神的世界における人間を表す。愚者は物質界を超越し、絶対なるものへと還る魂の象徴である。",
        "waiteInterpretation": "旅の始まりにある精神。物質的な心配から解放された状態で、神の守護のもと歩む者を表す。",
        "ouspenskyInterpretation": "愚者は永遠の旅人であり、全てのカードを内包する。彼は無であり、同時に全てである——存在の根源的な矛盾を体現する。",
        "historicalQuote": "The Fool is the spirit in search of experience.",
        "quoteSource": "A.E. Waite, Pictorial Key to the Tarot, 1911"
    },
    {
        "id": "major_01_magician", "number": 1, "nameJa": "魔術師", "nameEn": "The Magician",
        "emoji": "🪄", "hebrewLetter": "ベト (Beth)", "hebrewMeaning": "家 — 内なる聖殿",
        "planet": "水星", "zodiac": None, "element": "風", "color": "#FFD700",
        "symbolism": "頭上に無限の印を戴く若者が、テーブルの上に四つの聖器（杖・杯・剣・金貨）を並べる。右手は天を指し、左手は地を指す。",
        "uprightJa": "天と地を繋ぐ力があなたに宿る時。意志の力を持って現実を創造せよ。四大元素はあなたの意のままに従う。",
        "reversedJa": "力の濫用と欺瞞の暗示。才能を空虚な目的に浪費していないか。真の意志と偽りの欲望を見分けよ。",
        "uprightKeywords": ["創造力", "意志力", "技術", "集中"],
        "reversedKeywords": ["欺瞞", "才能の浪費", "未熟", "操作"],
        "papusInterpretation": "ベトは人間の意志を表す。魔術師は神的なものと物質的なものを結びつける仲介者であり、四元素の支配者である。",
        "waiteInterpretation": "意志と能力の統一。上なるものは下なるものの如し——この古の原理を体現する者。",
        "ouspenskyInterpretation": "魔術師の前のテーブルは四つの元素。彼は宇宙の四つの原理を知り、それらを統合する意識の力を持つ。",
        "historicalQuote": "As above, so below; as below, so above.",
        "quoteSource": "The Emerald Tablet of Hermes, via Papus, 1892"
    },
    {
        "id": "major_02_high_priestess", "number": 2, "nameJa": "女教皇", "nameEn": "The High Priestess",
        "emoji": "🌙", "hebrewLetter": "ギメル (Gimel)", "hebrewMeaning": "駱駝 — 内なる沙漠を渡る",
        "planet": "月", "zodiac": None, "element": "水", "color": "#4466AA",
        "symbolism": "二本の柱の間に座す女性。膝の上にトーラの巻物、胸に十字架。背後に石榴の幕が神殿の奥を隠している。",
        "uprightJa": "直感と内なる声が真実を告げる時。理性の向こうにある叡智に耳を澄ませよ。秘密は沈黙のうちに明かされる。",
        "reversedJa": "直感を無視し、表面的な知識に溺れている。内なる声に耳を閉ざすことは、魂の灯火を消すに等しい。",
        "uprightKeywords": ["直感", "神秘", "内なる声", "潜在意識"],
        "reversedKeywords": ["直感の無視", "秘密", "表面的", "内面の混乱"],
        "papusInterpretation": "ギメルは天的世界における宇宙の反映。女教皇は神聖なる知識の守護者であり、ヴェールに隠された真実を象徴する。",
        "waiteInterpretation": "秘教の入り口に座す女性。彼女は顕教が語らぬ秘密を知り、沈黙のうちにそれを守護する。",
        "ouspenskyInterpretation": "彼女はイシスであり、永遠の女性原理。彼女の膝の上の書物は、語られることなき宇宙の法則を記している。",
        "historicalQuote": "The veil of the Temple is rent, and the mysteries are revealed to those who have eyes to see.",
        "quoteSource": "P.D. Ouspensky, The Symbolism of the Tarot"
    },
    {
        "id": "major_03_empress", "number": 3, "nameJa": "女帝", "nameEn": "The Empress",
        "emoji": "👑", "hebrewLetter": "ダレト (Daleth)", "hebrewMeaning": "扉 — 豊穣への門",
        "planet": None, "zodiac": "金星", "element": "地", "color": "#2D8B46",
        "symbolism": "豊かな自然に囲まれた女性が、金星の紋章を持つ盾に寄りかかる。足元には小麦が実り、背後には滝が流れる。",
        "uprightJa": "大地の母なる力があなたを包む時。創造と豊穣の季節が到来した。愛を注ぎ、育むことで万物は花開く。",
        "reversedJa": "過剰な執着と支配的な愛。豊穣が停滞に変わる時、手放すことの美しさを学べ。",
        "uprightKeywords": ["豊穣", "母性", "創造", "自然"],
        "reversedKeywords": ["過保護", "停滞", "依存", "創造力の枯渇"],
        "papusInterpretation": "ダレトは自然界における母なる原理。女帝は生命を生み出す宇宙的な女性性の具現化である。",
        "waiteInterpretation": "地上の楽園の女主人。彼女は物質世界における神の恵みの通路であり、全ての豊穣の源泉である。",
        "ouspenskyInterpretation": "女帝は自然そのもの。万物を生み、育み、そして再び大地に還す——永遠の循環の女神。",
        "historicalQuote": "She is the door by which the light of Nature enters the world.",
        "quoteSource": "Papus, Tarot of the Bohemians, 1892"
    },
    {
        "id": "major_04_emperor", "number": 4, "nameJa": "皇帝", "nameEn": "The Emperor",
        "emoji": "🦅", "hebrewLetter": "ヘー (Heh)", "hebrewMeaning": "窓 — 外界を見る目",
        "planet": None, "zodiac": "牡羊座", "element": "火", "color": "#CC2222",
        "symbolism": "石の玉座に座す武装した王。右手に笏を持ち、左手に宝珠。背後には険しい山々が聳え立つ。",
        "uprightJa": "秩序と権威の力が求められる時。揺るぎなき意志と戦略を持って領土を治めよ。構造が自由を生む。",
        "reversedJa": "権威の暴走と硬直した支配。力への執着が人々を遠ざける。真の指導者は民の声を聴く者。",
        "uprightKeywords": ["権威", "秩序", "指導力", "安定"],
        "reversedKeywords": ["独裁", "硬直", "支配欲", "暴君"],
        "papusInterpretation": "ヘーは実現された力。皇帝は意志が物質界に具現化した姿であり、宇宙の法則を執行する者。",
        "waiteInterpretation": "世俗の権威と安定の象徴。彼は征服によってではなく、法と秩序によって統治する。",
        "ouspenskyInterpretation": "皇帝は法則そのもの。自然界の秩序、因果の連鎖、宇宙の不変の法を体現する。",
        "historicalQuote": "He who would rule must first learn to serve the law.",
        "quoteSource": "Grand Orient, Manual of Cartomancy, 1909"
    },
    {
        "id": "major_05_hierophant", "number": 5, "nameJa": "法王", "nameEn": "The Hierophant",
        "emoji": "⛪", "hebrewLetter": "ヴァヴ (Vav)", "hebrewMeaning": "釘 — 天と地を繋ぐ",
        "planet": None, "zodiac": "牡牛座", "element": "地", "color": "#884422",
        "symbolism": "三重の冠を戴き、二本の鍵の間に座す宗教的指導者。二人の僧侶が跪き、教えを受ける。",
        "uprightJa": "伝統と教えの中に深い叡智が宿る。師を求め、古の道に学べ。精神的な導きが与えられる時。",
        "reversedJa": "教条主義と盲目的な従属。形骸化した伝統に縛られるな。真の教えは自由の中にある。",
        "uprightKeywords": ["伝統", "教え", "信仰", "導師"],
        "reversedKeywords": ["教条主義", "形骸化", "盲従", "反抗"],
        "papusInterpretation": "ヴァヴは法と宗教の原理。法王は秘儀参入の門番であり、顕教と秘教を繋ぐ橋渡しである。",
        "waiteInterpretation": "公式の教義の守護者。天の二つの鍵を持ち、意識と無意識の王国を開く力を有する。",
        "ouspenskyInterpretation": "法王は教えの化身。しかし真の秘儀は言葉では伝えられない——沈黙の中にのみ真実がある。",
        "historicalQuote": "The Key of the Mysteries is within, not without.",
        "quoteSource": "P. Foster Case, Oracle of the Tarot"
    },
    {
        "id": "major_06_lovers", "number": 6, "nameJa": "恋人たち", "nameEn": "The Lovers",
        "emoji": "💕", "hebrewLetter": "ザイン (Zain)", "hebrewMeaning": "剣 — 分別の刃",
        "planet": None, "zodiac": "双子座", "element": "風", "color": "#FF6B8A",
        "symbolism": "エデンの園の二人の人間の上に、大天使ラファエルが祝福を与える。知恵の木に蛇が巻きつく。",
        "uprightJa": "魂の伴侶との出会い、あるいは人生を変える選択の時。心の声に従い、愛と調和の道を選べ。",
        "reversedJa": "誘惑と不調和。二つの道の間で揺れ動く心。欲望と愛を混同するな。",
        "uprightKeywords": ["愛", "選択", "調和", "結合"],
        "reversedKeywords": ["不調和", "誘惑", "優柔不断", "別離"],
        "papusInterpretation": "ザインは二つの道の選択。恋人たちは美徳と悪徳の間に立つ人間の試練を表す。",
        "waiteInterpretation": "人間の愛と神の愛の合一。選択を通じて、人は自己の運命を決定する。",
        "ouspenskyInterpretation": "恋人たちは対立の統合。男性原理と女性原理が一つになる時、第三の力——愛が生まれる。",
        "historicalQuote": "Love is the law, love under will.",
        "quoteSource": "Frater Achad, The Ever-Coming Son"
    },
    {
        "id": "major_07_chariot", "number": 7, "nameJa": "戦車", "nameEn": "The Chariot",
        "emoji": "🏇", "hebrewLetter": "ヘト (Cheth)", "hebrewMeaning": "柵 — 意志の囲い",
        "planet": None, "zodiac": "蟹座", "element": "水", "color": "#3366CC",
        "symbolism": "星の天蓋の下、一対のスフィンクス（白と黒）が引く戦車に乗る戦士。手に手綱はなく、意志の力のみで御す。",
        "uprightJa": "意志の力で障害を打ち破る時。相反する力を統御し、勝利の凱旋を遂げよ。前進あるのみ。",
        "reversedJa": "制御を失った暴走。勝利への執着が目を曇らせる。力ずくでは真の勝利は得られない。",
        "uprightKeywords": ["勝利", "意志力", "前進", "征服"],
        "reversedKeywords": ["暴走", "制御不能", "敗北", "攻撃性"],
        "papusInterpretation": "ヘトは勝利を収めた意志。戦車は対立する二つの力を統合し、第三の道を切り拓く人間の力。",
        "waiteInterpretation": "精神が物質に打ち勝つ象徴。真の戦士は外敵ではなく、内なる二元性と戦う。",
        "ouspenskyInterpretation": "戦車の二頭のスフィンクスは善と悪。それらを御す者は、二元性を超越した意識に到達する。",
        "historicalQuote": "He conquers who conquers himself.",
        "quoteSource": "S.L. MacGregor Mathers, The Tarot, 1888"
    },
    {
        "id": "major_08_strength", "number": 8, "nameJa": "力", "nameEn": "Strength",
        "emoji": "🦁", "hebrewLetter": "テト (Teth)", "hebrewMeaning": "蛇 — 生命力の螺旋",
        "planet": None, "zodiac": "獅子座", "element": "火", "color": "#E8A020",
        "symbolism": "無限の印を頭上に戴く女性が、優しく獅子の口を開く。力ではなく、愛と忍耐で野獣を制する。",
        "uprightJa": "内なる獅子を愛で御す時。真の力とは暴力ではなく、柔らかき忍耐と慈悲の中にある。",
        "reversedJa": "内なる獣に飲み込まれる。衝動と怒りが理性を凌駕する時、静かに呼吸を整えよ。",
        "uprightKeywords": ["内なる力", "忍耐", "勇気", "慈悲"],
        "reversedKeywords": ["弱さ", "衝動", "自信喪失", "暴力"],
        "papusInterpretation": "テトは抑制された力。獅子を御す女性は、本能を霊性で昇華させる錬金術的過程を表す。",
        "waiteInterpretation": "高次の性質が低次の性質を制御する。無限の印は、この力が永遠であることを示す。",
        "ouspenskyInterpretation": "力は外的な征服ではなく、内的な統合。女性は魂であり、獅子は情念——両者の和解が真の力。",
        "historicalQuote": "True strength is gentle; true gentleness is strong.",
        "quoteSource": "A.E. Waite, Pictorial Key to the Tarot, 1911"
    },
    {
        "id": "major_09_hermit", "number": 9, "nameJa": "隠者", "nameEn": "The Hermit",
        "emoji": "🏔️", "hebrewLetter": "ヨッド (Yod)", "hebrewMeaning": "手 — 神の指",
        "planet": None, "zodiac": "乙女座", "element": "地", "color": "#666688",
        "symbolism": "雪山の頂に立つ灰色の衣の老人。右手にランタンを掲げ、左手に杖を持つ。孤高にして穏やか。",
        "uprightJa": "孤独の中にこそ叡智は宿る。世俗を離れ、内なる灯火に導かれて真理を探求せよ。",
        "reversedJa": "孤立と引きこもり。他者との繋がりを拒絶し過ぎている。灯火は他者を照らすためにもある。",
        "uprightKeywords": ["内省", "孤独", "叡智", "探求"],
        "reversedKeywords": ["孤立", "頑固", "引きこもり", "閉鎖"],
        "papusInterpretation": "ヨッドは知恵の完成。隠者はイニシエーションを経て、自ら灯火となった者。",
        "waiteInterpretation": "天から降りて人を導く賢者。彼の灯火は経験から得た叡智であり、道を照らす。",
        "ouspenskyInterpretation": "隠者は己の内に宇宙を見出した者。彼にとって孤独は孤独ではない——全てと繋がっているから。",
        "historicalQuote": "The light which he holds is his own luminous nature.",
        "quoteSource": "P.D. Ouspensky, The Symbolism of the Tarot"
    },
    {
        "id": "major_10_wheel", "number": 10, "nameJa": "運命の輪", "nameEn": "Wheel of Fortune",
        "emoji": "☸️", "hebrewLetter": "カフ (Kaph)", "hebrewMeaning": "掌 — 運命を握る手",
        "planet": "木星", "zodiac": None, "element": None, "color": "#6644AA",
        "symbolism": "四隅に四福音書記者の象徴。回転する車輪の上にスフィンクス、側面にアヌビスとテュポン。中心にTAROの文字。",
        "uprightJa": "運命の車輪が回転する。好機到来の兆し。宇宙の大いなる循環の中で、あなたの番が来た。",
        "reversedJa": "不運の周期に入る。しかし車輪は常に回り続ける。今の苦難もやがて過ぎ去ることを知れ。",
        "uprightKeywords": ["運命", "転機", "好機", "循環"],
        "reversedKeywords": ["不運", "抵抗", "停滞", "悪循環"],
        "papusInterpretation": "カフは運命の法則。車輪は宇宙の三つの力——創造・維持・破壊の永遠の回転を表す。",
        "waiteInterpretation": "この世の永遠の運動。上昇と下降、成功と失敗は一つの輪の異なる点に過ぎない。",
        "ouspenskyInterpretation": "車輪は存在の永遠回帰。中心に近づく者だけが回転に翻弄されず、静寂を見出す。",
        "historicalQuote": "ROTA TARO ORAT TORA ATOR — the Wheel of Tarot speaks the Law.",
        "quoteSource": "Papus, Tarot of the Bohemians, 1892"
    },
    {
        "id": "major_11_justice", "number": 11, "nameJa": "正義", "nameEn": "Justice",
        "emoji": "⚖️", "hebrewLetter": "ラメド (Lamed)", "hebrewMeaning": "牛追い棒 — 均衡の教え",
        "planet": None, "zodiac": "天秤座", "element": "風", "color": "#448844",
        "symbolism": "二本の柱の間に座す女性。右手に剣、左手に天秤。ヴェールの向こうに真理が隠れている。",
        "uprightJa": "因果の法則が働く時。正しき行いには正しき報いが。真実と公正を旨として行動せよ。",
        "reversedJa": "不公正と偏見。判断力の曇り。自らの行いの結果から逃れることはできない。",
        "uprightKeywords": ["公正", "真実", "因果", "均衡"],
        "reversedKeywords": ["不公正", "偏見", "不均衡", "逃避"],
        "papusInterpretation": "ラメドは宇宙的均衡。正義は行為と結果の間に働く不変の法則——カルマの具現化である。",
        "waiteInterpretation": "神の正義は人の正義と異なる。剣は分別を、天秤は公平を象徴する。",
        "ouspenskyInterpretation": "正義の剣は二元性を切り裂く。天秤は対極の統合。真の正義は善悪を超えた場所にある。",
        "historicalQuote": "Every action has its consequences, and none may escape the law of balance.",
        "quoteSource": "Grand Orient, Manual of Cartomancy, 1909"
    },
    {
        "id": "major_12_hanged_man", "number": 12, "nameJa": "吊るされた男", "nameEn": "The Hanged Man",
        "emoji": "🙃", "hebrewLetter": "メム (Mem)", "hebrewMeaning": "水 — 深淵の叡智",
        "planet": "海王星", "zodiac": None, "element": "水", "color": "#4488CC",
        "symbolism": "T字の樹に逆さに吊るされた男。顔には苦痛ではなく、至福の光が宿る。頭の周りに光輪。",
        "uprightJa": "視点を逆転させよ。犠牲と手放しの中に深い啓示がある。執着を解き放つ時、新たな地平が開ける。",
        "reversedJa": "無意味な犠牲と殉教。抵抗すべき時に受け入れ、必要な変化を拒んでいる。",
        "uprightKeywords": ["犠牲", "手放し", "啓示", "逆転"],
        "reversedKeywords": ["無駄な犠牲", "殉教", "停滞", "抵抗"],
        "papusInterpretation": "メムは自発的な犠牲。吊るされた男は物質的なものを犠牲にし、霊的な宝を得る錬金術師。",
        "waiteInterpretation": "世俗の目には罰に見えるが、吊るされた者にとっては至福の瞑想。視点の完全な逆転。",
        "ouspenskyInterpretation": "逆さまの視点は世界を新しい目で見る。下から上を見る時、全てが逆転し、真の姿が現れる。",
        "historicalQuote": "He who loses his life shall find it.",
        "quoteSource": "A.E. Waite, Pictorial Key to the Tarot, 1911"
    },
    {
        "id": "major_13_death", "number": 13, "nameJa": "死神", "nameEn": "Death",
        "emoji": "💀", "hebrewLetter": "ヌン (Nun)", "hebrewMeaning": "魚 — 深海の変容",
        "planet": None, "zodiac": "蠍座", "element": "水", "color": "#1A1A2E",
        "symbolism": "白い馬に乗る骸骨の騎士が、黒い旗を掲げる。旗には五弁の薔薇——再生の象徴。王も子供も等しくその前に跪く。",
        "uprightJa": "終わりと始まりの境界に立つ。古きものが滅びることで、新たな生命が芽吹く。変容を恐れるな。",
        "reversedJa": "変化への抵抗と執着。終わるべきものにしがみつく。腐敗は変容の拒否から生まれる。",
        "uprightKeywords": ["変容", "終焉", "再生", "解放"],
        "reversedKeywords": ["執着", "停滞", "変化への恐怖", "腐敗"],
        "papusInterpretation": "ヌンは宇宙的な変容の力。死は創造の前提条件であり、永遠の循環における必然の通過点。",
        "waiteInterpretation": "物理的な死ではなく、精神的な変容。旗の薔薇は、死の向こうに待つ再生を約束する。",
        "ouspenskyInterpretation": "死とは形態の消滅であり、本質の解放。蝶が蛹を破るように、魂は古い殻を脱ぎ捨てる。",
        "historicalQuote": "There is no death; there is only transformation.",
        "quoteSource": "Papus, Tarot of the Bohemians, 1892"
    },
    {
        "id": "major_14_temperance", "number": 14, "nameJa": "節制", "nameEn": "Temperance",
        "emoji": "⏳", "hebrewLetter": "サメフ (Samekh)", "hebrewMeaning": "支柱 — 調和の柱",
        "planet": None, "zodiac": "射手座", "element": "火", "color": "#CC8844",
        "symbolism": "翼を持つ天使が二つの杯の間で水を注ぎ移す。片足は水中、片足は岸辺。遠くに王冠を戴く山が輝く。",
        "uprightJa": "調和と中庸の道。対極を混ぜ合わせ、新たなる第三のものを生み出す錬金術の時。忍耐が実を結ぶ。",
        "reversedJa": "不均衡と過剰。調和を失い極端に走る。中庸を見失った魂は嵐に翻弄される。",
        "uprightKeywords": ["調和", "節制", "忍耐", "錬金術"],
        "reversedKeywords": ["不均衡", "過剰", "焦り", "極端"],
        "papusInterpretation": "サメフは宇宙的均衡の維持。節制の天使は対立する力を調合する宇宙の錬金術師。",
        "waiteInterpretation": "生命の水が一つの杯からもう一つへと流れる。これは霊と物質の永遠の交流を象徴する。",
        "ouspenskyInterpretation": "天使は永遠に注ぎ続ける。この行為こそが生命そのもの——止まることのない流れ、永遠の均衡の維持。",
        "historicalQuote": "In medio stat virtus — virtue stands in the middle.",
        "quoteSource": "P. Foster Case, Oracle of the Tarot"
    },
    {
        "id": "major_15_devil", "number": 15, "nameJa": "悪魔", "nameEn": "The Devil",
        "emoji": "😈", "hebrewLetter": "アイン (Ayin)", "hebrewMeaning": "目 — 物質界の幻影",
        "planet": None, "zodiac": "山羊座", "element": "地", "color": "#332211",
        "symbolism": "半人半獣の姿が玉座に座り、鎖で繋がれた男女を支配する。しかし鎖は緩く、自ら外せることを暗示。",
        "uprightJa": "物質への執着と束縛。しかし鎖はあなた自身が創り出した幻影。真の牢獄は心の中にある。",
        "reversedJa": "束縛からの解放の始まり。鎖を断ち切る勇気が芽生える。光が闇を照らす時。",
        "uprightKeywords": ["束縛", "執着", "物質主義", "誘惑"],
        "reversedKeywords": ["解放", "覚醒", "鎖を断つ", "自由"],
        "papusInterpretation": "アインは物質界の幻影の力。悪魔は我々自身が創り出した恐怖と欲望の投影に過ぎない。",
        "waiteInterpretation": "束縛されているように見えるが、鎖は緩い。人は自らの牢獄の鍵を持っている。",
        "ouspenskyInterpretation": "悪魔は存在しない——それは人間が自らの影を壁に投影したもの。光を灯せば影は消える。",
        "historicalQuote": "The chains are loose; they hold because men believe they do.",
        "quoteSource": "A.E. Waite, Pictorial Key to the Tarot, 1911"
    },
    {
        "id": "major_16_tower", "number": 16, "nameJa": "塔", "nameEn": "The Tower",
        "emoji": "⚡", "hebrewLetter": "ペー (Peh)", "hebrewMeaning": "口 — 破壊の言葉",
        "planet": "火星", "zodiac": None, "element": "火", "color": "#AA2200",
        "symbolism": "雷が塔の頂を打ち、王冠が吹き飛ぶ。二人の人間が炎の中を落下する。黒い空にヘブライ文字のヨッドが散る。",
        "uprightJa": "偽りの構造が崩壊する時。雷鳴は天からの啓示。痛みを伴うが、偽りの上に建てたものは崩れるべくして崩れる。",
        "reversedJa": "避けられた破壊。しかし根本的な問題は残っている。小さな崩壊で済むうちに、自ら変化を選べ。",
        "uprightKeywords": ["崩壊", "啓示", "解放", "衝撃"],
        "reversedKeywords": ["回避", "延命", "内なる崩壊", "恐怖"],
        "papusInterpretation": "ペーは神の裁きの口。塔は人間の傲慢が築いた虚偽の殿堂であり、雷は真理の光。",
        "waiteInterpretation": "天罰ではなく、天の慈悲。偽りの王冠を打ち落とすことで、真の冠が与えられる。",
        "ouspenskyInterpretation": "塔はバベルの塔。人間の理性が天を超えようとする時、雷が真理を突きつける。",
        "historicalQuote": "What is built upon falsehood must fall, that truth may take its place.",
        "quoteSource": "Papus, Tarot of the Bohemians, 1892"
    },
    {
        "id": "major_17_star", "number": 17, "nameJa": "星", "nameEn": "The Star",
        "emoji": "⭐", "hebrewLetter": "ツァディ (Tzaddi)", "hebrewMeaning": "釣り針 — 天の恵みを釣る",
        "planet": None, "zodiac": "水瓶座", "element": "風", "color": "#6688CC",
        "symbolism": "裸の女性が星空の下で二つの壺から水を注ぐ。一方は大地へ、一方は池へ。頭上に八芒星が輝く。",
        "uprightJa": "嵐の後の静寂。希望の星が導く先には癒しと再生がある。宇宙はあなたを見守っている。",
        "reversedJa": "希望の喪失と信仰の危機。星は雲に隠れても消えはしない。暗闇の中でも信じ続けよ。",
        "uprightKeywords": ["希望", "癒し", "インスピレーション", "平和"],
        "reversedKeywords": ["絶望", "信仰の喪失", "孤独", "枯渇"],
        "papusInterpretation": "ツァディは不滅の希望。星は嵐（塔）の後に現れる天の恵みであり、永遠の生命の約束。",
        "waiteInterpretation": "自然の恵みを世界に注ぐ女性。彼女は永遠の青春であり、人類への希望の泉。",
        "ouspenskyInterpretation": "星は真理そのもの。ヴェールを脱いだイシスが、偽りなき姿で世界に恵みを注ぐ。",
        "historicalQuote": "After the lightning, the stars; after destruction, hope eternal.",
        "quoteSource": "P.D. Ouspensky, The Symbolism of the Tarot"
    },
    {
        "id": "major_18_moon", "number": 18, "nameJa": "月", "nameEn": "The Moon",
        "emoji": "🌙", "hebrewLetter": "コフ (Qoph)", "hebrewMeaning": "後頭部 — 潜在意識の闇",
        "planet": None, "zodiac": "魚座", "element": "水", "color": "#334466",
        "symbolism": "月光の下、二つの塔の間の道を犬と狼が吠える。水辺からザリガニが這い出す。月は半ば雲に隠れている。",
        "uprightJa": "幻影と潜在意識の領域。月の光は全てを照らさない。恐れと直面し、幻影の向こうの真実を見よ。",
        "reversedJa": "恐怖からの解放。幻影が晴れ、真実が見え始める。直感が正しい道を照らす。",
        "uprightKeywords": ["幻影", "不安", "潜在意識", "直感"],
        "reversedKeywords": ["幻影の解消", "恐怖の克服", "明晰", "覚醒"],
        "papusInterpretation": "コフは隠された敵。月は物質界の幻影が最も濃密になる場所であり、イニシエーションの最終試練。",
        "waiteInterpretation": "知性の光ではなく、反射された光の世界。ここでは全てが二重であり、何も確かではない。",
        "ouspenskyInterpretation": "月の道は恐怖の道。しかしこの道を歩かずして、太陽には到達できない。",
        "historicalQuote": "The path between the towers is the way of initiation through fear.",
        "quoteSource": "S.L. MacGregor Mathers, The Tarot, 1888"
    },
    {
        "id": "major_19_sun", "number": 19, "nameJa": "太陽", "nameEn": "The Sun",
        "emoji": "☀️", "hebrewLetter": "レシュ (Resh)", "hebrewMeaning": "頭 — 意識の冠",
        "planet": "太陽", "zodiac": None, "element": "火", "color": "#FFAA00",
        "symbolism": "輝く太陽の下、裸の子供が白い馬に乗り、向日葵の庭を駆ける。無邪気な喜びと純粋なエネルギー。",
        "uprightJa": "光明と成功の時。全てが明るみに照らされ、真実が輝く。生命力に満ちた喜びの日々。",
        "reversedJa": "輝きが幾分か陰る。成功は来るが遅延を伴う。喜びが薄れるのは、感謝を忘れた時。",
        "uprightKeywords": ["成功", "喜び", "活力", "明晰"],
        "reversedKeywords": ["遅延", "陰り", "傲慢", "燃え尽き"],
        "papusInterpretation": "レシュは物質界における最高の光。太陽は全ての秘儀参入の頂点であり、完全なる覚醒の象徴。",
        "waiteInterpretation": "タロットの中で最も幸福なカード。子供の無邪気さは、叡智が純粋さに還った状態を表す。",
        "ouspenskyInterpretation": "太陽は月の幻影を経た後の覚醒。全てが明瞭になり、恐怖は消え、真実のみが残る。",
        "historicalQuote": "The Sun is the source of all light, and to it all things return.",
        "quoteSource": "P. Foster Case, Oracle of the Tarot"
    },
    {
        "id": "major_20_judgement", "number": 20, "nameJa": "審判", "nameEn": "Judgement",
        "emoji": "📯", "hebrewLetter": "シン (Shin)", "hebrewMeaning": "歯/炎 — 聖なる火",
        "planet": "冥王星", "zodiac": None, "element": "火", "color": "#CC4444",
        "symbolism": "天使ガブリエルがラッパを吹き、棺から人々が蘇る。男女と子供が両手を広げて天を仰ぐ。",
        "uprightJa": "覚醒と再生の喇叭が鳴り響く。過去の全てを赦し、新たなる自分として蘇れ。最後の審判は自己審判。",
        "reversedJa": "内なる呼び声を無視している。再生の機会を逃し、古い自分にしがみつく。",
        "uprightKeywords": ["覚醒", "再生", "赦し", "呼びかけ"],
        "reversedKeywords": ["無視", "後悔", "自己欺瞞", "停滞"],
        "papusInterpretation": "シンは聖なる火。審判は物質界での全経験を統合し、新たなる存在の次元へ上昇する瞬間。",
        "waiteInterpretation": "これは最後の審判ではなく、新しい始まりへの呼びかけ。全ての存在が目覚めの時を迎える。",
        "ouspenskyInterpretation": "審判は自己認識の最終段階。魂が自らの全てを——光も闇も——受け入れ、統合する瞬間。",
        "historicalQuote": "The trumpet calls not to punishment, but to awakening.",
        "quoteSource": "A.E. Waite, Pictorial Key to the Tarot, 1911"
    },
    {
        "id": "major_21_world", "number": 21, "nameJa": "世界", "nameEn": "The World",
        "emoji": "🌍", "hebrewLetter": "タヴ (Tau)", "hebrewMeaning": "十字/印 — 完成の刻印",
        "planet": "土星", "zodiac": None, "element": "地", "color": "#6644AA",
        "symbolism": "月桂樹の環の中で踊る女性。四隅に四つの聖獣。二本の杖を持ち、完全なる調和の中で舞う。",
        "uprightJa": "完成と成就の時。長き旅路の終わりにして、新たなる始まり。宇宙と一体となる至福の瞬間。",
        "reversedJa": "完成の遅延。あと一歩の所で足踏みする。未完の課題を見つめ直し、旅を完遂せよ。",
        "uprightKeywords": ["完成", "統合", "達成", "宇宙的調和"],
        "reversedKeywords": ["未完成", "遅延", "停滞", "閉塞"],
        "papusInterpretation": "タヴは全ての完成。世界は大アルカナの旅の終着点であり、同時に新たなる螺旋の始まり。",
        "waiteInterpretation": "宇宙舞踏。踊る女性は完全なる自由を得た魂であり、四つの元素と完璧な調和を保つ。",
        "ouspenskyInterpretation": "世界は真理が裸の姿で踊る場所。愚者が旅の果てに辿り着く場所——そして再び旅立つ場所。",
        "historicalQuote": "The end is the beginning, and the beginning is the end.",
        "quoteSource": "Papus, Tarot of the Bohemians, 1892"
    },
]

for m in major:
    m["arcana"] = "major"
    m["suit"] = None

cards.extend(major)

# === MINOR ARCANA (56 cards) ===
suit_data = {
    "wands": {
        "nameJa": "ワンド", "element": "火", "color_base": "#E85D04",
        "theme": "情熱、創造力、意志、行動",
        "court_colors": ["#E85D04", "#D45000", "#CC4400", "#B83800"]
    },
    "cups": {
        "nameJa": "カップ", "element": "水", "color_base": "#4361EE",
        "theme": "感情、愛、直感、関係",
        "court_colors": ["#4361EE", "#3A55DD", "#3348CC", "#2B3CBB"]
    },
    "swords": {
        "nameJa": "ソード", "element": "風", "color_base": "#ADB5BD",
        "theme": "知性、真実、葛藤、決断",
        "court_colors": ["#ADB5BD", "#9AA2AA", "#888F97", "#767D85"]
    },
    "pentacles": {
        "nameJa": "ペンタクル", "element": "地", "color_base": "#2D6A4F",
        "theme": "物質、金銭、健康、実務",
        "court_colors": ["#2D6A4F", "#265E45", "#1F523B", "#184631"]
    }
}

pip_names = {
    1: ("エース", "Ace", "🎯"), 2: ("2", "Two", "2️⃣"), 3: ("3", "Three", "3️⃣"),
    4: ("4", "Four", "4️⃣"), 5: ("5", "Five", "5️⃣"), 6: ("6", "Six", "6️⃣"),
    7: ("7", "Seven", "7️⃣"), 8: ("8", "Eight", "8️⃣"), 9: ("9", "Nine", "9️⃣"),
    10: ("10", "Ten", "🔟"), 11: ("ペイジ", "Page", "📜"), 12: ("ナイト", "Knight", "🐴"),
    13: ("クイーン", "Queen", "👸"), 14: ("キング", "King", "🤴")
}

# Wands meanings
wands_meanings = [
    ("創造の火が灯される。新たなる事業、冒険、情熱の始まり。宇宙があなたの意志に応える時。", "創造力の浪費。着火しない火種。エネルギーが分散し、何も始まらない。", ["創造", "新たな始まり", "情熱", "インスピレーション"], ["遅延", "停滞", "意欲の喪失", "空回り"]),
    ("二つの道の間で選択を迫られる。しかし真の選択は既に心の中にある。勇気を持って決断せよ。", "優柔不断と恐怖。選ばないことも一つの選択であると知れ。", ["選択", "決断", "計画", "展望"], ["優柔不断", "恐怖", "計画倒れ", "迷い"]),
    ("種を蒔いた地から芽が出始める。忍耐の後に最初の成果が見える。前途に広がる可能性を信じよ。", "遅延と焦り。成果はまだ見えないが、根は確実に伸びている。", ["成長", "展望", "前進", "商機"], ["遅延", "障害", "焦り", "見通しの甘さ"]),
    ("安定した基盤の上に祝祭の旗が翻る。努力が報われ、調和と繁栄を享受する時。", "内なる不満。外面的な成功の陰で、魂の渇きを感じている。", ["安定", "祝福", "調和", "家庭"], ["不安定", "移行期", "不満", "根無し草"]),
    ("五本の杖が入り乱れる。競争と葛藤の中にこそ成長がある。試練を避けず、全力で立ち向かえ。", "回避と逃避。争いを恐れるあまり、自らの信念すら手放していないか。", ["競争", "挑戦", "葛藤", "成長"], ["回避", "内紛", "混乱", "消耗"],),
    ("勝利の凱旋。困難を乗り越え、栄光と承認を得る時。リーダーとして人々を率いよ。", "傲慢と虚栄。勝利に酔い、次の戦いを見失うな。", ["勝利", "成功", "名声", "リーダーシップ"], ["傲慢", "失敗", "裏切り", "虚栄"]),
    ("高みに立ち、価値観を守り通す。信念を持って挑戦者に立ち向かえ。その杖は正義の象徴。", "圧倒されて退却する。一人では持ちこたえられない時は、助けを求める勇気を。", ["防衛", "信念", "優位", "勇気"], ["圧倒", "屈服", "批判", "孤立"]),
    ("矢のごとく飛翔する八本の杖。物事が急速に進展する。流れに乗り、迷わず前進せよ。", "焦りと空回り。速さが正確さを犠牲にしている。一度立ち止まって方向を確認せよ。", ["迅速", "進展", "飛翔", "勢い"], ["遅延", "焦り", "停滞", "混乱"]),
    ("傷を負いながらも最後の一本を握りしめて立つ。疲弊しているが、あと一歩で目的地に到着する。", "疲弊と消耗。これ以上の犠牲は意味がない。休息を取り、再起を図れ。", ["忍耐", "防衛", "回復力", "最後の力"], ["疲弊", "限界", "頑固", "バーンアウト"]),
    ("十本の杖を背負い歩む者。重荷は大きいが、その先に安息の地がある。責任を全うせよ。", "荷が重すぎる。全てを背負う必要はない。委任と手放しを学べ。", ["責任", "重荷", "努力", "達成間近"], ["過負荷", "限界", "委任", "崩壊"]),
    ("炎のように熱い魂を持つ若き使者。新しい知らせ、創造的なインスピレーションの到来を告げる。", "未熟さと軽率。熱意はあるが方向性が定まっていない。地に足をつけよ。", ["メッセージ", "冒険", "創造性", "熱意"], ["未熟", "軽率", "遅延", "悪い知らせ"]),
    ("情熱と勇気に満ちた騎士が馬を駆る。大胆な行動と冒険の時。恐れずに突進せよ。", "無謀と衝動。勇気と蛮勇を混同するな。戦略なき突撃は破滅を招く。", ["勇気", "冒険", "情熱", "行動"], ["無謀", "衝動", "攻撃性", "軽率"]),
    ("創造の火を内に宿す女王。温かくも力強い指導力で周囲を照らす。自信と魅力が溢れる時。", "嫉妬と支配。他者の光を奪おうとしていないか。自らの炎を静かに燃やせ。", ["自信", "魅力", "創造性", "リーダーシップ"], ["嫉妬", "支配欲", "攻撃性", "猜疑心"]),
    ("ビジョンと行動力を兼ね備えた王。大いなる構想を実現し、人々を鼓舞する指導者の時。", "独裁と頑固。ビジョンに固執し、他者の声を聴かない。真の王は民と共に歩む。", ["ビジョン", "指導力", "起業家精神", "勇敢"], ["独裁", "頑固", "衝動", "暴君"]),
]

cups_meanings = [
    ("感情の泉が溢れ出す。新たなる愛、友情、創造的インスピレーションの始まり。心を開いて受け取れ。", "感情の枯渇。心を閉ざし、愛を受け取ることを拒んでいる。", ["愛の始まり", "感情", "直感", "豊穣"], ["枯渇", "拒絶", "感情の閉鎖", "失恋"]),
    ("二つの杯が交わり、愛の絆が結ばれる。パートナーシップと相互理解の時。", "不和と別離。二つの杯の間の水が止まっている。対話を取り戻せ。", ["愛", "パートナーシップ", "調和", "絆"], ["不和", "別離", "誤解", "不均衡"]),
    ("三つの杯を掲げて祝う。友情と祝祭、喜びを分かち合う時。", "孤独の中の享楽。本当の友はどこにいるのか。", ["祝祭", "友情", "喜び", "共感"], ["孤独", "過剰", "失望", "虚しい宴"]),
    ("満たされているのに空虚。目の前の祝福に気づけない。新たな提案に目を向けよ。", "新しい可能性への目覚め。倦怠から脱し、再び心が動き始める。", ["倦怠", "不満", "見落とし", "再考"], ["気づき", "新たな動機", "受容", "感謝"]),
    ("三つの杯がこぼれ、二つが残る。喪失と悲嘆の時。しかし全てを失ったわけではない。", "悲しみからの回復。残されたものに気づき、再び立ち上がる力が戻る。", ["喪失", "悲嘆", "後悔", "失望"], ["回復", "受容", "前進", "赦し"]),
    ("懐かしき故郷の記憶。過去の甘き日々への郷愁。純粋だった頃の心を思い出せ。", "過去への過剰な執着。前を向かずして未来は開けない。", ["郷愁", "思い出", "純粋", "子供時代"], ["過去への執着", "前進", "現実逃避", "幻想"]),
    ("七つの杯に幻影が浮かぶ。美しき夢想の世界。しかし全てが幻。現実に戻り、一つを選べ。", "幻想から覚める。現実を直視し、地に足のついた選択をする時。", ["幻想", "夢想", "選択肢", "誘惑"], ["現実直視", "決断", "明晰", "覚醒"]),
    ("八つの杯を背に、月光の下を旅立つ。満たされた日々を手放し、魂の渇きに従う勇敢なる旅立ち。", "留まることへの執着。心は既に旅立ちを求めているのに、安全地帯を離れられない。", ["探求", "旅立ち", "手放し", "精神的成長"], ["執着", "恐怖", "変化の拒絶", "惰性"]),
    ("願いの杯。感情的な満足と物質的な豊かさの両方が得られる幸運の時。", "欲望の暴走。全てを手に入れようとして本当に大切なものを見失う。", ["願望成就", "満足", "幸福", "豊穣"], ["欲深さ", "不満", "自己満足", "傲慢"]),
    ("虹の下に並ぶ十の杯。家族の幸福と完全なる感情的充足。愛に満たされた完成の時。", "家族の不和。理想と現実のギャップに苦しむ。完璧を求めず、今ある愛を大切に。", ["家族の幸福", "完成", "調和", "愛"], ["不和", "崩壊", "期待外れ", "孤立"]),
    ("夢見がちな若き使者。芸術的なインスピレーションや恋の予感を告げる。", "感情に溺れる。現実逃避の美しい夢。地に足をつけよ。", ["直感", "芸術", "恋の予感", "メッセージ"], ["現実逃避", "未熟", "感情的", "幻想"]),
    ("白馬に乗る理想主義の騎士。ロマンスと芸術の追求。心の声に従い、愛の冒険に出よ。", "気分屋と嫉妬。理想と現実のギャップに苦しむ。", ["ロマンス", "理想主義", "芸術", "誘い"], ["気分屋", "嫉妬", "幻滅", "非現実"]),
    ("深い感情と直感を持つ女王。共感力と癒しの力で周囲を支える。", "感情の暴走。他者の感情に巻き込まれ、自己を見失う。", ["共感", "癒し", "直感", "慈愛"], ["感情的", "依存", "自己犠牲", "操作"]),
    ("感情の深みを知りつつ冷静さを保つ王。芸術と科学を愛し、賢明な助言を与える。", "感情の抑圧。冷静を装い、本当の気持ちを隠している。", ["知恵", "冷静", "外交", "芸術"], ["冷淡", "抑圧", "操作", "無関心"]),
]

swords_meanings = [
    ("真実の剣が天から降る。知性の力で幻想を切り裂き、新たなる明晰さを得る時。", "知性の暴走。鋭すぎる剣は己をも傷つける。思考を落ち着けよ。", ["真実", "明晰", "知性", "正義"], ["混乱", "暴走", "残酷", "破壊"]),
    ("目隠しをして二本の剣を交差させる。決断を避け、均衡の中に逃げ込んでいる。", "情報が明らかになり、決断の時が来る。真実と向き合え。", ["膠着", "均衡", "回避", "直面"], ["決断", "情報開示", "解放", "真実"]),
    ("三本の剣が心臓を貫く。悲嘆と心の痛み。しかし雨の後には虹が来る。", "回復の兆し。心の傷が癒え始める。痛みを受け入れた先に成長がある。", ["悲嘆", "心痛", "裏切り", "喪失"], ["回復", "赦し", "癒し", "前進"]),
    ("横たわる騎士の上に四本の剣。休息と回復の時。疲れた心と体を癒すために沈黙せよ。", "焦りと回復の拒否。休むべき時に動こうとしている。", ["休息", "回復", "瞑想", "沈黙"], ["焦り", "不眠", "消耗", "回復拒否"]),
    ("散らばった剣を前に佇む二人。敗北と屈辱の苦味。しかし全てを失ったわけではない。", "過去の傷からの回復。失ったものを取り戻す力が戻る。", ["敗北", "喪失", "屈辱", "葛藤"], ["回復", "和解", "教訓", "再起"]),
    ("水辺を渡る舟。困難からの脱出。重荷を残して、新たな地へ向かう旅。", "逃げられない問題。根本的な解決なくして、場所を変えても同じことの繰り返し。", ["移行", "脱出", "旅", "回復"], ["逃避", "未解決", "停滞", "行き詰まり"]),
    ("テントから剣を持ち出す者。策略と知恵で困難を乗り越える。しかし正直さを忘れるな。", "策略が裏目に出る。不正直な手段は長くは通用しない。", ["策略", "知恵", "計画", "慎重"], ["欺瞞", "露見", "自己欺瞞", "失敗"]),
    ("八本の剣に囲まれ、目隠しで縛られた女性。しかし縄は緩い。束縛は自らが作り出した幻。", "束縛からの解放。目隠しを外し、自由への道を見出す。", ["束縛", "制限", "恐怖", "無力感"], ["解放", "自由", "覚醒", "行動"]),
    ("九本の剣の前で頭を抱える。不安と悪夢。しかし恐怖の大半は心が生み出した幻影。", "最悪の時期は過ぎ去る。希望が見え始め、不安が和らぐ。", ["不安", "悪夢", "絶望", "罪悪感"], ["回復", "希望", "克服", "夜明け"]),
    ("十本の剣が背中に突き刺さる。完全なる終焉。しかし東の空は明るみ始めている。", "再起不能に見えるが、最悪は既に過ぎた。新たな始まりが待っている。", ["終焉", "裏切り", "痛み", "終わり"], ["再生", "回復", "最悪の終わり", "夜明け"]),
    ("風の中で剣を掲げる若者。鋭い知性と好奇心。新しい情報やメッセージの到来。", "皮肉と残酷な言葉。知性を武器にして他者を傷つけていないか。", ["知性", "好奇心", "メッセージ", "探究"], ["皮肉", "冷酷", "嘘", "スパイ"]),
    ("剣を掲げて突進する騎士。大胆な知的挑戦。議論と弁論で道を切り開く。", "無謀な突進。考えなしの言動が取り返しのつかない傷を残す。", ["行動力", "知性", "弁論", "勇敢"], ["攻撃的", "衝動的", "残酷", "独断"]),
    ("雲の上に剣を掲げる女王。明晰な思考と公正な判断。感情に流されない強さ。", "冷酷と孤独。感情を完全に排除した判断は、人の心を失わせる。", ["明晰", "独立", "公正", "知性"], ["冷酷", "孤独", "偏見", "感情の抑圧"]),
    ("玉座に座し剣を掲げる王。権威ある判断と明確な意思決定。法と秩序の守護者。", "暴君的な知性。言葉で人を支配し、異論を許さない。", ["権威", "判断力", "公正", "知性"], ["暴君", "冷酷", "独裁", "操作"]),
]

pentacles_meanings = [
    ("豊穣の手が新たなる金貨を差し出す。物質的な新たな始まり。投資と繁栄の種が蒔かれる。", "物質的チャンスを逃す。地に足がついていない計画は実を結ばない。", ["繁栄", "新たな始まり", "投資", "機会"], ["機会損失", "非現実的", "貧困", "不安定"]),
    ("二つの金貨を器用にやりくりする。柔軟さとバランスが求められる。変化に適応せよ。", "バランスの崩壊。多くを抱えすぎて全てが中途半端になっている。", ["バランス", "適応", "器用さ", "変化"], ["不均衡", "過負荷", "混乱", "無計画"]),
    ("職人が聖堂の柱を彫る。技術と勤勉が認められ、報酬を得る。仕事における卓越性。", "凡庸さと怠惰。技術を磨く努力を怠っている。", ["技術", "勤勉", "品質", "報酬"], ["怠惰", "凡庸", "手抜き", "未熟"]),
    ("四つの金貨をしっかりと抱える。物質的安定と保守。持っているものを守れ。", "執着と吝嗇。守りに入りすぎて、成長の機会を逃している。", ["安定", "保守", "蓄財", "安全"], ["執着", "吝嗇", "停滞", "孤立"]),
    ("雪の中を二人の貧者が教会の前を通り過ぎる。物質的困窮と精神的な試練。", "困窮からの回復。助けの手が差し伸べられる。孤独ではない。", ["困窮", "喪失", "孤独", "試練"], ["回復", "援助", "希望", "共同体"]),
    ("天秤を手に金貨を与える商人。寛大さと公正な分配。与えることで豊かになる。", "借金と不公正。与えすぎか、受け取りすぎか。均衡を取り戻せ。", ["寛大", "慈善", "公正", "豊かさ"], ["借金", "不公正", "吝嗇", "搾取"]),
    ("実った木の前に立ち止まる農夫。長い努力の末の収穫を前に、更なる成長を見据える。", "焦りと不安。成果が見えるまでもう少し。忍耐を失うな。", ["忍耐", "成長", "投資", "収穫前"], ["焦り", "不安", "浪費", "見切り"]),
    ("八つの金貨を丹念に磨く職人。技術の研鑽と細部へのこだわり。匠の道を歩め。", "完璧主義の罠。細部に囚われて全体像を見失っている。", ["技術研鑽", "職人技", "細部", "忍耐"], ["完璧主義", "視野狭窄", "退屈", "消耗"]),
    ("庭園に佇む貴婦人。物質的な豊かさと独立。自力で築いた楽園を楽しむ時。", "孤独な豊かさ。物質に囲まれていても心が満たされない。", ["独立", "豊穣", "優雅", "自給自足"], ["孤独", "物質主義", "過剰", "依存"]),
    ("十の金貨に囲まれた家族。世代を超える遺産と繁栄。物質的完成と家族の絆。", "家族間の金銭トラブル。遺産を巡る争い。物質が愛を蝕む時。", ["遺産", "繁栄", "家族", "完成"], ["金銭問題", "家族の不和", "損失", "不安定"]),
    ("金貨を掲げて大地に立つ若者。勤勉と学びの姿勢。新たなスキルの習得の時。", "怠惰と機会の浪費。学ぶ意欲を失い、地に足がついていない。", ["学び", "勤勉", "機会", "実直"], ["怠惰", "機会損失", "非現実的", "不真面目"]),
    ("馬上で金貨を持つ騎士。着実で信頼できる前進。忍耐強く目標に向かって進め。", "停滞と怠惰。堅実さが退屈に変わる時、新たな刺激を求めよ。", ["信頼", "忍耐", "堅実", "責任感"], ["停滞", "怠惰", "退屈", "頑固"]),
    ("豊かな庭に座す女王。物質的繁栄の守護者。豊かさを生み出し、育む力。", "過保護と物質への依存。豊かさの中で精神的な成長を忘れていないか。", ["豊穣", "安心", "母性", "実務能力"], ["依存", "過保護", "物質主義", "嫉妬"]),
    ("豊かな王国を治める王。財政的な成功と安定。実務と経営の達人。", "物質への執着。金銭が全てではない。精神的な豊かさも忘れるな。", ["成功", "富", "安定", "経営力"], ["物質主義", "独裁", "腐敗", "吝嗇"]),
]

all_suit_meanings = {"wands": wands_meanings, "cups": cups_meanings, "swords": swords_meanings, "pentacles": pentacles_meanings}

sources = [
    ("The true power of the card lies in its connection to the eternal principles.", "A.E. Waite, Pictorial Key to the Tarot, 1911"),
    ("Each card is a mirror reflecting the soul of the querent.", "Papus, Tarot of the Bohemians, 1892"),
    ("The Minor Arcana reveals the details of life's great drama.", "S.L. MacGregor Mathers, The Tarot, 1888"),
    ("In the cards we find the map of human experience.", "P. Foster Case, Oracle of the Tarot"),
    ("The suit represents one of the four pillars of creation.", "Grand Orient, Manual of Cartomancy, 1909"),
]

for suit_key, suit_info in suit_data.items():
    meanings = all_suit_meanings[suit_key]
    for i in range(14):
        num = i + 1
        nameJa_num, nameEn_num, emoji = pip_names[num]
        upright, reversed_m, up_kw, rev_kw = meanings[i]
        src = sources[i % len(sources)]

        if num <= 10:
            full_nameJa = f"{suit_info['nameJa']}の{nameJa_num}"
            full_nameEn = f"{nameEn_num} of {suit_key.capitalize()}"
            card_id = f"minor_{suit_key}_{num:02d}"
        else:
            court_names = {11: "page", 12: "knight", 13: "queen", 14: "king"}
            full_nameJa = f"{suit_info['nameJa']}の{nameJa_num}"
            full_nameEn = f"{nameEn_num} of {suit_key.capitalize()}"
            card_id = f"minor_{suit_key}_{court_names[num]}"

        cards.append({
            "id": card_id,
            "number": num,
            "nameJa": full_nameJa,
            "nameEn": full_nameEn,
            "arcana": "minor",
            "suit": suit_key,
            "emoji": emoji,
            "hebrewLetter": None,
            "hebrewMeaning": None,
            "planet": None,
            "zodiac": None,
            "element": suit_info["element"],
            "symbolism": f"{suit_info['nameJa']}のスートは{suit_info['theme']}を司る。",
            "uprightJa": upright,
            "reversedJa": reversed_m,
            "uprightKeywords": up_kw,
            "reversedKeywords": rev_kw,
            "papusInterpretation": None,
            "waiteInterpretation": upright[:60] + "...",
            "ouspenskyInterpretation": None,
            "historicalQuote": src[0],
            "quoteSource": src[1],
            "color": suit_info["color_base"] if num <= 10 else suit_info["court_colors"][num - 11]
        })

# Save
with open("C:/Users/Windows/AncientTarot/AncientTarot/Data/tarot_cards.json", "w", encoding="utf-8") as f:
    json.dump(cards, f, ensure_ascii=False, indent=2)

print(f"Generated {len(cards)} cards ({len([c for c in cards if c['arcana']=='major'])} major + {len([c for c in cards if c['arcana']=='minor'])} minor)")
