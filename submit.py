#!/usr/bin/env python3
import jwt, time, json, urllib.request, urllib.error, ssl, os

KEY_ID = "JYA5G4738Z"
ISSUER_ID = "2be0734f-943a-4d61-9dc9-5d9045c46fec"
with open(os.path.expanduser("~/.appstoreconnect/private_keys/AuthKey_JYA5G4738Z.p8")) as f:
    PK = f.read()

APP_ID = "6762175189"
VERSION_ID = "ad07299f-3581-4d74-9121-6fc0106e7dea"

def token():
    now = int(time.time())
    return jwt.encode({"iss": ISSUER_ID, "iat": now, "exp": now + 1200, "aud": "appstoreconnect-v1"}, PK, algorithm="ES256", headers={"kid": KEY_ID})

def api(method, path, payload=None):
    url = f"https://api.appstoreconnect.apple.com/v1/{path}"
    body = json.dumps(payload).encode() if payload else None
    req = urllib.request.Request(url, data=body, method=method)
    req.add_header("Authorization", f"Bearer {token()}")
    req.add_header("Content-Type", "application/json")
    ctx = ssl.create_default_context()
    try:
        with urllib.request.urlopen(req, context=ctx) as r:
            return json.loads(r.read()) if r.status != 204 else {}
    except urllib.error.HTTPError as e:
        err = e.read().decode()
        print(f"ERROR {e.code}: {err[:500]}")
        return json.loads(err) if err else {}

sub = api("POST", "reviewSubmissions", {
    "data": {"type": "reviewSubmissions", "attributes": {"platform": "IOS"},
             "relationships": {"app": {"data": {"type": "apps", "id": APP_ID}}}}})

if "data" in sub:
    sub_id = sub["data"]["id"]
    print(f"Submission: {sub_id}")
    api("POST", "reviewSubmissionItems", {
        "data": {"type": "reviewSubmissionItems",
                 "relationships": {"reviewSubmission": {"data": {"type": "reviewSubmissions", "id": sub_id}},
                                   "appStoreVersion": {"data": {"type": "appStoreVersions", "id": VERSION_ID}}}}})
    confirm = api("PATCH", f"reviewSubmissions/{sub_id}", {
        "data": {"type": "reviewSubmissions", "id": sub_id, "attributes": {"submitted": True}}})
    if "data" in confirm:
        print(f"SUBMITTED! State: {confirm['data']['attributes'].get('state')}")
    else:
        print("Submit failed")
else:
    print("Could not create submission")
