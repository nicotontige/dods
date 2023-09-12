#!/bin/bash
# configuration server file location

FILE_PATH="/app/dod/cfg/server.cfg"

echo "#################################"
echo "# Starting server configuration #"
echo "#################################"
echo ""
echo "######"
echo "PLUGIN"
echo "######"
if [ "$PLUGIN_mapchooser" = "true" ]; then
  echo "mapchooser plugin -> Enabled"
  mv /app/dod/addons/sourcemod/plugins/disabled/mapchooser.smx ./dod/addons/sourcemod/plugins/
else
  echo "mapchooser plugin -> Disabled"
fi

if [ "$PLUGIN_rockthevote" = "true" ]; then
  echo "rockthevote plugin -> Enabled"
  mv /app/dod/addons/sourcemod/plugins/disabled/rockthevote.smx ./dod/addons/sourcemod/plugins/
else
  echo "rockthevote plugin -> Disabled"
fi

if [ "$PLUGIN_nominations" = "true" ]; then
  echo "nominations plugin -> Enabled"
  mv /app/dod/addons/sourcemod/plugins/disabled/nominations.smx ./dod/addons/sourcemod/plugins/
else
  echo "nominations plugin -> Disabled"
fi

if [ "$PLUGIN_randomcycle" = "true" ]; then
  echo "randomcycle plugin -> Enabled"
  mv /app/dod/addons/sourcemod/plugins/disabled/randomcycle.smx ./dod/addons/sourcemod/plugins/
else
  echo "randomcycle plugin -> Disabled"
fi

echo ""
echo "#############"
echo "CONFIGURATION"
echo "#############"
# Iterate environment variable
IFS=$'\n'
for env_var in $(env | grep '^DODS_'); do
    variable_name=$(echo $env_var | cut -d "=" -f 1)
    variable_value=$(echo $env_var | cut -d "=" -f 2)
    # Extract variable prefix by "DODS_"
    variable_name=${variable_name#DODS_}
    echo "$variable_name -> $variable_value"
    # Looking and replace the value
    sed -i "/^$variable_name/d" "$FILE_PATH"
    echo "$variable_name $variable_value" >> $FILE_PATH
done
unset IFS

echo ""
echo "###"
echo "MAP"
echo "###"
MAP="${START_MAP:-dod_avalanche}"
echo "First map -> $MAP"

echo ""
echo "###"
echo "END"
echo "###"

./srcds_run -game dod +map $MAP
