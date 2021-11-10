#!/bin/bash -x
set -aex

export VAULT_ADDR='http://127.0.0.1:8200'

vault auth enable gcp

vault write auth/gcp/config credentials=@vault-tester.json

vault policy write mypolicy - <<POL
path "gcp/static-account/my-key-account/key"
{
capabilities = ["create","update","read","list"]
}
POL

vault write auth/gcp/role/my-iam-role  type="iam" policies="mypolicy"  bound_service_accounts=*

vault login -method=gcp role="my-iam-role" service_account="vault-tester@my-project-1234-285014.iam.gserviceaccount.com" jwt_exp="15m" credentials=@vault-tester.json
