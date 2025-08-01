#!/bin/bash

dir=$1
cd $dir
rm  -fr _metadata manifest.fingerprint ../src
sed -i.bak 's/function\s\([a-z]\{1,\}([a-z0-9]\{1,\})\){return\s\{1,\}[a-z0-9]\{1,\}===[a-zA-Z0-9\.]\{1,\}}/function \1{return !0}/g' content.js
patchResult=$(diff content.js.bak content.js |grep -c -e "^<")
rm content.js.bak
sed -i '/differential_fingerprint/d' manifest.json
sed -i '/key/d' manifest.json
sed -i 's/"version":\s\{1,\}"\(.*\)"/"version": "99.\1"/' manifest.json
sed -i 's/"update_url":\s\{1,\}"\(.*\)"/"update_url": "https:\/\/raw.githubusercontent.com\/rqx110\/octotree\/master\/update.xml"/' manifest.json
cd ..

ver=$2
sed -i "s/\"\sversion=\"[0-9\.]*\"/\" version=\"99.${ver}\"/" update.xml
mv $dir src
echo $patchResult