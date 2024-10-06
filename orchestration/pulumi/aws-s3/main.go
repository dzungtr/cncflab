package main

import (
	"github.com/pulumi/pulumi-aws/sdk/v6/go/aws/s3"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func addHtml(ctx *pulumi.Context, bucket *s3.BucketV2) error {
	_, err := s3.NewBucketObject(ctx, "index.html", &s3.BucketObjectArgs{
		Bucket: bucket.ID(),
		Source: pulumi.NewFileAsset("./index.html"),
	})
	if err != nil {
		return err
	}
	return nil
}

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		// Create an AWS resource (S3 Bucket)
		bucket, err := s3.NewBucketV2(ctx, "my-bucket", nil)
		if err != nil {
			return err
		}

		// Export the name of the bucket
		ctx.Export("bucketName", bucket.ID())

		err = addHtml(ctx, bucket)
		if err != nil {
			return err
		}
		return nil
	})
}
