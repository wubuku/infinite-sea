#!/bin/bash

# External Package IDs

# The following are the object IDs of the SUI objects that are used in the following script.
# Make sure the amounts of the following SUI objects are greater than 200000000
sui_coin_object_id_1="0xfdf3344392babaf053e0293218cb901236dd43c3abf52a1cf3b5af17ee1b9e20"
sui_coin_object_id_2="0xdd4aea51975a506e1e5451e38f340c3444ae03c4b2533afd04253f7a53a8b4d0"

# -------- Constants --------
move_toml_file="Move.toml"
move_toml_temp="Move-temp.toml"

# ----------------------------------------------------------------------------------------
# Publish coin package
cd infinite-sea-coin
log_file="../testnet-publish.log"
echo "#-------- publish coin package --------" | tee -a "$log_file"
publish_json_file="testnet_coin_publish.json"

sui client publish --gas-budget 200000000 --skip-fetch-latest-git-deps --skip-dependency-verification --json > "$publish_json_file"

publish_coin_txn_digest=$(jq -r '.digest' "$publish_json_file")
echo "publish coin package txn_digest: $publish_coin_txn_digest" | tee -a "$log_file"

if [ -z "$publish_coin_txn_digest" ]
then
echo "The publish_coin_txn_digest is empty, exit the script." | tee -a "$log_file"
exit 1
fi

coin_package_id=$(jq -r '.objectChanges[] | select(.type == "published").packageId' "$publish_json_file")
echo "coin package_id: $coin_package_id" | tee -a "$log_file"
echo "" | tee -a "$log_file"

while read -r line
do
  objectType=$(echo "$line" | jq -r '.objectType')
  echo "objectType: $objectType" | tee -a "$log_file"
  objectId=$(echo "$line" | jq -r '.objectId')
  echo "objectId: $objectId" | tee -a "$log_file"
  echo "" | tee -a "$log_file"
done < <(jq -c '.objectChanges[] | select(.type == "created")' "$publish_json_file")

# -------- update coin Move.toml --------
# read every line of Move.toml
while read -r line
do
# if the line starts with "published-at =", then add "#" in front of it
if [[ $line == "published-at ="* ]]
  then
    echo "#$line" >> $move_toml_temp
# if the line is "[package]", then add "published-at = $package_id" below it
elif [[ $line == "[package]" ]]
  then
    echo "$line" >> $move_toml_temp
    echo "published-at = \"$coin_package_id\"" >> $move_toml_temp
elif [[ $line == "infinite_sea_coin ="* ]]
  then
    echo "#$line" >> $move_toml_temp
# if the line is "[addresses]", then add a line below it
elif [[ $line == "[addresses]" ]]
  then
    echo "$line" >> $move_toml_temp
    echo "infinite_sea_coin = \"$coin_package_id\"" >> $move_toml_temp
# else, keep the line unchanged
else
  echo "$line" >> $move_toml_temp
fi
done < $move_toml_file

# replace the original file with the temp file
mv $move_toml_temp $move_toml_file
cd ..

#exit 1

# ----------------------------------------------------------------------------------------
# Publish common package

cd infinite-sea-common
log_file="../testnet-publish.log"
echo "#-------- publish common package --------" | tee -a "$log_file"
publish_json_file="testnet_common_publish.json"

sui client publish --gas-budget 800000000 --skip-fetch-latest-git-deps --skip-dependency-verification --json > "$publish_json_file"

publish_common_txn_digest=$(jq -r '.digest' "$publish_json_file")
echo "publish common package txn_digest: $publish_common_txn_digest" | tee -a "$log_file"

if [ -z "$publish_common_txn_digest" ]
then
echo "The publish_common_txn_digest is empty, exit the script." | tee -a "$log_file"
exit 1
fi

common_package_id=$(jq -r '.objectChanges[] | select(.type == "published").packageId' "$publish_json_file")
echo "common package_id: $common_package_id" | tee -a "$log_file"
echo "" | tee -a "$log_file"

#nft_service_config_object_id=""
#nft_service_config_cap_object_id=""
#exchange_object_id=""
#
#while read -r line
#do
#  objectType=$(echo "$line" | jq -r '.objectType')
#  echo "objectType: $objectType" | tee -a "$log_file"
#  objectId=$(echo "$line" | jq -r '.objectId')
#  echo "objectId: $objectId" | tee -a "$log_file"
#  echo "" | tee -a "$log_file"
#  if [[ $objectType == *::nft_service_config::NftServiceConfig ]]
#  then
#    nft_service_config_object_id=$objectId
#  elif [[ $objectType == *::nft_service_config::NftServiceConfigCap ]]
#  then
#    nft_service_config_cap_object_id=$objectId
#  elif [[ $objectType == *::exchange::Exchange ]]
#  then
#    exchange_object_id=$objectId
#  fi
#done < <(jq -c '.objectChanges[] | select(.type == "created")' "$publish_json_file")
#echo "nft_service_config_object_id: $nft_service_config_object_id"
#echo "nft_service_config_cap_object_id: $nft_service_config_cap_object_id"
#echo "exchange_object_id: $exchange_object_id"

# -------- update common Move.toml --------
while read -r line
do
if [[ $line == "published-at ="* ]]
  then
    echo "#$line" >> $move_toml_temp
elif [[ $line == "[package]" ]]
  then
    echo "$line" >> $move_toml_temp
    echo "published-at = \"$common_package_id\"" >> $move_toml_temp
elif [[ $line == "infinite_sea_common ="* ]]
  then
    echo "#$line" >> $move_toml_temp
elif [[ $line == "[addresses]" ]]
  then
    echo "$line" >> $move_toml_temp
    echo "infinite_sea_common = \"$common_package_id\"" >> $move_toml_temp
else
  echo "$line" >> $move_toml_temp
fi
done < $move_toml_file

mv $move_toml_temp $move_toml_file
cd ..


# ----------------------------------------------------------------------------------------
# Publish default package

cd infinite-sea
log_file="../testnet-publish.log"
echo "#-------- publish default package --------" | tee -a "$log_file"
publish_json_file="testnet_default_publish.json"

sui client publish --gas-budget 800000000 --skip-fetch-latest-git-deps --skip-dependency-verification --json > "$publish_json_file"

publish_default_txn_digest=$(jq -r '.digest' "$publish_json_file")
echo "publish default package txn_digest: $publish_default_txn_digest" | tee -a "$log_file"

if [ -z "$publish_default_txn_digest" ]
then
echo "The publish_default_txn_digest is empty, exit the script." | tee -a "$log_file"
exit 1
fi

default_package_id=$(jq -r '.objectChanges[] | select(.type == "published").packageId' "$publish_json_file")
echo "default package_id: $default_package_id" | tee -a "$log_file"
echo "" | tee -a "$log_file"

# -------- update default Move.toml --------
while read -r line
do
if [[ $line == "published-at ="* ]]
  then
    echo "#$line" >> $move_toml_temp
elif [[ $line == "[package]" ]]
  then
    echo "$line" >> $move_toml_temp
    echo "published-at = \"$default_package_id\"" >> $move_toml_temp
elif [[ $line == "infinite_sea_default ="* ]]
  then
    echo "#$line" >> $move_toml_temp
elif [[ $line == "[addresses]" ]]
  then
    echo "$line" >> $move_toml_temp
    echo "infinite_sea = \"$default_package_id\"" >> $move_toml_temp
else
  echo "$line" >> $move_toml_temp
fi
done < $move_toml_file

mv $move_toml_temp $move_toml_file
cd ..

