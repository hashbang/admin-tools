#!/bin/bash
unset IFS
out_path=${1:-/out/secrets.env}
rm "$out_path" 2> /dev/null
for line in $(env | egrep '^KMS_'); do
	kms_key="${line%%=*}"
	key=${kms_key/KMS_/}
	encrypted_value=${line#*=}
	decrypted_value_base64=$( \
		aws kms decrypt \
			--ciphertext-blob fileb://<(echo "$encrypted_value" | base64 -d) \
			--query Plaintext \
			--output text
	)
	decrypted_value=$(echo $decrypted_value_base64 | base64 -d)
	echo "key=$key"
	echo "encrypted_value=$encrypted_value"
	echo "export $key=$decrypted_value" >> "$out_path"
done
