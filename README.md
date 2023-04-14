# cloud-resume
Built with HTML, CSS, JavaScript, Python and hosted in AWS cloud. The site is secured using AWS CloudFront and data is stored in AWS DynamoDB. 

The infrastructure is setup using Terraform and a continuous integration and deployment pipeline is setup using Github Actions.

# Solution
## Part 1
- To provision an S3 bucket using similar configuration WITHOUT running the code through the CI/CD pipeline:
```bash
terraform init
terraform plan
terraform apply
```

- To provision the S3 bucket WHILE running the code through a CI/CD pipeline, open a pull request.

- To run ```Checkov``` tests on the configuration, 
```bash
$ checkov -f main.tf
```

You can view the static website hosted on the S3 bucket [here](https://onlinerresume8910543.s3.us-west-1.amazonaws.com/content/index.html).
