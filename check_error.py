#!/usr/bin/env python3
import jwt, time, json, urllib.request, urllib.error, ssl, os

KEY_ID = "JYA5G4738Z"
ISSUER_ID = "2be0734f-943a-4d61-9dc9-5d9045c46fec"
with open(os.path.expanduser("~/.appstoreconnect/private_keys/AuthKey_JYA5G4738Z.p8")) as f:
    PK = f.read()

VERSION_ID = "ad07299f-3581-4d74-9121-6fc0106e7dea"

def token():
    now = int(time.time())
    return jwt.encode({"iss": ISSUER_ID, "iat": now, "exp": now + 1200, "aud": "appstoreconnect-v1"}, PK, algorithm="ES256", headers={"kid": KEY_ID})

url = "https://api.appstoreconnect.apple.com/v1/reviewSubmissionItems"
payload = json.dumps({"data": {"type": "reviewSubmissionItems", "relationships": {
    "reviewSubmission": {"data": {"type": "reviewSubmissions", "id": "fc9c3516-b457-4ec1-b277-2f09cebe690c"}},
    "appStoreVersion": {"data": {"type": "appStoreVersions", "id": VERSION_ID}}
}}}).encode()
req = urllib.request.Request(url, data=payload, method="POST")
req.add_header("Authorization", f"Bearer {token()}")
req.add_header("Content-Type", "application/json")
try:
    with urllib.request.urlopen(req, context=ssl.create_default_context()) as r:
        print(json.dumps(json.loads(r.read()), indent=2))
except urllib.error.HTTPError as e:
    print(json.dumps(json.loads(e.read().decode()), indent=2))
