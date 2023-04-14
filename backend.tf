terraform {
  backend "s3" {
    bucket = "testingci90pipeline5682wel98laq23"
    key    = "dev/cloudResume.tfstate"
    region = "us-west-1"
  }
}