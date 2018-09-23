# terraform

## Making changes

Set up your current shell to use Hashbang AWS credentials.
Once ran, ensure that you do not use this shell for other things.

```bash
read AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY <<< $(pass Hashbang/aws/terraform | tr "\n" " ")
export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
```

Run terraform init.

```bash
terraform init
``` 

### Previewing changes

```bash
terraform plan
```

Verify your changes are executed as you'd like.


### Deploying

```bash
terraform apply
```


## Starting from scratch

### Console

Log in to the AWS and navigate to the `CloudFormation` service. Create a new stack, import `terraform-seed.yaml`. Complete the stack creation and make sure it gets set up.

### CLI

```bash
aws cloudformation deploy --template-file terraform-seed.yaml --stack-name hashbang-terraform
```
