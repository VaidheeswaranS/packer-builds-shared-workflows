#!/bin/bash

resource_group=$1
shared_gallery=$2
shared_image_definition=$3
location="eastus" 
publisher="MicrosoftWindowsServer"
offer="WindowsServer"
sku="2022-datacenter-g2"
os_type="Windows"
architecture="x64"
hypervisor_generation="V2"
features_security_type="SecurityType=Standard"

if az group show --name "$resource_group" &>/dev/null; then
    echo "Resource group already exists"
else
    echo "Creating the resource group"
    az group create --name "$resource_group" --location $location
    echo "Resource group is created successfully"
fi

if az sig show --resource-group "$resource_group" --gallery-name "$shared_gallery" &>/dev/null; then
    echo "Shared gallery already exists"
else
    echo "Creating the shared gallery"
    az sig create --resource-group "$resource_group" --gallery-name "$shared_gallery" --location $location
    echo "Shared gallery is created successfully"
fi

if az sig image-definition show --resource-group "$resource_group" --gallery-name "$shared_gallery" --gallery-image-definition "$shared_image_definition" &>/dev/null; then
    echo "Shared gallery image definition already exists"
else
    echo "Creating the shared gallery image definition"
    az sig image-definition create --resource-group "$resource_group" --gallery-name "$shared_gallery" --gallery-image-definition "$shared_image_definition" --publisher "$publisher" --offer "$offer" --sku "$sku" --os-type "$os_type" --architecture $architecture --hyper-v-generation "$hypervisor_generation" --features $features_security_type
    echo "Shared gallery image definition is created successfully"
fi