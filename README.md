# Running Ansible from Terraform

---

## Provisioning

Edit the `variables.tf` files and put your VPC ID and Subnet(public)

- Plan
  `terraform plan`
- Apply
  `terraform apply`
  - this will provision the ec2 and install docker and docker compose as plugin
- Destroy
  `terraform destroy`

## Modules

| Modules  | Source          | Version |
| -------- | --------------- |----------
| ec2      | modules/ec2     |
| sshkey   | modules/sshkey  |

## Outputs

| Name           | Description                 |
| -------------- | --------------------------- |
| ec2_public_ip  | Assigned public ip from EIP |
