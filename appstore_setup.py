#!/usr/bin/env python3
import jwt, time, json, urllib.request, urllib.error, ssl, os, hashlib

KEY_ID = "JYA5G4738Z"
ISSUER_ID = "2be0734f-943a-4d61-9dc9-5d9045c46fec"
with open(os.path.expanduser("~/.appstoreconnect/private_keys/AuthKey_JYA5G4738Z.p8")) as f:
    PK = f.read()

BUNDLE_ID = "com.tokyonasu.AncientTarot"

def token():
    now = int(time.time())
    return jwt.encode({"iss":ISSUER_ID,"iat":now,"exp":now+1200,"aud":"appstoreconnect-v1"},PK,algorithm="ES256",headers={"kid":KEY_ID})

def api(method, path, data=None):
    url = f"https://api.appstoreconnect.apple.com/v1/{path}"
    body = json.dumps(data).encode() if data else None
    req = urllib.request.Request(url, data=body, method=method)
    req.add_header("Authorization", f"Bearer {token()}")
    req.add_header("Content-Type", "application/json")
    ctx = ssl.create_default_context()
    try:
        with urllib.request.urlopen(req, context=ctx) as r:
            return json.loads(r.read()) if r.status != 204 else {}
    except urllib.error.HTTPError as e:
        err = e.read().decode()
        print(f"ERROR {e.code}: {err[:400]}")
        return json.loads(err) if err else {}

# 1. App
print("=== 1. App ===")
apps = api("GET", f"apps?filter[bundleId]={BUNDLE_ID}")
APP_ID = apps["data"][0]["id"]
print(f"App: {APP_ID}")

# 2. Version
print("=== 2. Version ===")
ver = api("GET", f"apps/{APP_ID}/appStoreVersions?filter[appStoreState]=PREPARE_FOR_SUBMISSION")
VERSION_ID = ver["data"][0]["id"]
print(f"Version: {VERSION_ID}")

# 3. Localization
print("=== 3. Localization ===")
locs = api("GET", f"appStoreVersions/{VERSION_ID}/appStoreVersionLocalizations")
LOC_ID = None
for l in locs.get("data", []):
    if l["attributes"]["locale"] == "ja":
        LOC_ID = l["id"]

desc = (
    "古のタロット - 300冊の魔導書が紡ぐ、本物のタロット占い\n\n"
    "19世紀の三巨匠 Papus(1892)、A.E. Waite(1911)、Ouspensky の解釈を完全収録した、史上最も本格的なタロットアプリ。\n\n"
    "[今日の一枚]\n毎日一枚のカードを引き、古の叡智からメッセージを受け取ります。カードのフリップアニメーションで本物のタロット体験を。\n\n"
    "[三枚引き]\n過去・現在・未来を読み解く基本スプレッド。三つの時間軸からあなたの状況を俯瞰します。\n\n"
    "[ケルト十字]\nA.E. Waite (1911)が体系化した最も有名な10枚スプレッド。現状、障害、基盤、過去、可能性、近未来、自己、環境、希望と恐れ、最終結果を深く読み解きます。\n\n"
    "[全78枚カード図鑑]\n大アルカナ22枚+小アルカナ56枚を完全収録。各カードに正位置・逆位置の意味、象徴解説、ヘブライ文字・惑星・星座の対応表を掲載。\n\n"
    "[三巨匠の解釈]\n大アルカナの各カードにPapus、Waite、Ouspenskyの解釈を並列表示。同じカードを三つの視点から読み比べられる贅沢な体験。\n\n"
    "[特徴]\n- 広告なし・完全買い切り\n- インターネット接続不要\n- 19世紀の古書からの英語原文引用を多数収録\n- ダークなグリモワール(魔導書)デザイン\n- ヘブライ文字・惑星・星座の完全対応表"
)

