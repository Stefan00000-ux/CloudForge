# CloudForge — Self-Service DevSecOps Infrastructure Platform

**CloudForge** is an automated, security-first Infrastructure-as-Code (IaC) platform built with **Terraform**, **AWS**, **tfsec**, and **GitHub Actions**. It transforms raw cloud provisioning into a reusable, 1-click self-service experience.

---

## Architecture & Workflow

```text
[ Developer / User UI (GitHub Workflow Dispatch) ]
                       │
                       ▼
[ GitHub Actions CI/CD Pipeline ]
   ├── 1. Format Validation   ──▶ terraform fmt -check -recursive
   ├── 2. DevSecOps Scanning  ──▶ tfsec Static Security Analysis
   └── 3. Cloud Provisioning  ──▶ Reusable Module (modules/aws-web-cluster)
                                       │
                                       ▼
                        [ AWS Cloud (Multi-Region Ready) ]
                           ├── Custom VPC & Public Subnet
                           ├── Internet Gateway & Route Tables
                           ├── Security Group (HTTP/SSH)
                           └── Auto-Bootstrapped EC2 Nginx Cluster