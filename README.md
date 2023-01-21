# vpn-project
Project to setup VPN and Network peering in AWS VPC. This was a project done for learning purposes. VPN is connected via static routing rules.

<!-- Logos -->
![Global Network](/.attachments/network.gif)

<!-- Intro -->
# Introduction
Repository for AWS VPN Gateway and VPC Peering. The EC2 will be ssh ready within the subnet private network once VPN connectivity is established with the assistance of a network engineer for bgp_asn and cidr block distribution. EC2 is used to test iam profile and on-prem connectivity as well as peer connectivity using ICMP. Security group rules harden the network to limit the ingress and egress of all resources. Routes have been configured statically.

<!-- Dir Summary -->
# Directory Guide
* .attachments
  * Contains images and other miscellaneous items for project
* Infrastructure
    * Stores Terraform configuration files
* scripts
  * EC2 user data script
* yaml
    * Stores Microsoft Azure Devops Services CI/CD pipeline configuration files in yaml format

# Before Proceeding make sure to check out VPN documentation:
* Official aws documentation
  * Instructions: https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html

<!-- Dir Tree Structure -->
# Directory Tree Structure

```
```

# Terraform Resources
* VPC
* EC2
* S3
* VPN