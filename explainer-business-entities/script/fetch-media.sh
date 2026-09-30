#!/usr/bin/env bash
# Downloads the Higgsfield-generated voice-over (Seed Speech) and Kling clips into assets/.
# Requires network access to d8j0ntlcm91z4.cloudfront.net.
set -euo pipefail
cd "$(dirname "$0")/.."
B=https://d8j0ntlcm91z4.cloudfront.net/user_321Q5XgAzStJz6ElCxpPKxKEED6/hf_20260930_
get() { [ -s "$2" ] || { curl -fsSL --retry 3 -o "$2" "$B$1" && touch "$2.new"; }; echo "ok  $2"; }
mkdir -p assets/audio assets/video
while read -r id u; do get "$u.mp3" "assets/audio/$id.mp3"; done <<'LIST'
s01 064410_e6878ca3-5b09-42c4-be82-ba1094fad2ef
s02 064555_5561befb-e85b-48fb-ad8f-d6c6549659fb
s03 064724_08ed2a93-090a-43cd-b5bd-0ec83d26d203
s04 064555_52d84363-e97b-4607-89dc-0d0063300df0
s05 064555_8a36057f-3fb3-4115-a3d6-ebc7d6f38587
s06 064555_7527b1aa-e451-4f9f-a6d8-2a972cc7b230
s07 064555_d50a9951-27b9-4404-86e3-c0c235d37bfc
s08 064555_32617c36-bf16-4768-91f8-19e3620692c7
s09 064555_b43117d4-0884-4edb-a43c-01ecc1b7093e
s10 064555_20a5156c-cd5d-49a7-9211-04fbc9dd4ae3
s11 064555_75e70a69-675f-436e-9f75-6545b6238697
s12 064555_a2058473-e8ec-4b00-9445-952c3b8cb843
s13 064555_904caf23-9abe-47f7-be01-74b3bc4440ed
s14 064725_220c881d-b6cf-4633-b29e-aa30c64ffccd
s15 064724_02517398-e511-4fa8-bd74-bd1ef2a595c6
s16 064724_03e64835-5db4-4f60-ad22-1a8da51e46dc
s17 064738_a3af71a8-c71e-4cfb-8a7e-111d78e8d80c
s18 064738_59ccf3f2-98a5-470a-88ee-cdc0bed90e8b
s19 064738_530ae196-7ef1-48ac-9998-45d85448ab3f
s20 064737_aeb1f7d0-4352-48d3-a8ca-11939fe620d8
s21 064754_a0cf2044-462a-4fa3-ae7b-3b2175c4477e
s22 064754_622eb14e-27b5-46d3-a1c2-60119cbdcc66
s23 064754_ffd4c8ad-adbd-438f-8f35-ff2e6dcaaf5f
s24 064754_0bfacc49-7aa7-47e6-aa7d-5ff23de9fc98
s25 064754_d737a1c9-784f-4097-a0bf-cdc49957681f
s26 064603_b17e19fc-7c0b-4c62-a69e-c66fb1cd2fb9
s27 064602_9ce03eef-d543-43f5-93cf-b07f84eed6ab
LIST
while read -r id u; do get "$u.mp4" "assets/video/$id.mp4"; done <<'LIST'
sign 064605_8a3ea4a6-b817-4ba8-a18a-8721b9951019
tower 064604_8399ecbb-5b94-4b5a-a068-b20f77d4ac1c
board 064605_af89c16c-3e50-427f-aabe-6fbea58176ee
golf 064605_f0fa1dc8-d1be-472a-aa70-8eb445a11587
port 064605_c442a3ef-d1e2-4c29-8f2f-bd2d403fcc60
brain 064605_6444bec9-3ab6-4e0a-8ffd-3f5cbd67901b
LIST
# Kling clips ship with ~5s keyframe intervals, which makes seeks freeze; re-encode fresh downloads with a keyframe every second.
for f in assets/video/*.mp4; do
  if [ -e "$f.new" ]; then
    ffmpeg -loglevel error -y -i "$f" -an -c:v libx264 -crf 16 -r 30 -g 30 -keyint_min 30 -pix_fmt yuv420p -movflags +faststart "$f.tmp.mp4" \
      && mv "$f.tmp.mp4" "$f" && rm "$f.new"
  fi
done
