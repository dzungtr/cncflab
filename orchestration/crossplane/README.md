# Crossplane - Cloud resources managed tool


### Getting started

```shell
# Start localstack for AWS cloud simulation
./scripts/start-localstack.sh
# start kind cluster
kind create cluster --config k8s-distribution/kind/default.yml
# install crossplan
kustomize build orchestration/crossplane --enable-helm | kubectl apply -f -
```

> You may need to retry install crossplane command few times due to CRD creation step is run paralell with CRD installation and fail

Verify Crossplane has been successfully installed

```shell
> k8s get all -n orchestration
NAME                                                           READY   STATUS    RESTARTS   AGE
pod/crossplane-869cdfbcdd-v7lmd                                1/1     Running   0          9m51s
pod/crossplane-rbac-manager-f9458595b-mjkpw                    1/1     Running   0          9m51s
pod/provider-aws-s3-13463c1ac7d2-54b4ffcddd-xw8zc              1/1     Running   0          9m4s
pod/upbound-provider-family-aws-8f2ee5e4b138-7d9bdbfb5-7w5zl   1/1     Running   0          9m6s

NAME                                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/crossplane-webhooks           ClusterIP   10.96.73.49     <none>        9443/TCP   9m51s
service/provider-aws-s3               ClusterIP   10.96.62.116    <none>        9443/TCP   9m5s
service/upbound-provider-family-aws   ClusterIP   10.96.230.201   <none>        9443/TCP   9m7s

NAME                                                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/crossplane                                 1/1     1            1           9m51s
deployment.apps/crossplane-rbac-manager                    1/1     1            1           9m51s
deployment.apps/provider-aws-s3-13463c1ac7d2               1/1     1            1           9m4s
deployment.apps/upbound-provider-family-aws-8f2ee5e4b138   1/1     1            1           9m6s

NAME                                                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/crossplane-869cdfbcdd                                1         1         1       9m51s
replicaset.apps/crossplane-rbac-manager-f9458595b                    1         1         1       9m51s
replicaset.apps/provider-aws-s3-13463c1ac7d2-54b4ffcddd              1         1         1       9m4s
replicaset.apps/upbound-provider-family-aws-8f2ee5e4b138-7d9bdbfb5   1         1         1       9m6s
```

Verify CRD has been successfully installed

```shell
> k8s api-resources | grep upbound
providerconfigs                                         aws.upbound.io/v1beta1                 false        ProviderConfig
providerconfigusages                                    aws.upbound.io/v1beta1                 false        ProviderConfigUsage
storeconfigs                                            aws.upbound.io/v1alpha1                false        StoreConfig
bucketaccelerateconfigurations                          s3.aws.upbound.io/v1beta1              false        BucketAccelerateConfiguration
bucketacls                                              s3.aws.upbound.io/v1beta1              false        BucketACL
bucketanalyticsconfigurations                           s3.aws.upbound.io/v1beta1              false        BucketAnalyticsConfiguration
bucketcorsconfigurations                                s3.aws.upbound.io/v1beta1              false        BucketCorsConfiguration
bucketintelligenttieringconfigurations                  s3.aws.upbound.io/v1beta1              false        BucketIntelligentTieringConfiguration
bucketinventories                                       s3.aws.upbound.io/v1beta1              false        BucketInventory
bucketlifecycleconfigurations                           s3.aws.upbound.io/v1beta1              false        BucketLifecycleConfiguration
bucketloggings                                          s3.aws.upbound.io/v1beta1              false        BucketLogging
bucketmetrics                                           s3.aws.upbound.io/v1beta1              false        BucketMetric
bucketnotifications                                     s3.aws.upbound.io/v1beta1              false        BucketNotification
bucketobjectlockconfigurations                          s3.aws.upbound.io/v1beta1              false        BucketObjectLockConfiguration
bucketobjects                                           s3.aws.upbound.io/v1beta1              false        BucketObject
bucketownershipcontrols                                 s3.aws.upbound.io/v1beta1              false        BucketOwnershipControls
bucketpolicies                                          s3.aws.upbound.io/v1beta1              false        BucketPolicy
bucketpublicaccessblocks                                s3.aws.upbound.io/v1beta1              false        BucketPublicAccessBlock
bucketreplicationconfigurations                         s3.aws.upbound.io/v1beta1              false        BucketReplicationConfiguration
bucketrequestpaymentconfigurations                      s3.aws.upbound.io/v1beta1              false        BucketRequestPaymentConfiguration
buckets                                                 s3.aws.upbound.io/v1beta1              false        Bucket
bucketserversideencryptionconfigurations                s3.aws.upbound.io/v1beta1              false        BucketServerSideEncryptionConfiguration
bucketversionings                                       s3.aws.upbound.io/v1beta1              false        BucketVersioning
bucketwebsiteconfigurations                             s3.aws.upbound.io/v1beta1              false        BucketWebsiteConfiguration
objectcopies                                            s3.aws.upbound.io/v1beta1              false        ObjectCopy
objects                                                 s3.aws.upbound.io/v1beta1              false        Object
```