api("PATCH", f"appStoreVersionLocalizations/{LOC_ID}", {
    "data": {"type": "appStoreVersionLocalizations", "id": LOC_ID,
             "attributes": {"description": desc,
                            "keywords": "タロット,占い,カード,大アルカナ,小アルカナ,ケルト十字,Waite,Papus,魔導書,神秘,オラクル,古書,スプレッド,運勢",
                            "promotionalText": "三巨匠の解釈を完全収録。78枚の完全デッキで本格タロット占い。",
                            "supportUrl": "https://snarfnet.github.io/AncientTarot/privacy.html"}}})
print(f"Localization: {LOC_ID}")

# 4. Categories + Privacy + Age
print("=== 4. App Info ===")
infos = api("GET", f"apps/{APP_ID}/appInfos")
for info in infos.get("data", []):
    if info["attributes"].get("appStoreState") == "PREPARE_FOR_SUBMISSION":
        api("PATCH", f"appInfos/{info['id']}", {
            "data": {"type": "appInfos", "id": info["id"],
                     "relationships": {"primaryCategory": {"data": {"type": "appCategories", "id": "ENTERTAINMENT"}},
                                       "secondaryCategory": {"data": {"type": "appCategories", "id": "LIFESTYLE"}}}}})
        il = api("GET", f"appInfos/{info['id']}/appInfoLocalizations")
        for loc in il.get("data", []):
            if loc["attributes"]["locale"] == "ja":
                api("PATCH", f"appInfoLocalizations/{loc['id']}", {
                    "data": {"type": "appInfoLocalizations", "id": loc["id"],
                             "attributes": {"privacyPolicyUrl": "https://snarfnet.github.io/AncientTarot/privacy.html"}}})
        ar = api("GET", f"appInfos/{info['id']}/ageRatingDeclaration")
        if "data" in ar:
            api("PATCH", f"ageRatingDeclarations/{ar['data']['id']}", {
                "data": {"type": "ageRatingDeclarations", "id": ar["data"]["id"],
                         "attributes": {"alcoholTobaccoOrDrugUseOrReferences": "NONE", "contests": "NONE",
                                        "gambling": False, "gamblingSimulated": "NONE", "horrorOrFearThemes": "NONE",
                                        "matureOrSuggestiveThemes": "NONE", "medicalOrTreatmentInformation": "NONE",
                                        "profanityOrCrudeHumor": "NONE", "sexualContentGraphicAndNudity": "NONE",
                                        "sexualContentOrNudity": "NONE", "violenceCartoonOrFantasy": "NONE",
                                        "violenceRealistic": "NONE", "violenceRealisticProlongedGraphicOrSadistic": "NONE",
                                        "unrestrictedWebAccess": False, "parentalControls": False, "advertising": False,
                                        "userGeneratedContent": False, "messagingAndChat": False,
                                        "healthOrWellnessTopics": False, "lootBox": False, "ageAssurance": False,
                                        "gunsOrOtherWeapons": "NONE", "ageRatingOverride": None}}})
        print("All set")
        break

# 5. Content rights + version
print("=== 5. Content/Version ===")
api("PATCH", f"apps/{APP_ID}", {"data": {"type": "apps", "id": APP_ID, "attributes": {"contentRightsDeclaration": "DOES_NOT_USE_THIRD_PARTY_CONTENT"}}})
api("PATCH", f"appStoreVersions/{VERSION_ID}", {"data": {"type": "appStoreVersions", "id": VERSION_ID, "attributes": {"copyright": "2026 satoshi amasaki", "releaseType": "MANUAL"}}})
print("Done")

# 6. Review
print("=== 6. Review ===")
api("POST", "appStoreReviewDetails", {
    "data": {"type": "appStoreReviewDetails",
             "attributes": {"contactFirstName": "Satoshi", "contactLastName": "Amasaki",
                            "contactEmail": "snarfnet@gmail.com", "contactPhone": "+81 80 2368 9194",
                            "demoAccountRequired": False, "notes": "Tarot reading app. No account needed. No ads."},
             "relationships": {"appStoreVersion": {"data": {"type": "appStoreVersions", "id": VERSION_ID}}}}})
