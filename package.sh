
workspace_path='OCSimpleDemo.xcworkspace'
scheme_name='OCSimpleDemo'
app_name='OCSimpleDemo'


xcodebuild clean -workspace $workspace_path -scheme $scheme_name 

start_date=$(date +"%s")

archive_path="/tmp/$app_name.xcarchive"
ipa_path="/tmp/$app_name.ipa"
payload_path="/tmp/Payload"

rm -rf /tmp/*.xcarchive
rm /tmp/*.ipa
rm -rf $payload_path

xcodebuild archive -workspace $workspace_path -scheme $scheme_name -archivePath $archive_path

# mkdir -p $payload_path
# cp -rf $archive_path/Products/Applications/$scheme_name.app/ $payload_path/$scheme_name.app/

# cd /tmp && zip -r $ipa_path ./Payload

# curl -F "file=@$ipa_path" -F "uKey=694b90ea7ebb9c00c1df9981fbd4d74a" -F "_api_key=d2ab397211240f36f38cf01380a8811a" http://upload.pgyer.com/apiv1/app/upload

end_date=$(date +"%s")
time_diff=$(($end_date-$start_date))
echo "finish in time: $(($time_diff / 60))' and $(($time_diff % 60))\" "
