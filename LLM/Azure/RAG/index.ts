import * as pulumi from "@pulumi/pulumi";
import * as resources from "@pulumi/azure-native/resources";
import * as storage from "@pulumi/azure-native/storage";
import * as search from "@pulumi/azure-native/search";
import * as cognitiveservices from "@pulumi/azure-native/cognitiveservices";
import * as azureNative from '@pulumi/azure-native';

const config = new pulumi.Config();
const project = config.get("project") as string
const environment = pulumi.getStack();
const aiAccountTier = config.get("aiAccountTier") as string
const model = config.get("model") as string
const modelVersion = config.get("modelVersion") as string

const tags = {
    project,
    environment,
}

// Create an Azure Resource Group
const resourceGroup = new resources.ResourceGroup(project);

// Create an Azure resource (Storage Account)
const storageAccount = new storage.StorageAccount(project, {
    accountName: project,
    resourceGroupName: resourceGroup.name,
    sku: {
        name: storage.SkuName.Standard_LRS,
    },
    kind: storage.Kind.StorageV2,
});

// Create a Blob Container
const container = new storage.BlobContainer("datasource", {
    accountName: storageAccount.name,
    publicAccess: storage.PublicAccess.None,
    resourceGroupName: resourceGroup.name,
});

const aiAccount = new cognitiveservices.Account(project, {
    accountName: project,
    kind: "OpenAI",
    resourceGroupName: resourceGroup.name,
    sku: {
        name: aiAccountTier,
    },
    tags: tags,
});

const modelDeployment = new cognitiveservices.Deployment('playground', {
    accountName: aiAccount.name,
    deploymentName: project,
    resourceGroupName: resourceGroup.name,
    properties: {
        model: {
            format: "OpenAI",
            name: model,
            version: modelVersion,
        },
    },
    sku: {
        capacity: 1,
        name: "Standard",
    }
})

// Create an Azure Cognitive Search service
const searchService = new azureNative.search.Service("blob-search", {
    resourceGroupName: resourceGroup.name,
    searchServiceName: project,
    sku: {
        name: search.SkuName.Standard,
    },
    location: resourceGroup.location,
    tags,
});

export const primaryStorageKey = storageAccount.id;
export const modelId = modelDeployment.id;
export const searchServiceId = searchService.id;
export const storageId = container.id;