#!/bin/bash
#echo "Unsetting Loki env variables..."
#unset LOKI_AK; unset LOKI_SK; unset LOKI_S3; unset LOKI_REGION; unset LOKI_S3_EP
export LOKI_AK=$(terraform -chdir=./terraform show -json | jq -r '.values.root_module.resources[] | select(.address == "opentelekomcloud_identity_credential_v3.this").values.access') \
  && echo "Successfully loaded LOKI_AK" || echo "Failed to load LOKI_AK"
export LOKI_SK=$(terraform -chdir=./terraform show -json | jq -r '.values.root_module.resources[] | select(.address == "opentelekomcloud_identity_credential_v3.this").values.secret') \
  && echo "Successfully loaded LOKI_SK" || echo "Failed to load LOKI_SK"
export LOKI_S3=$(terraform -chdir=./terraform show -json | jq -r '.values.root_module.resources[] | select(.address == "opentelekomcloud_obs_bucket.this").values.bucket') \
  && echo "Successfully loaded LOKI_S3" || echo "Failed to load LOKI_S3"
export LOKI_REGION=$(terraform -chdir=./terraform show -json | jq -r '.values.root_module.resources[] | select(.address == "opentelekomcloud_obs_bucket.this").values.region') \
  && echo "Successfully loaded LOKI_REGION" || echo "Failed to load LOKI_REGION"
export LOKI_S3_EP=https://obs.${LOKI_REGION}.otc.t-systems.com \
  && echo "Successfully loaded LOKI_S3_EP" || echo "Failed to load LOKI_S3_EP"

