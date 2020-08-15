This repo uses terraform as IAC tool to provision infrastructure for Bank.

Here, I have used aws provider with S3 backend to store terraform state and also used Dyanmodb for Locking of state file on S3.

VPC with CIDR Block 10.0.0.0/16.

Varibles and terraform.tfvars for vraribles used by .tf files

Created two Subnets(Public and Private).

created Internet agteway,Nat gateway, Elastic IP for Nat gateway. Created neccessary routes in route table given in subnets.tf file.

s3role.tf for s3 access role and later used by ec2 insances.

resources.tf file provisions Load Balancer, ASG with LC, and usig bootstrapping installed apache(httpd). It also contains Ploicy and neccessary alarms for Scale in and Scale out of instnaces in ASG.

rds.tf used for persistance Layer(db) and connected with ec2 instances using Security groups.
