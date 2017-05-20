module "drone_balancer" {
    source = "../../modules/route53_balancer"
    domain = "ci.hashbang.sh"
    name = "droneci-balancer"
    asg = "${module.drone_asg.id}"
    launch_topic = "${module.drone_asg.launch_topic}"
    terminate_topic = "${module.drone_asg.terminate_topic}"
}

module "drone_asg" {
    source = "../../modules/coreos_asg"
    name = "drone"
    key_name = "admin"
    subnets = "${module.vpc.public_subnets}"
    vpc_id = "${module.vpc.vpc_id}"
    kms_key_id = "8c2d565d-1998-4c82-baba-50c98fc2841e"
    cloud_config = "${data.template_file.cloud_config.rendered}"
}

data "template_file" "cloud_config" {
    template = "${file("${path.module}/files/drone-cloud-config.yml")}"
    vars {
        aws_region = "us-west-2"
        kms_drone_github_client = "AQICAHgdKTQKPCVSxRc0j0autqD7bCgQSjpitnlAfGw9dPM7RwFyqCRmVD71lSGwEOCO2EepAAAAcjBwBgkqhkiG9w0BBwagYzBhAgEAMFwGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM4Ct8bkQtrK2s1m4EAgEQgC8rNab4vAJuzTxrB6/2O3q+Z4QnDQ6YJGPMY1pIWP9RXPMZ45lPmDpwiouKO9TcPg=="
        kms_drone_github_secret = "AQICAHgdKTQKPCVSxRc0j0autqD7bCgQSjpitnlAfGw9dPM7RwHuoOEi30zJqK76A1SsLI5aAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDEI8ORtXn4gamHlUbgIBEIBD5GIJ//Fr8XRmvmy1Zht+04HIkXnNqnPwPJNlHEGPmop8K63WYxuDEZpZAtY7dY1c+E7omAUNCS5vKSPBQ1zePjDpzQ=="
        kms_drone_secret = "AQICAHgdKTQKPCVSxRc0j0autqD7bCgQSjpitnlAfGw9dPM7RwEfn8AuPpq5mUHeHCd/Qe9SAAAAkjCBjwYJKoZIhvcNAQcGoIGBMH8CAQAwegYJKoZIhvcNAQcBMB4GCWCGSAFlAwQBLjARBAyxt5KAogGEsGdDiXwCARCATWFPSW/o0t5i9Qy72CeyYtYmTjM8Pq85VRJ3rc6jD52DAhYkp1lFgvMaV0UmPCU/awdQN55Kj+lQrvi6JWi7K75BvkVNDzBUP6F2vu+J"
        drone_orgs = "hashbang"
        decrypt_script = "${file("${path.module}/files/decrypt.sh")}"
        efs_id = "${module.drone_asg.efs_id}"
        domain = "ci.hashbang.sh"
        drone_admins = "dpflug,daurnimator,deviavir,drgrove,kellerfuchs,lrvick,ryansquared,singlerider"
    }
}