print("Review set")

# 7. Price
print("=== 7. Price ===")
pp = api("GET", f"apps/{APP_ID}/appPricePoints?filter[territory]=JPN&limit=200")
for p in pp.get("data", []):
    price = p["attributes"].get("customerPrice")
    if price and 800 <= float(price) <= 900:
        api("POST", "appPriceSchedules", {
            "data": {"type": "appPriceSchedules",
                     "relationships": {"app": {"data": {"type": "apps", "id": APP_ID}},
                                       "baseTerritory": {"data": {"type": "territories", "id": "JPN"}},
                                       "manualPrices": {"data": [{"type": "appPrices", "id": "${p1}"}]}}},
            "included": [{"type": "appPrices", "id": "${p1}", "attributes": {"startDate": None},
                          "relationships": {"appPricePoint": {"data": {"type": "appPricePoints", "id": p["id"]}}}}]})
        print(f"Price: {price} JPY")
        break

# 8. Build
print("=== 8. Build ===")
builds = api("GET", f"builds?filter[app]={APP_ID}&sort=-uploadedDate&limit=5")
for b in builds.get("data", []):
    state = b["attributes"].get("processingState")
    print(f"Build {b['id']}: {state}")
    if state == "VALID":
        api("PATCH", f"appStoreVersions/{VERSION_ID}", {
            "data": {"type": "appStoreVersions", "id": VERSION_ID,
                     "relationships": {"build": {"data": {"type": "builds", "id": b["id"]}}}}})
        print("Build assigned!")
        break

# 9. Screenshots
print("=== 9. Screenshots ===")
base = os.path.expanduser("~/AncientTarot")
from PIL import Image
for src in ["ss2.png"]:
    sp = os.path.join(base, src)
    if os.path.exists(sp):
        img = Image.open(sp)
        img.resize((1290, 2796), Image.LANCZOS).convert("RGB").save(os.path.join(base, "ss_67.png"))
        img.resize((1284, 2778), Image.LANCZOS).convert("RGB").save(os.path.join(base, "ss_65.png"))
        print(f"Resized {src}")

for dt in ["APP_IPHONE_67", "APP_IPHONE_65"]:
    fn = "ss_67.png" if "67" in dt else "ss_65.png"
    fp = os.path.join(base, fn)
    if not os.path.exists(fp):
        continue
    s = api("POST", "appScreenshotSets", {
        "data": {"type": "appScreenshotSets", "attributes": {"screenshotDisplayType": dt},
                 "relationships": {"appStoreVersionLocalization": {"data": {"type": "appStoreVersionLocalizations", "id": LOC_ID}}}}})
    sid = s.get("data", {}).get("id")
    if not sid:
        continue
    with open(fp, "rb") as f:
        fd = f.read()
    res = api("POST", "appScreenshots", {
        "data": {"type": "appScreenshots", "attributes": {"fileName": fn, "fileSize": len(fd)},
                 "relationships": {"appScreenshotSet": {"data": {"type": "appScreenshotSets", "id": sid}}}}})
    if "data" not in res:
        continue
    ss_id = res["data"]["id"]
    for op in res["data"]["attributes"].get("uploadOperations", []):
        hdrs = {h["name"]: h["value"] for h in op["requestHeaders"]}
        chunk = fd[op["offset"]:op["offset"]+op["length"]]
        rq = urllib.request.Request(op["url"], data=chunk, method="PUT")
        for k, v in hdrs.items():
            rq.add_header(k, v)
        urllib.request.urlopen(rq, context=ssl.create_default_context())
    api("PATCH", f"appScreenshots/{ss_id}", {
        "data": {"type": "appScreenshots", "id": ss_id,
                 "attributes": {"uploaded": True, "sourceFileChecksum": hashlib.md5(fd).hexdigest()}}})
    print(f"Uploaded {fn}")

print(f"\nApp: {APP_ID}, Version: {VERSION_ID}")
print("Next: Set App Privacy (no data collected), then submit")
