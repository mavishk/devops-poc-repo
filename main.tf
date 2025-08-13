provider "aws" {
    region = "us-east-1"
}
module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "~> 19.0"
    cluster_name    = "devops-poc-eks"
    cluster_version = "1.30"
    subnet_ids      = ["subnet-abcde012", "subnet-bcde0123"] // Replace with your VPC subnets
    vpc_id          = "vpc-abcde012"
    eks_managed_node_groups = {
        poc_nodes = {
            min_size     = 3
            max_size     = 3
            desired_size = 3
            instance_types = ["t3.medium"]
        }
    }
}
resource "aws_s3_bucket" "poc_bucket" {
    bucket = "devops-poc-bucket"
    acl    = "private"
    tags = { Name = "devops-poc-bucket" }
}
