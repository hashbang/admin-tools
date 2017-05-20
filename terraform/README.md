# terraform

### init

##### Console

Log in to the AWS and navigate to the `CloudFormation` service. Create a new stack, import `terraform-seed.yaml`. Complete the stack creation and make sure it gets set up.

##### CLI

Make sure you completed `aws configure`.

```
aws cloudformation deploy --template-file terraform-seed.yaml --stack-name hashbang-terraform
```

##### Verify

Run terraform init.

```
make init
```

Plan terraform changes, to verify.

```
make plan
```


### plan & apply

```
make plan
```

verify your changes are executed as you'd like.

```
make apply
```

follow the stream, and verify your changes have been applied using the AWS Console or CLI.

### others

```
make ${your_action_here}
```

### Secrets

Secrets in AWS are managed via KMS

Each project should have a unique key

#### Generate Key
```
aws kms create-key \
  --profile hashbang \
  --description "some-app" \
  --region us-west-2
```

#### Encrypt Secret
```
aws kms encrypt \
  --profile hashbang \
  --key-id fe5d40fe-dcf6-1558-4080-096648020239 \
  --plaintext "$(pass Hashbang/someapp | head -n1)" \
  --output text --query CiphertextBlob
```
